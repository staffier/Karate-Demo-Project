# Server-Side Karate

Server-side feature files work a bit differently than their client-side cousins.  To begin with, each Scenario is expected to have a JavaScript expression as the content of its description, e.g.: 

`Scenario: pathMatches('/some/path')`

As requests roll in, each is evaluated against the scenarios defined in the server-side feature file, and a response is provided based on the best match.  The criteria used to determine a match score are: 
1. Path
2. Method
3. Query parameters
4. Headers

## Starting & Stopping a Server

A Karate server can be started & stopped from the command line (assuming you have a copy of the Karate JAR file to work with) or via the Java API (from a JUnit test, for instance).  But with this project, the karate.start() API is leveraged.  The argument can either be a string, where the path to a server-side feature file is provided in-between quotes, e.g.: 

`karate.start('classpath:some/path/my-server.feature')`

...or JSON, in instances where you want to specify things like a particular port or enable SSL.  The relevant keys are: 
* mock - path to your server-side feature file
* port - which defaults to 0 if none is specified
* ssl - boolean (true or false, false being the default)
* cert - path to a certificate
* key - path to your cert key

## Proxy Mode

Karate can also intercept HTTP requests and delegate them to a target server based on specified criteria via the karate.proceed() API. 
