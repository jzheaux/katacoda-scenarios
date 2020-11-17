In this step, you'll access the currently logged in user in your controller.

The most straight-forward way to access the currently logged-in user, is to ask for the `Authentication` instance in your controller method, like so:

```java
@PostMapping("/goal")
public Goal make(Authentication currentUser, String text) {
    // ...
}
```

Then, you can get the needed information from `currentUser`, like the username and any domain-specific attributes.

A slightly more powerful way is to use Spring Security's annotation support.
You can create an annotation that indicates what information you need from the `SecurityContext`, and Spring Security will retreive it for you.

For exaple, `src/main/java/io/jzheaux/springsecurity/goals/CurrentUsername.java`{{open}} has already been started for you.
It currently looks like this:

```java
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.PARAMETER)
public @interface CurrentUsername {
}
```

First, annotate this custom annotatino with the `@CurrentSecurityContext` annotation, like so:

```java
import org.springframework.security.core.annotation.CurrentSecurityContext;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.PARAMETER)
@CurrentSecurityContext(expression="authentication.name")
public @interface CurrentUsername {
}
```

The meaning of `authentication.name` is "get the current authentication and call its `getName()` method".

Then, in `src/main/java/io/jzheaux/springsecurity/goals/GoalController.java`{{open}}, change the `make` method to use the annotation, like so:

```java
@PostMapping("/goal")
public Goal make(@CurrentUsername String owner, @RequestBody String text) {
    Goal goal = new Goal(text, owner);
    return this.goals.save(goal);
}
```

Now, restart with `mvn spring-boot:run`{{execute T1}}, and Spring Security will do the work to get the current username and supply it to your method call.

### Testing It Out

As stated earlier, the scneario is equipped with multiple users: `user`, `hasread`, `haswrite`, and `admin`.

Now try creating a goal with one of the other users.

To do this, first run the following helper script to collect the REST API's CSRF token and session ID:

```bash
. ./etc/get-csrf
```{{execute T2}}

NOTE: The leading period in the command is intentional.

Then, create a goal, like so:

```bash
echo "A new day, a new goal" | http -a hasread:password --session=./session.json :8080/goal X-CSRF-TOKEN:$CSRF
```{{execute T2}}

Now when you query the set of goals with `http :8080/goals`{execute T2}, you'll see the new goal belongs to `hasuser` instead of `user`.

### Run a Test

Now check your work with Maven: `mvn -Dtest=io.jzheaux.springsecurity.goals.Module1_Tests#task_4 test`{{execute T2}}.

At the end of the test run, you should the message `BUILD SUCCESS`.

### What's Next?

You've learned how to look up the current user.

Check out the completion page to see what we'll do next.