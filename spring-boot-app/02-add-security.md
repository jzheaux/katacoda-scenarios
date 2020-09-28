In this step, you'll add Spring Security into the application.

Normally, the way to add Spring Security into a Spring Boot application is by specifying its starter.

For example, you can do this in Maven by specifying a dependency, like so:

```xml
<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

Or similarly in Gradle:

```groovy
compile 'org.springframework.security:spring-boot-starter-security'
```

To simplify some of the other steps later on in the scenario, Spring Security is actually already on the classpath, though.
This means that it's already defined in the Maven POM associated with this project.

To simulate the difference, though, the project has security deliberately shut off.
So, in `src/main/java/io/jzheaux/springsecurity/goals/GoalsApplication.java`{{open}}, find the line that says:

```java
@SpringBootApplication(exclude=SecurityAutoConfiguration.class)
```

and change it to read:

```java
@SpringBootApplication
```

This will switch security back to normal.

Having done that, you can (re)start the application by doing `mvn spring-boot:run`{{execute "T1"}}.

### What Difference Did That Make?

You might be surprised to find out that only by activating the Spring Boot Security starter, you've got a REST API that's secured with HTTP Basic!

Try this out by going into Terminal 2 and running the goals command `http :8080/goals`{{execute "T2"}}.
You'll notice that now it gives you a `401` error instead of the list of goals.

In fact, also try `http :8080/k12n3l1k23`{{execute "T2"}}.
Notice that even a made-up URL is secured by Spring Security.
This gives you the confidence that even if you bring in third-party libraries, those endpoints are secured as well.

To see the `/goals` result again, you're going to need to provide the username and password.
The username by default is "user".

The password is regenerated on startup everytime and printed out to the logs.
The reason for that is so that if you accidentally deploy with the defaults, your application server doesn't become a walking vulnerability with a googleable default password.

To get the generated password, go back to Terminal 1 and search for the word "generated".
Highlight the GUID at the end of that log line.

Then in Terminal 2, type the command `export PASSWORD=`, paste the password at the end of the line, and press `<ENTER>`.
It should look something like this:

```bash
export PASSWORD=23daabef-a3be-fb90-2a3bcdf56
```

After that, you can hit the `/goals` endpoint again, this time using the default user and generated password: `http -a user:$PASSWORD :8080/goals`{{execute "T2"}}

### Run a Test

Each step in the scenario is equipped with a JUnit Test to confirm that everything works.
This first one simply makes sure that Spring Security was set up correctly.

Run it with the Maven command `mvn -Dtest=io.jzheaux.springsecurity.goals.Module1_Tests#task_1 test`{{execute "T2"}}.

At the end of the test run, you should the message `BUILD SUCCESS`.

### What's Next?

In all likelihood, you don't want to deploy your REST API using a generated password!
So, next, let's change out the password for one that we configure.
