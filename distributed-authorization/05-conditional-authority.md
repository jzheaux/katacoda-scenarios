In this final step, you'll change the controller's behavior to conditionally operate depending on whether or not the end user granted the `user:read` scope.

### Programmatic Security

Spring Security is fundamentally declarative, which is a helpful design decision to make in an application.
The less authorization logic that goes inside of a controller, the better.

There are times when including authorization logic in our business logic will be necessary, though.

In `src/main/java/io/jzheaux/springsecurity/goals/GoalController.java`{{open}}, make a change to the `read()` method that only adds the full name if the user granted that privilege to the client, like so:

```java
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

// ...

@GetMapping("/goals")
// ...
public Iterable<Goal> read() {
  Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
  Collection<String> scopes = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
  if (scopes.contains("user:read")) {
    for (Goal goal : goals) {
      addName(goal);
    }
  }
	return goals;
}
```

Now, if the user doesn't grant `user:read` to the client, the user's name won't be included in the result.

### Testing It Out

Restart the application using `mvn spring-boot:run`{{execute T2}}.

Once it's restarted, try logging in again to the application, but this time don't grant the `user:read` privilege.
You should see the goal text, but not the name of the user

### Alternative Solutions

Could we have done something other than adding authorization logic into our business logic? Yes.

An alternative is a separate endpoint.
You can imagine having two goal endpoints, one that requires `goal:read` and another that requires both `goal:read` and `user:read`.

The challenge with this approach is combinatorics.
While it works for this small setup, what if there were many scopes that the user could switch on or off?
It could get messy quickly having to maintain several endpoints, one for each valid combination of scopes.

### Run a Test

Each step in the scenario is equipped with a JUnit Test to confirm that everything works.
This first one simply makes sure that Spring Security was set up correctly.

Run it with the Maven command `mvn -Dtest=io.jzheaux.springsecurity.goals.Module4_Tests#task_4 test`{{execute T4}}.

At the end of the test run, you should the message `BUILD SUCCESS`.

### What's Next?

Great job!

Head over to the end page to see what's next.