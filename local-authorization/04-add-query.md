In this step, you'll modify the `@Query` annotations in `GoalRepository` to verify ownership before making changes to the database.

We can do this with a `WHERE` clause that includes the current user.
In `src/main/java/io/jzheaux/springsecurity/goals/GoalRepository.java`{{open}}, add the current user to the query using the `?#{authentication.name}` Spring Data expression:

```java
@Modifying
@Query("UPDATE Goal SET text = :text WHERE id = :id AND owner = ?#{authentication.name}") // change this line
void revise(UUID id, String text);

@Modifying
@Query("UPDATE Goal SET completed = 1 WHERE id = :id AND owner = ?#{authentication.name}") // change this line
void complete(UUID id);
```

Spring Security and Spring Data collaborate here to allow the current user to be referenced in database queries.
We can use that to enforce authorization rules since the `UPDATE` statement will fail if the `Goal`'s `owner` doesn't match the current user.

### Testing It Out

Now, restart the application with `mvn spring-boot:run`{{execute interrupt T1}}.

After doing that, retrieve one of `user`'s goal IDs by doing:

```bash
export ID=`http -a user:password :8080/goals | jq -r .[0].id`
```{{execute T2}}

Next, retreive the CSRF token by doing `. ./etc/get-csrf`{{execute T2}}.

Then, try and complete `user`'s goal using `haswrite`:

```bash
http -a haswrite:password --session=./session.json PUT :8080/goal/$ID/complete X-CSRF-TOKEN:$CSRF
```{{execute T2}}

You should see a `403 Forbidden` since that goal doesn't belong to `haswrite`.

Finally, try and complete the goal using `user`:

```bash
http -a user:password --session=./session.json PUT :8080/goal/$ID/complete X-CSRF-TOKEN:$CSRF
```{{execute T2}}

And you should see a successful response.

### Run a Test

Each step in the scenario is equipped with a JUnit Test to confirm that everything works.
This one checks your `@Query` annotations.

Run it with the Maven command `mvn -Dtest=io.jzheaux.springsecurity.goals.Module2_Tests#task_3 test`{{execute T2}}.

At the end of the test run, you should the message `BUILD SUCCESS`.

### What's Next?

As you might imagine, authorization rules can get quite complicated, and SpEL can only take us so far.

Let's add some basic admin support in the next step, but move our authorization rules into pure Java.
Doing this gives us access to the entire Java language, the application context, and to the ability to unit test our logic.