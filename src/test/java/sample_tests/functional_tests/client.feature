Feature: A few client-side tests to showcase some Karate commands...

  Our mock server is looking for the following in order to provide a 200 - OK response:
  - Method = POST
  - Path = '/happy'
  - Header Auth = "valid-auth-header"
  - Request body contains an "id" and "username"

  Background: Define our base URL and start our mock server (it will shut down automatically upon test completion)
    * url 'http://localhost:8080'
    # Since Background commands are automatically run before each Scenario, we need to call our server starting
    # feature only once, so that we don't get an error when executing Scenario 2 and beyond, telling us our
    # port (8080) is in use.
    * callonce read('start-server.feature')
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true

  Scenario: Test our mock server using a valid request
    # Send a few requests to this location, starting with our happy path:
    * header Auth = "valid-auth-header"
    * path '/happy'
    * request { "id": "12345", "username": "validUser" }
    * method post
    * status 200
    * match header Response-ID == '#uuid'
    * match response == { "message": "Everything looks good!", "timestamp": "#string" }

  Scenario: Test our mock server using an invalid header, path & method
    # Invalid Auth header:
    * header Auth = "not-valid-anymore"
    * path '/happy'
    * request { "id": "777", "username": "anotherValidUser" }
    * method post
    * status 403
    * match header Response-ID == '#uuid'
    * match response == { "message": "Access denied", "timestamp": "#string" }

    # Invalid path:
    * header Auth = "valid-auth-header"
    * path '/sad'
    * request { "id": "321", "username": "yetAnotherValidUser" }
    * method post
    * status 404
    * match header Response-ID == '#uuid'
    * match response == { "message": "You're trying to reach an invalid link", "timestamp": "#string" }

    # Invalid request method:
    * header Auth = "valid-auth-header"
    * path '/happy'
    * method get
    * status 405
    * match header Response-ID == '#uuid'
    * match response == { "message": "Your request method is not allowed", "timestamp": "#string" }

  Scenario: Test our mock server with invalid payloads
    # ID value is empty:
    * header Auth = "valid-auth-header"
    * path '/happy'
    * request { "id": "", "username": "someName" }
    * method post
    * status 400
    * match header Response-ID == '#uuid'
    * match response contains { "message": "Your request is invalid", "missing": "id" }

    # ID key is missing:
    * header Auth = "valid-auth-header"
    * path '/happy'
    * request { "username": "someName" }
    * method post
    * status 400
    * match header Response-ID == '#uuid'
    * match response contains { "message": "Your request is invalid", "missing": "id" }

    # Username value is empty:
    * header Auth = "valid-auth-header"
    * path '/happy'
    * request { "id": "888", "username": "" }
    * method post
    * status 400
    * match header Response-ID == '#uuid'
    * match response contains { "message": "Your request is invalid", "missing": "username" }

    # Username key is missing:
    * header Auth = "valid-auth-header"
    * path '/happy'
    * request { "id": "888" }
    * method post
    * status 400
    * match header Response-ID == '#uuid'
    * match response contains { "message": "Your request is invalid", "missing": "username" }

  Scenario: Test our mock server with optional headers & key/value pairs in the payload
    * header Optional-Header = "this value shouldn't matter"
    * header Auth = "valid-auth-header"
    * path '/happy'
    * request { "id": "888", "username": "HandsomeTony", "optional": { "optionalA": "who cares", "optionalB": "this doesn't matter, either" } }
    * method post
    * status 200
    * match header Response-ID == '#uuid'
    * match response.message == "Everything looks good!"
    * match response contains { "timestamp": "#string" }

  Scenario: Test our mock's catch all scenario
    * header Auth = ""
    * path '/not_happy'
    * request { "message": "____" }
    * method delete
    * status 666
    * match header Response-ID == '#uuid'
    * match response contains { "errorDetails": "#array" }
