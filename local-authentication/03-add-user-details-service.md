In this step, you'll customize the user store that Spring Security uses to authenticate requests.

Spring Boot publishes one by default to get you started. That's the one that generates the randomized password.

You can replace the user store by publishing a `UserDetailsService` `@Bean` to the application context, like so:

```java
@Bean
UserDetailsService userDetailsService() {
    // construct an implementation here
}
```

Normally, you should try and consolidate your security configuration into a specific `@Configuration` file.
Since Spring Security is a declarative security framework, making this choice early on means that you'll be able to see your security configuration all in one place.

To get you started, an empty `@Configuration` file called `src/main/java/io/jzheaux/springsecurity/goals/SecurityConfig.java`{{open}} has already been created. 

In this file, publish a custom in-memory `UserDetailsService` that creates a hard-coded user with the password of "password":

```java
import org.springframework.context.annotation.Bean;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;

@Bean
UserDetailsService userDetailsService() {
    UserDetails user = org.springframework.security.core.userdetails.User
            .withUsername("user")
            .password("{bcrypt}$2a$10$1/JJ4w5QOt4ln9ris9ERneYh1tXCuKedk/fjStcJlWGZvTDAha5AG")
            .roles("USER")
            .build();
    return new InMemoryUserDetailsManager(user);
}
```

TIP: We'll not use Spring Security's `User` class after this step, but do use the fully-qualified name since the project also has a class called `User`.

NOTE: `{bcrypt}` is a special prefix that Spring Security understands. When Spring Security needs to compare the password, Spring Security looks at this prefix to know that it should use BCrypt to hash and compare the user's password to the one provided in the request. If it said `{argon}`, then Spring Security would has the given password with Argon instead.

Having done this, restart the application with `mvn spring-boot:run`{{execute interrupt T1}}.

### What Difference Did That Make?

What this did is override the default `UserDetailsService` component.

In many circumstances, publishing a component of a given type will override the default behavior.

Try this out by going into Terminal 2 and running the goals command `http -a user:password :8080/goals`{{execute T2}}.
You should now see the list of goals, the same as before.

### Run a Test

Now check your work with Maven: `mvn -Dtest=io.jzheaux.springsecurity.goals.Module1_Tests#task_2 test`{{execute T2}}.

At the end of the test run, you should the message `BUILD SUCCESS`.

### What's Next?

So, you've learned about the interface that Spring Security uses to identify the user store.

The in-memory implementation isn't very useful, though.
Of course, it's not great to have hard coded users, and in-memory data doesn't work in a clustered environment.

So, next, let's change out the in-memory `UserDetailsService` for one that queries a database.
