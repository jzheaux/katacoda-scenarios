In this step, you'll finish configuring the application for CSRF defense.

Spring Security turns on CSRF defense by default.
And the front-end has already been configured to read the CSRF token that the REST API creates and to hand it back.

But, there is one more missing piece since we are addressing the REST API directly from the browser, which is more CORS configuration.

### Configuring CORS for the CSRF Header

In `src/main/java/io/jzheaux/springsecurity/goals/SecurityConfig.java`{{open}}, update the `WebMvcConfigurer` again, this time to allow the `X-CSRF-TOKEN` header in both directions:

```java
@Bean
WebMvcConfigurer webMvc() {
    return new WebMvcConfigurer() {
        @Override
        public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/**")
                .allowedOrigins("https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com")
                .allowCredentials(true)
                .allowedHeaders("X-CSRF-TOKEN")
                .exposedHeaders("X-CSRF-TOKEN")
                .maxAge(0);
        }
    }
}
```

### Test Again

Go ahead and restart the REST API by running `mvn spring-boot:run`{{execute interrupt T1}}.

Then, refresh the page for https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com.

Now the app should work correctly again.

### Run a Test

Each step in the scenario is equipped with a JUnit Test to confirm that everything works.
This first one simply makes sure that Spring Security was set up correctly.

Run it with the Maven command `mvn -Dtest=io.jzheaux.springsecurity.goals.Module3_Tests#task_2 test`{{execute T3}}.

At the end of the test run, you should the message `BUILD SUCCESS`.

### What's Next?

Check out the completion page to see where we'll go next with this course to further improve the security of the application.