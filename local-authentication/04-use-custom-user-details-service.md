In this step, you'll change the JDBC-based `UserDetailsService` for a custom one that queries a Spring Data repository.

Oftentimes, its more flexible to query Spring Data than it is to use Spring Security's stock `UserDetailsService` instances.

You'll do this in two steps.

First, `src/main/java/io/jzheaux/springsecurity/goals/UserRepositoryUserDetailsService.java`{{open}} has already been started for you.
Also, the necessary Spring Data files have already been created; the important one for this exercise is `src/main/java/io/jzheaux/springsecurity/goals/UserRepository.java`{{open}}.

In `UserRepositoryUserDetailsService`, make the following changes:

1. Change it to implement `UserDetailsService`
2. Add a `private final` member variable `UserRepository` and constructor
3. Have the `loadUserByUsername` method query `UserRepository#findByUsername` method. Since it returns `Optional`, add an `orElseThrow` that throws a `UsernameNotFoundException`

Your class should look something like this, though note that it's not quite ready yet:

```java
public class UserRepositoryUserDetailsService implements UserDetailsService {
    private final UserRepository users;

    public UserRepositoryUserDetailsService(UserRepository users) {
        this.users = users;
    }

    @Override
    public UserDetails loadUserByUsername(String username) 
            throws UsernameNotFoundException {
        User user = this.users.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("user not found"));
        return null;
    }
}
```

At this point, we're faced with a problem.
Your custom `User` class doesn't extend Spring Security's `UserDetails`.

One way to solve this problem is to change `User` to extend `UserDetails`, implementing the Spring Security-specific methods necessary.

**BUT** that means your domain object is now tied to Spring Security, which isn't so great.

Also, more subtlely, it's tied to the Spring Security authentication mechanism.
Since not all mechanisms use `UserDetails`, if you change mechanisms, you'll have to change your domain object again.

Instead, do the following inside `UserRepositoryUserDetailsService`:

1. Create a private inner class that extends `User` and implements `UserDetails`
2. Add a constructor that takes a `User`
3. Change the boolean methods to return `true` since we aren't using them for now
4. Leave `getAuthorities` empty for the moment

At this point, your class should look something like this:

```java
public class UserRepositoryUserDetailsService implements UserDetailsService {
    private final UserRepository users;

    public UserRepositoryUserDetailsService(UserRepository users) {
        this.users = users;
    }

    @Override
    public UserDetails loadUserByUsername(String username) 
            throws UsernameNotFoundException {
        User user = this.users.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("user not found"));
        return null;
    }

    private static class UserAdapter extends User implements UserDetails {
        UserAdapter(User user) {
            super(user);
        }

        public Collection<? extends GrantedAuthority> getAuthorities() {
            return null;
        }

		@Override
		public boolean isAccountNonExpired() {
			return true;
		}

		@Override
		public boolean isAccountNonLocked() {
			return true;
		}

		@Override
		public boolean isCredentialsNonExpired() {
			return true;
		}
    }
}
```

What should we do about `getAuthorities`?

`GrantedAuthority` is an interface in Spring Security that indicates a role or permission that a user has.
Your custom `User` class is equipped with a `getUserAuthorities` method that pulls authorities from a foreign key relationship in the database.
You can adapt the `UserAuthority` to a `GrantedAuthority` if you want, but that's less common since authorities are usually much simpler than users themselevs.

So, now for the final touches:

1. In the `UserAdapter` constructor, loop through `user.getUserAuthorities`.
2. Map each `UserAuthority#authority` to a `SimpleGrantedAuthority`
3. Store that `Collection` in `UserAdapter`, returning it in `getAuthorities`
4. In `loadUserByUsername`, return `new UserAdapter(user)`.

Your class should now look something like the following:

```java
public class UserRepositoryUserDetailsService implements UserDetailsService {
    private final UserRepository users;

    public UserRepositoryUserDetailsService(UserRepository users) {
        this.users = users;
    }

    @Override
    public UserDetails loadUserByUsername(String username) 
            throws UsernameNotFoundException {
        User user = this.users.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("user not found"));
        return new UserAdapter(user);
    }

    private static class UserAdapter extends User implements UserDetails {
        private final Collection<GrantedAuthority> authorities;

        UserAdapter(User user) {
            super(user);
            this.authorities = user.getUserAuthorities().stream()
                    .map(UserAuthority::getAuthority)
                    .map(SimpleGrantedAuthority::new)
                    .collect(Collectors.toList());
        }

        public Collection<? extends GrantedAuthority> getAuthorities() {
            return this.authorities;
        }

		@Override
		public boolean isAccountNonExpired() {
			return true;
		}

		@Override
		public boolean isAccountNonLocked() {
			return true;
		}

		@Override
		public boolean isCredentialsNonExpired() {
			return true;
		}
    }
}
```

Phew! That extra work now will pay dividends later on.

Now, change your `UserDetailsService` `@Bean` declaration to use `UserRepositoryUserDetailsService` instead:

```java
@Bean
UserDetailsService userDetailsService(UserRepository users) {
    return new UserRepositoryUserDetailsService(users);
}
```

Having done this, restart the application with `mvn spring-boot:run`{{execute T1}}.

### What Difference Did That Make?

While definitely more coding than the previous two examples, you achieved two very important goals:

1. You used Spring Data instead of Spring Security for querying the database
2. You hid the Spring Security specifics inside of the `UserDetailsService`.

Because we did it this way, we'll shortly start seeing benefits that we now get for free.

To make sure it all works, try this out by going into Terminal 2 and running the goals command `http -a hasread:password :8080/goals`{{execute T2}}.
You should see the list of goals, the same as before.

### Run a Test

Now check your work with Maven: `mvn -Dtest=io.jzheaux.springsecurity.goals.Module1_Tests#task_4 test`{{execute T2}}.

At the end of the test run, you should the message `BUILD SUCCESS`.

### What's Next?

You've learned both beginner and advanced ways to customize the user store.

Now, let's use that user in our application.