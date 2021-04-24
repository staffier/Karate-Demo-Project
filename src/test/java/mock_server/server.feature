@ignore
Feature: A simple server to demo some server-side Karate stuff...

  The @ignore tag up top is to make our runner class (ExamplesTestRunner) ignore this feature file when it tries to
  execute every feature file within the ../tests folder

  This server will validate the request method, path, header and payload for incoming requests and respond accordingly:
   - If the method isn't POST, you'll get a 405 - Method Not Allowed error
   - If the path does not match "happy," you'll get a 403 - Forbidden error
   - If the "Auth" header is missing, or its value is not "valid-auth-header," you'll get a 404 - Unauthorized error
   - If the payload does not contain an ID or Username, you'll get a 400 - Bad Request error

  To launch this server on localhost:8080 from a client-side feature file, you can use the following command:
    * karate.start({ mock: 'classpath:examples/server/server.feature', port: 8080 })

  Background:
    * configure cors = true
    * def abortWithResponse =
      """
        function(responseStatus, response) {
          karate.set('response', response);
          karate.set('responseStatus', responseStatus);
          karate.abort();
        }
      """
    * def timestamp =
      """
        function() {
          var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
          var sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mS'Z'");
          var date = new java.util.Date();
          return sdf.format(date);
        }
      """
    * def response200 = { "message": "Everything looks good!", "timestamp": "#(timestamp())" }
    * def response400_id = { "message": "Your request is invalid", "missing": "id", "timestamp": "#(timestamp())" }
    * def response400_user = { "message": "Your request is invalid", "missing": "username", "timestamp": "#(timestamp())" }
    * def response403 = { "message": "Access denied", "timestamp": "#(timestamp())" }
    * def response404 = { "message": "You're not authorized to access this link", "timestamp": "#(timestamp())" }
    * def response405 = { "message": "Your request method is not allowed", "timestamp": "#(timestamp())" }
    * def responseDelay = 100 + Math.random() * 900

  Scenario: pathMatches('/happy') && methodIs('post')
    * if (!headerContains('Auth', 'valid-auth-header')) abortWithResponse(403, response403);
    * if (!request.id) abortWithResponse(400, response400_id);
    * if (!request.username) abortWithResponse(400, response400_user);
    * abortWithResponse(200, response200);

  Scenario: methodIs('post')
    * abortWithResponse(404, response404);

  Scenario: pathMatches('/happy')
    * abortWithResponse(405, response405);

  # Catch all scenario to reply in case all sorts of stuff went wrong
  Scenario:
    * def responseStatus = 666
    * def responseDelay = 2500
    * def response =
      """
        {
          "success": false,
          "timestamp": "#(timestamp())",
          "errorDetails": [
            {
              "code": 666,
              "message": "I have no idea what you're trying to do!",
              "additionalInfo": "Please check your request method & path...and everything else, while you're at it..."
            }
          ]
        }
      """
