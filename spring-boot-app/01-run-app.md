In this first step, you'll start the application and get familiar with the environment.

### Starting the Application

The Spring Boot application is Maven-based, so in the Terminal please start the application with `mvn spring-boot:run`{{copy execute}}.

You should see some output that includes a message similar to

```bash
Starting GoalsApplication on a6130036c349 with PID 8027 (/root/code/target/classes started by root in /root/code)
```

And when the application is ready, you'll see a message similar to

```bash
Started GoalsApplication in 3.288 seconds (JVM running for 3.713)
```

### Testing the Application with HTTPie

In this module, we'll be using [HTTPie](https://httpie.org) to interface with the API.
HTTPie is similar to cURL, though with a much nicer UI.

Open a New Terminal and type `http :8080/goals`{{copy execute "T2"}}

You should see a response similar to:

```bash
[
  {
    "id": "d367a583-6b93-4320-a564-67a863ea08c4",
    "text": "Read War and Peace, by User Userson",
    "owner": "user",
    "completed": false
  },
  {
    "id": "c7abcb4a-006c-47c9-8aa6-0bb096173c47",
    "text": "Free Solo the Eiffel Tower, by User Userson",
    "owner": "user",
    "completed": false
  },
  {
    "id": "61f71108-025e-48c7-ada6-d072ee601ddb",
    "text": "Hang Christmas Lights, by User Userson",
    "owner": "user",
    "completed": false
  }
]
```

Now try adding a goal using the `POST /goal` endpoint, like so:

```bash
echo -n "Complete this Scenario" | http :8080/goal
```{{copy execute "T2"}}

And you should see some output showing that your goal was created, like the following:

```bash
{
  "id": "fe0e5a51-046d-4406-bc67-5a6c0eee452f",
  "text": "Complete this scenario",
  "owner": "user",
  "completed": false
}
```

### Completing This Step

To complete this step, add a goal of your own!

### What's Next?

There's no security in this application.
Anyone with access can do anything with it.

In the next module, we'll add some baseline security, which we'll customize in later steps.
