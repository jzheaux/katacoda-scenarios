In this step, you'll create a Java bean that executes the authorization rules, instead of embedding the rules into a SpEL expression.

Imagine now that we want to add an `admin` into the system.
There are a number of ways that we can do this, one of them being to add a separate `/admin/**` set of endpoints.

To illustrate authorization with a Java bean, though, we'll use the same set of endpoints for admins as well as for end users.

By the end of this step, an admin user will be able to see everyone's goals, while everyone else will only be able to see their own goals.

### We Could Do This in SpEL

We could add an admin user into our `@PostFilter` and `@PostAuthorize` expressions, like so:

```java
@PostFilter("filterObject.owner == authentication.name || hasRole('ADMIN')")
```

Little changes like this add up quickly, though.

Instead Spring Security supports referencing `@Bean`s in its SpEL expressions.

It would be nice, then, to do something like this instead:

```java
@PostFilter("@post.filter(#root)")
```

Which invokes the authorization logic found in a Spring bean.

### Creating the Bean

A custom authorization bean has already been started for you.

In `src/main/java/io/jzheaux/springsecurity/goals/GoalAuthorizer.java`{{open}}, publish it as a bean and add methods called `filter` and `authorize`:

```java
import org.springframework.security.access.expression.method.MethodSecurityExpressionOperations;
import org.springframework.stereotype.Component;

public class GoalAuthorizer {
    public Boolean filter(MethodSecurityExpressionOperations operations) {

	}

	public Boolean authorize(MethodSecurityExpressionOperations operations) {

	}
}
```

In each method, first add a check for `ADMIN`. If the user is an admin, return `true`:

```java
public Boolean filter(MethodSecurityExpressionOperations operations) {
    if (operations.hasRole("ADMIN")) {
        return true;
    }
}

public Boolean authorize(MethodSecurityExpressionOperations operations) {
    // same as above
}
```

Next, in each method, retreive the `Authentication` and the appropriate return value:

```java
import java.util.Optional;

import org.springframework.security.core.Authentication;

public Boolean filter(MethodSecurityExpressionOperations operations) {
    if (operations.hasRole("ADMIN")) {
        return true;
    }
    Authentication authentication = operations.getAuthentication();
	String owner = ((Goal) operations.getFilterObject().getOwner();
}

public Boolean authorize(MethodSecurityExpressionOperations operations) {
    if (operations.hasRole("ADMIN")) {
        return true;
    }
    Authentication authentication = operations.getAuthentication();
	String owner = ((Optional<Goal>) operations.getReturnObject())
            .map(Goal::getOwner).orElse(null);
}
```

And finally, do the comparison and return the result:

```java
public Boolean filter(MethodSecurityExpressionOperations operations) {
    // ...
    return authentication.getName().equals(owner);
}

public Boolean authorize(MethodSecurityExpressionOperations operations) {
    // ...
    return authentication.getName().equals(owner);
}
```

### Using Our Authorization Bean

Now, you can refer to your `@Bean` in your SpEL expressions.

For `@PostFilter`, you can change it to `@PostFilter("@post.filter(#root)")`.
For `@PostAuthorize`, you can change it to `@PostAuthorize("@post.authorize(#root)")`.

### Testing It Out

Now, restart the application with `mvn spring-boot:run`{{execute interrupt T1}}.

Read the goals as `admin` to see that you can see all goals using `http -a admin:password :8080/goals`.

You should see a successful response.

### Run a Test

Each step in the scenario is equipped with a JUnit Test to confirm that everything works.
This one checks your custom authorizer.

Run it with the Maven command `mvn -Dtest=io.jzheaux.springsecurity.goals.Module2_Tests#task_4 test`{{execute T2}}.

At the end of the test run, you should the message `BUILD SUCCESS`.

### What's Next?

Great job! Go ahead and proceed to the final page to see what else is in store for this REST API.