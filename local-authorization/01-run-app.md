In this first step, you'll start the application and get familiar with the environment.
This scenario is based off of the application you created in the [Local Authentication with Spring Security scenario](https://katacoda.com/jzheaux/local-authorization).

### Starting the Application

The Spring Boot application is Maven-based, so in the Terminal please start the application with `mvn spring-boot:run`{{execute interrupt T1}}.

You should see some output that includes a message similar to

```bash
Starting GoalsApplication on a6130036c349 with PID 8027 (/root/code/target/classes started by root in /root/code)
```

And when the application is ready, you'll see a message similar to

```bash
Started GoalsApplication in 3.288 seconds (JVM running for 3.713)
```

### Using the API

You can retreive the list of goals for the current user by doing:

```bash
http --user user:password :8080/goals
```

And you can add a goal for a user using a two-step process.

First, retrieve the CSRF token for your current session, like so:

```bash
. ./etc/get-csrf
```{{execute T2}}

And then add a goal:

```bash
echo -n "A new day, a new goal" | http --session=./session.json --user user:password :8080/goal
```{{execute T2}}

Now, if you try `http --user user:password :8080/goals`, you should see you new goal.

### Completing This Step

To complete this step, add a goal of your own!

### What's Next?

While you've added authentication, there's no authorization in this application.
Anyone with credentials can do anything with it.

In the next module, we'll add some basic authorization, which we'll customize in later steps.
