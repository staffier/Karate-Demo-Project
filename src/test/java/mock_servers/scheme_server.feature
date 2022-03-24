Feature: Validate incoming requests conform to a particular schema

  Background:
    # Tap into our DataGenerator (Java faker):
    * def dataGenerator = Java.type('sample_tests.functional_tests.helpers.DataGenerator')

    # Produce a random quote using our Java faker variable:
    * def randomQuote = dataGenerator.getRandomQuote()

    # Define a schema we want to use to validate incoming requests against:
    * def schema =
      """
        {
          "id": "#string? _.length == 2",
          "name": {
            "firstName": "#string",
            "lastName": "#string"
          },
          "address": {
            "street": "#string",
            "city": "#string",
            "state": "#string",
            "zip": "#string"
          },
          "company": "#string",
          "boolean": #boolean
        }
      """
    * def schemaValidator = function() { return karate.match("request contains deep schema").pass }

    # Add a random delay (200 - 600ms) to each response:
    * def responseDelay = 200 + Math.random() * 400

  Scenario: schemaValidator()
    * def responseStatus = 200
    * def uuid = function() { return java.util.UUID.randomUUID() + '' }
    * def response =
      """
      {
        "id": "#(uuid())",
        "message": "#(randomQuote)"
      }
      """

  Scenario: paramExists('key')
    * def responseStatus = 200
    * def response = "This is a response to a request that included a key param..."

  Scenario:
    * def responseStatus = 400
    * def response = { "message": "Your request does not look good" }
    * def actualVsExpected = karate.match(request, schema).message
    * print actualVsExpected
