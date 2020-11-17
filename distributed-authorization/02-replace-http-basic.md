In this step, you'll configure the REST API to use OAuth 2.0 Bearer tokens to authenticate.
The front-end has already been prepared for you and will also use these tokens.

### Using Bearer Tokens

OAuth 2.0 Bearer Tokens are another authentication mechanism.
A REST API may configure as many ways to authenticate as it likes.
For simplicity, you'll replace the HTTP Basic configuration with the OAuth 2.0 Bearer Token configuration.

In `src/main/java/io/jzheaux/springsecurity/goals/SecurityConfig.java`{{open}}, replace `httpBasic` with `oauth2ResourceServer` like so:

```java
@Bean
SecurityFilterChain filterChain(HttpSecurity http) {
    http
        .cors(Customizer.withDefaults())
        .authorizeRequests((authz) -> authz.anyRequest().authenticated())
        .oauth2ResourceServer((oauth2) -> oauth2
            .jwt(Customizer.withDefaults())
        );

    return http.build();
}
```

Also, you need to tell the REST API where the authorization server is, which you can do in `src/main/resources/application.yml`{{open}}:

```yaml
...

spring
  jpa:
    properties:
      hibernate:
        enable_lazy_load_no_trans: true
  security:
    oauth2:
      resourceserver:
        jwt:
          jwk-set-uri: https://[[HOST_SUBDOMAIN]]-8082-[[KATACODA_HOST]].environments.katacoda.com/oauth2/jwks
```

The property you've just added is the location of the authorization server's public keys, which the REST API will use to verify incoming bearer tokens.

Now restart the REST API by doing `mvn spring-boot:run`{{execute T2}}.
At this point, the REST API will no longer honor Basic credentials, and instead will only honor bearer tokens.

Lastly, since the browser is calling the REST API directly, we need to again think about the CORS handshake.

Currently, the REST API allows the `X-CSRF-TOKEN` and `Content-Type` headers.
However, because bearer tokens is not a browser-managed authentication mechanism, CSRF defense is not necessary.

We can make a few adjustments, then, to the CORS configuration, and make it look like this:

```java
@Bean
WebMvcConfigurer webMvcConfigurer() {
    return new WebMvcConfigurer() {
        @Override
        public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/**")
                    .allowedOrigins("https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com")
                    .allowedMethods("GET", "POST", "PUT")
                    .allowedHeaders("Authorization", "Content-Type")
                    .maxAge(0);
        }
    };
}
```

Notice three of important changes:

* The `X-CSRF-TOKEN` header no longer needs to be allowed nor exposed
* The `Allow-Credentials` flag can be removed
* We need to allow the `Authorization` header

### Testing It Out

The front-end is already prepared, so now navigate to https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com/bearer.html and try things out!

### Run a Test

Each step in the scenario is equipped with a JUnit Test to confirm that everything works.
This first one simply makes sure that Spring Security was set up correctly.

Run it with the Maven command `mvn -Dtest=io.jzheaux.springsecurity.goals.Module4_Tests#task_1 test`{{execute T4}}.

At the end of the test run, you should the message `BUILD SUCCESS`.

### What's Next?

Now, let's change the application to use bearer tokens instead of basic credentials.
