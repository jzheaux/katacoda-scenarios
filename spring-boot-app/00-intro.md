In this scenario, you'll be taking an unsecured REST API and securing it with HTTP Basic.
The existing REST API is a Spring Boot application with several endpoints, but in this scenario, we'll only look at two.

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

### What is a REST API?

A REST API is a backend service that exposes management capabilities over HTTP for one or more resources.
Typically, the API will expose read functionality over `GET`, similar to a getter method.
It will expose create functionality over `POST`, update functionality over `PUT`, and removal functionality over `DELETE`.

The application you'll be working with is a Goal Keeping REST API for managing a user's goals.
For example, there is the `GET /goals` endpoint, which lists all the goals.
There is the `POST /goal` endpoint for adding a goal.
And, there is the `PUT /goal/{id}/complete` for marking a goal completed.

You'll see in a minute how to start the application to check this behavior.

### Goals of This Scenario

This scenario teaches you:

- What basic security measures Spring Security employs by default
- How to connect Spring Security to a username/password database
- How to use your own custom class for representing the user
- How to lookup and use the currently logged-in user in your application

It also covers some basic patterns that are important to secure software design like:

- Secure By Default
- Principle of Least Privilege
- Component-based Configuration
- Dependency Hiding

