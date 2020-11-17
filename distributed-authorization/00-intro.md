In this scenario, you'll be taking a secure REST API and exposing it to browser requests.
The front-end is already built for you, but the scenario will highlight the important pieces so it's clear how to alter the REST API.

This scenario builds off of the [Local Authorization with Spring Security scenario](https://katacode.com/jzheaux/local-authorization).

### Pre-requisites

This scenario assumes that you are familiar with Spring Boot and the Spring Framework.
Before beginning, you should already be able to answer questions like the following:
 - What is dependency injection?
 - What is Spring Boot Auto-configuration?
 - What is the difference between `@Bean`, `@Component`, and `@Autowired`?

The scenario also uses Spring Data. 
While familiarity will be helpful, you won't be working with any of the Spring Data configuration.

Throughout the scenario, you'll be introduced to Spring Security concepts and APIs.
It may then also help to read [The Big Picture section of the Spring Security Reference](https://docs.spring.io/spring-security/site/docs/current/reference/html5/#servlet-architecture) in preparation.

### How Do Browsers Interact with REST APIs?

The most common is for a front-end to talk to REST APIs over AJAX.
This presents some important security considerations that you'll need to consider when building front-ends.

In a future scenario, you'll learn about an alternative setup that's recommended by the Browsed-Based Apps Best Practices RFC.

### Goals of This Scenario

This scenario teaches you:

- How to configure a Spring REST API for CORS
- How to configure a Spring REST API for CSRF

It also covers some basic patterns that are important to secure software design like:

- Secure By Default
- Principle of Least Privilege
- Component-based Configuration

