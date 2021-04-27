# Server-Side Karate

Server-side feature files work a bit differently than their client-side cousins.  To begin with, each Scenario is expected to have a JavaScript expression as the content of its description, e.g.: 

  `Scenario: pathMatches('/some/path')`

As requests roll in, each is evaluated against the scenarios defined in the server-side feature file, and a response is provided based on the best match.  The criteria used to determine a match score are: 
1. Path - e.g. `pathMatches('/some/path')`
2. Method - e.g. `methodIs('get')`
3. Query parameters - e.g. `paramExists('someParam')`
4. Headers - e.g. `headerContains('someKey', 'someValue')`

## Starting & Stopping a Server

A Karate server can be started & stopped from the command line (assuming you have a copy of the Karate JAR file to work with) or via the Java API (from a JUnit test, for instance).  But with this project, the karate.start() API is leveraged.  The argument can either be a string, where the path to a server-side feature file is provided in-between quotes, e.g.: 

  `karate.start('classpath:some/path/my-server.feature')`

...or JSON, in instances where you want to specify things like a particular port or enable SSL.  The relevant keys are: 
* `mock` - path to your server-side feature file
* `port` - which defaults to 0 if none is specified
* `ssl` - boolean (true or false, false being the default)
* `cert` - path to a certificate
* `key` - path to your cert key

## Building a Response

Crafting a response for a given Scenario is simple, and typically a matter of defining `responseHeaders`, a `responseStatus`, and a `response` body, e.g.: 

  ```
  Scenario: pathMatches('/some/path') && methodIs('post')
    * def responseStatus = 200
    * def responseHeaders = { 'someKey': 'someValue', 'someOtherKey': 'someOtherValue' }
    * def response = { message: 'Hi!' }
  ```

## Proxy Mode

Karate can also intercept HTTP requests and delegate them to a target server based on criteria specified in a Scenario's expression via the `karate.proceed(url)` function, e.g.: 

  ```
  Scenario: typeContains('xml')
    * karate.proceed('http://some.url.com')
  ```
