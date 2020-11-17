### Congratulations

Well done!

The REST API now works with a browser.

### What's Next?

There's something not so great about this setup, though. HTTP Basic has a lot of limitations.

First, the credentials are stored in the browser, which makes me nervous.
Second, the credentials need to be re-hashed and verified on every request, which is expensive.
Third, anyone who has the credentials can do anything that user case, which makes me nervous (corollary to the first point).

Now that we've got our authentication, authorization, and browser integrations setup, let's change things to use an authentication mechanism that addresses these points.
