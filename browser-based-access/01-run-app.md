In this first step, you'll start the REST API and the accompanying front-end to get familiar with the environment.

### Preparing the Code

To get the complete experience, run the following script in order to update the code to use the appropriate Katacoda hostnames:

```bash
./etc/rewrite-hosts [[HOST_SUBDOMAIN]] [[KATACODA_HOST]]
```{{execute T1}}

### Starting the REST API

The Spring Boot application is Maven-based, so in the Terminal please start the application with `mvn spring-boot:run`{{execute interrupt T1}}.

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

It doesn't work yet because we haven't met the security requirements to do that securely.

Once you've started the application, make sure that it's up and running by navigating to https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com/basic.html and you should be prompted for credentials.

If you open the JavaScript console, you'll see an error that mentions CORS.

### What's CORS?

Any time one origin (like your front-end) needs to talk to another origin (like your back-end) over AJAX, the back-end needs to specifically agree to the request.

The standard for how to declare that relationship is called Cross-Origin Resource Sharing, or CORS.


### What's Next?

By default, Spring has all resource sharing turned off since that is more secure by default.
We'll turn it on in the next module.
