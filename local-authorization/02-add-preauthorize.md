In this step, you'll use `@PreAuthorize` to say which users can do what with the application.

For most of the scenario, you'll be using permission-based authorization, meaning your authorization decisions will be based on whether or not the user has the `goal:read` or `goal:write` permission.

Additionally, we'll be using method-based rules, meaning you'll annotation the controller methods with your authorization rules.
Alternatively, you can specify rules in the Spring Security DSL, which we'll introduce a bit later on.

To enable method-based rules, open `src/main/java/io/jzheaux/springsecurity/SecurityConfig.java`{{open}} and annotate the class with `@EnableGlobalMethodSecurity(prePostEnabled = true)`:

```java
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;

@Configuration
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig { ... }
```

This configures Spring Security to pay attention to `@Pre/PostAuthorize` and `@Pre/PostFilter` annotations.

Then, in `src/main/java/io/jzheaux/springsecurity/goals/GoalController.java`{{open}}, add the `@PreAuthorize` annotation to the `GoalController#read` methods.
The method should require that the authentication have the `goal:read` permission.

You can do this by annotating the `read` methods like so:

```java
import org.springframework.security.access.prepost.PreAuthorize;

// ...

@PreAuthorize("hasAuthority('goal:read')")
@GetMapping("/goals")
public Iterable<Goal> read() {
    // ...
}

@PreAuthorize("hasAuthority('goal:read')")
@GetMapping("/goal/{id}")
public Optional<Goal> read(@PathVariable("id") UUID id) {
    // ...
}
```

Having done that, you can restart the application by doing `mvn spring-boot:run`{{execute interrupt T1}}.

### What Difference Did That Make?

The scenario is equipped with a few different users, which you can see declared in `src/main/java/io/jzheaux/springsecurity/goals/GoalInitializer.java`{{open}}:

* `user` has both `goal:read` and `goal:write` permissions
* `hasread` has the `goal:read` permission
* `haswrite` has the `goal:write` permission, and
* `admin` has both `goal:read` and `goal:write` permissions as well as the `ADMIN` _role_ (more on that later)

Try hitting the `GET /goals` endpoint using `hasread` and `haswrite`.

If you try with `hasread` by doing `http -a hasread:password :8080/goals`{{execute T2}}, you should see the list of goals.

If you try with `haswrite` by doing `http -a haswrite:password :8080/goals`{{execute T2}}, you should see a `403 Forbidden` error.
`403` is different from `401`; `403` means the REST API knows the client but the client doesn't have permission.

### Adding the Rest

Go ahead and add the appropriate permissions for the rest of the methods.
If it is a `POST` or `PUT`, require the `goal:write` permission.

When you interact with `POST`, `PUT`, or `DELETE` in Spring Security, you will need to provide a CSRF token.
This application is configured to send one in the response header.

First, do use the helper script `. ./etc/get-csrf`{{execute T2}}.
This uses `http` to write session details to the file system and the CSRF token to the environment.

Then, make the `POST` that includes those values to add a goal:

```bash
echo -n "A New Day, A New Goal" | http -a user:password --session=./session.json :8080/goal X-CSRF-TOKEN:$CSRF
```{{execute T2}}

### Why Do I Need a Session ID and CSRF Token?

These will become clearer once we add a front end that's interacting with our REST API.

Browsers manage sessions and credentials for the end user to some degree.
For example, if an application has a session and it sends that session id down as a cookie to the browser, the browser will send that back up automatically on each request.
(And that's true for HTTP Basic credentials entered into the browser, too.)

While this is a nice feature, it creates a forgery problem.
Since the browser will hand those up automatically, other domains can POST to the REST API, too, without the user knowing.

To prevent this from happening, Spring Security creates a random token that the client and server send back and forth during the session as a form of authentication for the session itself.

We'll see how using a more modern authentication mechanism removes some of this boilerplate in a future scenario.

### Run a Test

Each step in the scenario is equipped with a JUnit Test to confirm that everything works.
This first one checks your `@PreAuthorize` annotations.

Run it with the Maven command `mvn -Dtest=io.jzheaux.springsecurity.goals.Module2_Tests#task_1 test`{{execute T2}}.

At the end of the test run, you should the message `BUILD SUCCESS`.

### What's Next?

If a client knows the ID of a goal, does that mean the client may access that goal?

Usually the answer is "only if that goal belongs to that user".

How can you express that relationship in Spring Security?
Check out the next step to find out.
