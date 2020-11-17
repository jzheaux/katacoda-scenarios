In this step, you'll configure how OAuth 2.0 Bearer Token scopes are translated into granted authorities.
In previous scenarios, the authorities were always `goal:read` and `goal:write`, and it would be nice to keep it that way to make the transition simple.

### Publishing a JwtAuthenticationConverter

With Basic authentication, a `UserDetailsService` takes a username and produces (among other things) a collection of authorities of type `GrantedAuthority`.

With Bearer token authentication, a `JwtAuthenticationConverter` takes a `Jwt` and produces (among other things) a collection of authorities of type `GrantedAuthority`.

By default, `JwtAuthenticationConverter` will take each scope from the `scope` claim and prepend `SCOPE_` onto the front, though this can be configured.

In `src/main/java/io/jzheaux/springsecurity/goals/SecurityConfig.java`{{open}}, publish a `JwtAuthenticationConverter` that removes the `SCOPE_` prefix, like so:

```java
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;

@Bean
JwtAuthenticationConverter authenticationConverter(JwtGrantedAuthoritiesConverter authoritiesConverter) {
  JwtAuthenticationConverter authenticationConverter = new JwtAuthenticationConverter(); 
  authenticationConverter.setJwtGrantedAuthoritiesConverter(authoritiesConverter);
  return authenticationConverter;
}

@Bean
JwtGrantedAuthoritiesConverter authoritiesConverter() {
  JwtGrantedAuthoritiesConverter authoritiesConverter = new JwtGrantedAuthoritiesConverter();
  authoritiesConverter.setAuthorityPrefix(""); // no prefix
  return authoritiesConverter;
}
```

### What Difference Did That Make?

Remember that in `GoalController`, there are definitions like this:

```java
@PreAuthority("hasAuthority('goal:read')")
```

This means that the request will only be granted if the current authentication has an authority called "goal:read".

By default, Spring Security will prepend `SCOPE_` onto each scope it finds in a given bearer token, which would mean creating a granted authority of `SCOPE_goal:read`.
If we stayed with the defaults, nothing would be authorized since `SCOPE_goal:read` is different from `goal:read`.

Removing the prefix makes things still match.
We could have done the opposite and changed the method annotations.

### Testing It Out

With this change, the REST API is ready.

So, restart the REST API by doing `mvn spring-boot:run`{{execute interrupt T2}}, and then navigate to https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com/bearer.html where the app should work as before, except with an authorization server for logging in.

### Run a Test

Each step in the scenario is equipped with a JUnit Test to confirm that everything works.
This first one simply makes sure that Spring Security was set up correctly.

Run it with the Maven command `mvn -Dtest=io.jzheaux.springsecurity.goals.Module4_Tests#task_2 test`{{execute T4}}.

At the end of the test run, you should the message `BUILD SUCCESS`.

### What's Next?

We've looked at a couple of basic features.
Now, let's get a glipse at a more advanced feature: What should we do if we still need to connect the JWT to a real user in our system?
