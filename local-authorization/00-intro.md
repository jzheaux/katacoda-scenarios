In this scenario, you'll take a REST API secured with HTTP Basic and add authorizatino rules.

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

### Authentication vs Authorization

Authentication is knowing who is making the request.
Authorization is knowing whether or not to grant the request.

Just because you know who is requesting doesn't mean that you should grant any request of theirs.

### Goals of This Scenario

This scenario teaches you:

- What basic authorization measures Spring Security employs by default
- How to use method-based security
- How to use your own custom class for evaluating authorization rules

It also covers some basic patterns that are important to secure software design like:

- Secure By Default
- Principle of Least Privilege
- Component-based Configuration

