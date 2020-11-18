In this scenario, you'll be taking a secure REST API and exposing it to browser requests using OAuth 2.0 bearer tokens.
The front-end is already built for you, but the scenario will highlight the important pieces so it's clear how to alter the REST API.

This scenario builds off of the [Browsers with Spring Security scenario](https://katacode.com/jzheaux/scenarios/browser-based-access).

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
In the previous scenario, you negotiated this with HTTP Basic, but it has some drawbacks:

* The user's password is storaged and managed in the browser, lowering security
* The browser can hand up those credentials via third-parties, lowering security, and
* The password has to be re-hashed on each request, lowering performance

By the end of this scenario, you'll have addressed these, though they will be replaced with a more minor concern.
In a future scenario, you'll learn about an alternative setup that's recommended by the Browsed-Based Apps Best Practices RFC.

### Goals of This Scenario

This scenario teaches you:

- How to configure a Spring REST API to accept bearer tokens
- How to configure a Spring REST API for CORS when using bearer tokens
- How to map an existing backend user to claims in a bearer token

It also covers some basic patterns that are important to secure software design like:

- Secure By Default
- Principle of Least Privilege
- Component-based Configuration