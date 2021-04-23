Feature: Some client-side tests to use for performance testing purposes

  Background:
    * url 'http://localhost:8080'

  # Each scenario is tagged se we can call them with individual load models from our performance test file

  @happy-path
  Scenario: Happy path test
    * header Auth = "valid-auth-header"
    * path '/happy'
    * request { "id": "12345", "username": "validUser" }
    * method post
    * status 200
    * match response == { "message": "Everything looks good!", "timestamp": "#string" }

  @not-so-happy-path
  Scenario: Not-so-happy path test
    * header Auth = "valid-auth-header"
    * path '/not-so-happy'
    * request { "id": "321", "username": "yetAnotherValidUser" }
    * method post
    * status 404
    * match response == { "message": "You're not authorized to access this link", "timestamp": "#string" }

  @optional-fields
  Scenario: Test involving optional key/value pairs in the payload
    * header Optional-Header = "this value shouldn't matter"
    * header Auth = "valid-auth-header"
    * path '/happy'
    * request { "id": "888", "username": "HandsomeTony", "optional": { "optionalA": "who cares", "optionalB": "this doesn't matter, either" } }
    * method post
    * status 200
    * match response.message == "Everything looks good!"
    * match response contains { "timestamp": "#string" }
