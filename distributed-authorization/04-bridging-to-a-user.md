In this step, you'll write some custom code that will translate a JWT into a user that the REST API recognizes.

### Authorization vs Authentication (again)

JWT's are really about authorization.
They aren't an authentication mechanism for a user, but instead for a client application operating on an end user's behalf.

Still, when we write applications, we often think in terms of the end user.
Because of that, it's not uncommon to need to take claims from the JWT, look them up in a database, and return an `Authentication` that contains both.

If this sounds distantly familiar, it's architecturally similar to what you did when you connected Spring Security's `UserDetails` with the REST API's custom `User` object.

This time, you'll connect Spring Security's `Jwt` with the REST API's custom `User` object.

### Merging Authorities

Most of the class in `src/main/java/io/jzheaux/springsecurity/goals/UserRepositoryJwtAuthenticationConverter.java`{{open}} is already completed since it is quite similar to the work you already did in the first scenario with `UserRepositoryUserDetailsService`.

What remains are to assign the authorities and to publish it as a bean.
However, you've got authorities from the `User` and you've got authorities from the `Jwt`.
How should these be combined?

Using the Principle of Least Privilege, we only want to grant those that the user granted to the client.
But, just because the client was granted it, doesn't mean that the user automatically can do it either.

The result is that we want the intersection of the two sets of authorities.

First, in `src/main/java/io/jzheaux/springsecurity/goals/UserRepositoryJwtAuthenticationConverter.java`{{open}}, convert the authorities from the database into a list of `SimpleGrantedAuthority` instances:

```java
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import java.util.stream.Collectors;

// ... 

authorities = user.getUserAuthorities().stream()
  .map((userAuthority) -> new SimpleGrantedAuthority(userAuthority.getAuthority()))
  .collect(Collectors.toList());
```

Then, merge that with what `JwtGrantedAuthoritiesConverter` gives you:

```java
authorities.retainAll(this.authoritiesConverter.convert(jwt));
```

The result is that the client will only get the privileges that the user has and that they granted.


### Custom Domain

You'll also notice that now you have a similar adapter class that is both of type `User` and of type `OAuth2AuthenticatedPrincipal`, or the OAuth equivalent of `UserDetails`.

Let's make one more authority change here to learn something else about authority design.
Imagine that the application has some premium features, like sharing goals with friends.
Even if the client is granted `goal:write`, that doesn't mean that the user can now share goals with their friends.

So, make one more change to this adapter.
If the user is a premium user *and* the client was granted `goal:write`, then grant another authority, `goal:share`.
You can do this after merging the authorities like so:

```java
Collection<String> scopes = AuthorityUtils.authorityListToSet(authorities);
if (user.isPremium() && scopes.contains("goal:write")) {
  authorities.add(new SimpleGrantedAuthority("goal:share"));
}
```

What this does is keep the extra logic about "premium" outside of the controller.
Now, the complex authorization logic has already been executed and the controller can focus on simply matching the authority.

### Updating the Configuration

To publish our changes, in `src/main/java/io/jzheaux/springsecurity/goals/UserRepositoryJwtAuthenticationConverter.java`{{open}}, annotate the class with `@Component` so that it is published to the application context.

Then, make the following two changes to `src/main/java/io/jzheaux/springsecurity/goals/SecurityConfig.java`{{open}}:

* Remove the `authenticationConverter` `@Bean` definition (since `UserRepositoryJwtAuthenticationConverter` replaces it)
* Wire the authentication converter directly onto the DSL

The result should look like the following:

```java
// ...

@Bean
SecurityFilterChain filterChain(HttpSecurity http, UserRepositoryJwtAuthenticationConverter authenticationConverter) throws Exception {
  http
    .cors(Customizer.withDefaults())
    .authorizeRequests((authz) -> authz.anyRequest().authenticated())
    .oauth2ResourceServer((oauth2) -> oauth2
      .jwt((jwt) -> jwt.jwtAuthenticationConverter(authenticationConverter))
    );
}

// ... remove the authenticationConverter bean
```

### Run a Test

Each step in the scenario is equipped with a JUnit Test to confirm that everything works.
This first one simply makes sure that Spring Security was set up correctly.

Run it with the Maven command `mvn -Dtest=io.jzheaux.springsecurity.goals.Module4_Tests#task_3 test`{{execute T4}}.

At the end of the test run, you should the message `BUILD SUCCESS`.

### What's Next?

Notice that there's a third scope that we haven't touched, yet, `user:read`.

What if the user doesn't grant that privilege, how should our application respond?
