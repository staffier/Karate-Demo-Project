Feature: Some client-side tests to use for performance testing purposes

  Background:
    # Start a server on a free port:
    * def start = () => karate.start('classpath:mock_servers/server.feature').port
    * def port = callonce start

    # Define our base URL and port:
    * url 'http://localhost:' + port

  # Use these next two scenarios to run a Gatling simulation with and without Karate involved

  Scenario: Run a Gatling simulation with Karate
    * karate.exec('mvn test-compile gatling:test -Dgatling.simulationClass=sample_tests.performance_tests.GatlingWithKarate')

  Scenario: Run a Gatling simulation without Karate
    * karate.exec('mvn test-compile gatling:test -Dgatling.simulationClass=sample_tests.performance_tests.GatlingWithoutKarate')

  # Each scenario below is tagged so we can call them with individual load models from our Gatling performance test file

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
    * match response == { "message": "You're trying to reach an invalid link", "timestamp": "#string" }

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
