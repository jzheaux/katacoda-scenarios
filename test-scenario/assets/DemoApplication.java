package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		System.setSecurityManager(new ReportableSecurityManager());
		System.out.println("Hello!");
		SpringApplication.run(DemoApplication.class, args);
	}
}
