In this first step, you'll start the REST API and the accompanying front-end to get familiar with the environment.

### Preparing the Code

To get the complete experience, run the following script in order to update the code to use the appropriate Katacoda hostnames:

```bash
./etc/rewrite-hosts [[HOST_SUBDOMAIN]] [[KATACODA_HOST]]
```{{execute T1}}

### Starting the REST API

The Spring Boot application is Maven-based, so in the Terminal please start the application with `mvn spring-boot:run`{{execute T1}}.

You should see some output that includes a message similar to

```bash
Starting GoalsApplication on a6130036c349 with PID 8027 (/root/code/target/classes started by root in /root/code)
```

And when the application is ready, you'll see a message similar to

```bash
Started GoalsApplication in 3.288 seconds (JVM running for 3.713)
```

### Starting the Front-end

The front-end is a Browser-based application.
For convenience, it's housed in the same codebase as the REST API for this scenario; however, it could be easily deployed separately, as most Javascript applications are.

To start the front-end, run `mvn spring-boot:run -Dstart-class=io.jzheaux.springsecurity.spa.SpaApplication`{{execute interrupt T2}}.
This will start a front-end application on port 8081.

Once you've started the application, make sure that it's up and running by navigating to https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com/bearer.html

You should be able to login, add, and complete goals.

### What's Next?

We are using HTTP Basic, which isn't ideal since your credentials are stored and managed by the browser.
It's also not great that the credentials are re-verified on every request, lowering performance.

In this scenario, we'll change the authentication mechanism to use the Spring Authorization Server and OAuth 2.0 Bearer Tokens.

