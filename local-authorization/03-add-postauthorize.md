In this step, you'll use `@PostAuthorize` to check the response value and ensure that it belongs to the current user.

The `Goal` domain object is equipped with a `String owner` field that matches the `username` field in `User`.
While a real application would likely have a more sophisticated foreign-key relationship, this one suits our needs.

The `GET /goal/{id}` endpoint has a security problem in that anyone in possession of the `goal:read` permission and an ID can view the details of that goal.
This isn't good since that means if `hasread` can find out the ID of one of `haswrite`'s goals, then `hasread` can view the details.

Since ownership is typically custom for each application, Spring Security doesn't check for this automatically.
Instead, you can enforce this ownership by adding a `@PostAuthorize` annotation with a SpEL expression that evaluates the returned object.

In `src/main/java/io/jzheaux/springsecurity/goals/GoalController.java`{{open}}, add the `@PostAuthorize` annotation to the `GoalController#read(String)` method like so:

```java
import org.springframework.security.access.prepost.PostAuthorize;

// ...

@GetMapping("/goal/{id}")
@PreAuthorize("hasAuthority('goal:read')")
@PostAuthorize("returnObject.orElse(null)?.owner == authentication.name") // add this line
public Optional<Goal> read(@PathVariable("id") String id) {
    // ...
}
```

And, if the returned object's `owner` field isn't the same as the current user's `username`, then Spring Security will return a `403 Forbidden` error.

### What Does That Expression Mean?

Let's take a minute to break down the SpEL expression.

First, Spring Security makes available the `returnObject` as a variable in your expression.
`returnObject` is your return value.

Second, Spring Security makes available the `authentication` as a variable in your expression.
`authentication` is the current `Authentication` instance from `SecurityContextHolder`, and it represents the current user.

So, since the return type is an `Optional`, you can do `returnObject.orElse(null)` to convert it to a `Goal`.
After that, it's a matter of seeing if the `owner` field is equal to the user's `username`.

### Testing It Out

Now, restart the application with `mvn spring-boot:run`{{execute interrupt T1}}.

Read the goals and save off one of the goal IDs.
You can do this in one line with `jq`:

```bash
export ID=`http -a user:password :8080/goals | jq -r .[0].id`
```{{execute T2}}

Now, try reading that goal with `user`, and then with `hasread`.
Since that goal belongs to `user`, `user` should be able to read it, but `hasread` should not.

First with `user`: `http -a user:password :8080/goal/$ID`{{execute T2}}
And second with `hasread`: `http -a hasread:password :8080/goal/$ID`{{execute T2}}

### Adding It to the Rest

Next, add the same expression to the other methods that return `Optional<Goal>` which are `revise`, `complete`, and `share`.

### Using @PostFilter

While we're here, let's use one more annotation, `@PostFilter`.
This annotation is handy when you are returning a collection, array, map, or stream of values and need Spring Security to filter them based on some authentication expression.

So, as a final step, add the following annotation to the `read()` method:

```java
import org.springframework.security.access.prepost.PostFilter;

@GetMapping("/goals")
@PreAuthorize("hasAuthority('goal:read')")
@PostFilter("filterObject.owner == authentication.name") // add this line
public Iterable<Goal> read() {
    // ...
}
```
The expression `filterObject.owner == authentication.name` means Spring Security should remove any values whose `owner` isn't the same and the current username.

And then restart the application with `mvn spring-boot:run`{{execute interrupt T1}}.

Now, when you query `http -a hasread:password :8080/goals`{{execute T2}}, you'll only see the goals that belong to `hasread` instead of all goals.

### Run a Test

Each step in the scenario is equipped with a JUnit Test to confirm that everything works.
This one checks your `@PostAuthorize` annotations.

Run it with the Maven command `mvn -Dtest=io.jzheaux.springsecurity.goals.Module2_Tests#task_2 test`{{execute T2}}.

At the end of the test run, you should the message `BUILD SUCCESS`.

### What's Next?

Nice work! THis is starting to become a real REST API.

It's time to fix a bug that has probably been bugging you like it's been bugging me.
When you call `GET /goals` it returns all the goals and not just the ones that belong to the user!

Also, you might have noticed an issue with the `complete` and `revise` methods: Since they make changes in the database, it's really important to verify ownership _before_ the goals are changed.

Let's address those in the next step.