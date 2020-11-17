In this step, you'll configure your REST API to accept cross-origin requests from the front end.

### Configuring Spring Security

Configuring your REST API for CORS involves two steps.

The first is to configure Spring Security by overriding the default `SecurityFilterChain` provided by Spring Boot.

In ``src/main/java/io/jzheaux/springsecurity/goals/SecurityConfig.java`{{open}}, publish a `SecurityFilterChain` bean with the following settings:

```java
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

import org.springframework.security.config.Customizer;

// ...

@Bean
SecurityFilterChain filterChain(HttpSecurity http) {
    http
        .cors(Customizer.withDefaults())
        .authorizeRequests((authz) -> authz
            .anyRequest().authenticated()
        )
        .httpBasic(Customizer.withDefaults());
    return http.build();
}
```

By default, Spring Boot produces a `SecurityFilterChain` component that does `authorizeRequests` and `httpBasic`.
Because you are replacing that component with your own, you need to specify those along with the `cors` setting.

### Configuring Spring

Next, you'll need to describe the CORS agreement.
For example, you'll say which hosts are allowed, which HTTP headers are allowed, and so on.

You can do this by publishing a `WebMvcConfigurer` `@Bean`.

In `src/main/java/io/jzheaux/springsecurity/goals/SecurityConfig.java`{{open}}, publish a `WebMvcConfigurer` bean with the following settings:

```java
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

// ...

@Bean
WebMvcConfigurer webMvc() {
    return new WebMvcConfigurer() {
        @Override
        public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/**")
                .allowedOrigins("https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com")
                .maxAge(0);
        }
    }
}
```

NOTE: We're using `maxAge` here since the CORS configuration will change over the next few steps, and we don't want the browser to cache the settings.

With the above configuration, AJAX requests are allowed from the front-end's host.

### Test It Out

Go ahead and restart the REST API by running `mvn spring-boot:run`{{execute T1}}.

Then, refresh the page for https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com, again paying attention to the JavaScript console.

Notice now that there's a new error complaining about the lack of a `Allow-Credentials` configuration.

### Adding Allow-Credentials

The reason for that is that with HTTP Basic, the browser manages the credentials, and so we the browser to hand those credentials over for us.

NOTE: Adding `Allow-Credentials` is usually a signal to try something else.
We're adding it right now to demonstrate one of the limitations of HTTP Basic.
In the next scenario, we'll replace this with OAuth, which won't require this same accommodation.

In `src/main/java/io/jzheaux/springsecurity/goals/SecurityConfig.java`{{open}}, update the `WebMvcConfigurer` to allow credentials:

```java
@Bean
WebMvcConfigurer webMvc() {
    return new WebMvcConfigurer() {
        @Override
        public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/**")
                .allowedOrigins("https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com")
                .allowCredentials(true)
                .maxAge(0);
        }
    }
}
```

### Test Again

Go ahead and restart the REST API by running `mvn spring-boot:run`{{execute T1}}.

Then, refresh the page for https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com, again paying attention to the JavaScript console.

Now, notice that you can provide the credentials in an HTTP Basic popup and see the goals.

But, writes aren't working yet...

Read the error message in the JavaScript console and see if you have a guess.

### Run a Test

Each step in the scenario is equipped with a JUnit Test to confirm that everything works.
This first one simply makes sure that Spring Security was set up correctly.

Run it with the Maven command `mvn -Dtest=io.jzheaux.springsecurity.goals.Module3_Tests#task_1 test`{{execute T3}}.

At the end of the test run, you should the message `BUILD SUCCESS`.

### What's Next?

Let's fix this final security issue with browser-based apps.
