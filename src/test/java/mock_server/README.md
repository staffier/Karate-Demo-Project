# Server-Side Karate

Server-side feature files work a bit differently than their client-side cousins.  To begin with, each Scenario is expected to have a JavaScript expression as the content of its description, e.g.: 

  `Scenario: pathMatches('/some/path')`

On each incoming HTTP request, the Scenario expressions are evaluated in order, starting from the first one within the Feature. If the expression evaluates to `true`, the body of the Scenario is evaluated and the HTTP response is returned.

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

  ```feature
  Scenario: pathMatches('/some/path') && methodIs('post')
    * def responseStatus = 200
    * def responseHeaders = { 'someKey': 'someValue', 'someOtherKey': 'someOtherValue' }
    * def response = { message: 'Hi!' }
  ```

## Proxy Mode

Karate can also intercept HTTP requests and delegate them to a target server based on criteria specified in a Scenario's expression via the `karate.proceed(url)` function, e.g.: 

  ```feature
  Scenario: typeContains('xml')
    * karate.proceed('http://some.url.com')
  ```
