Feature: A few tests to showcase dynamic request generation & schema validation

  Background:
    # Tap into our DataGenerator (Java faker):
    * def dataGenerator = Java.type('sample_tests.functional_tests.helpers.DataGenerator')

    # Define name components using our new 'dataGenerator' variable:
    * def randomFirstName = dataGenerator.getRandomName()[0]
    * def randomLastName = dataGenerator.getRandomName()[1]

    # Define address components:
    * def randomStreet = dataGenerator.getRandomAddress()[0] + ' ' + dataGenerator.getRandomAddress()[1]
    * def randomCity = dataGenerator.getRandomAddress()[2]
    * def randomState = dataGenerator.getRandomAddress()[3]
    * def randomZip = dataGenerator.getRandomAddress()[4]

    # ...and define a random company name just for kicks:
    * def randomCompany = dataGenerator.getRandomCompany()

    # Pretty print our requests & responses in the logs:
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true

    # Start our server:
    * def start = () => karate.start('classpath:mock_servers/schema_server.feature').port
    * def port = callonce start

    # Define our host/port:
    * url 'http://localhost:' + port

  Scenario: Generate a random request that conforms to our schema
    * request
      """
        {
          "id": "12",
          "name": {
            "firstName": "#(randomFirstName)",
            "lastName": "#(randomLastName)"
          },
          "address": {
            "street": "#(randomStreet)",
            "city": "#(randomCity)",
            "state": "#(randomState)",
            "zip": "#(randomZip)"
          },
          "company": "#(randomCompany)",
          "boolean": true
        }
      """
    * method post

    # Assertions:
    * status 200
    * match response == { "id": "#uuid", "message": "#string" }

    # Use the ID returned in the response above as a URI parameter to make a new request:
    * def id = $.id
    * param key = id
    * method get
    * status 200
    * match response == "This is a response to a request that included a key param..."

  Scenario: Generate a random request that has some optional fields - should still pass our schema check
    * request
      """
        {
          "randomKey": "randomValue",
          "id": "77",
          "name": {
            "firstName": "#(randomFirstName)",
            "middleName": "Mitch",
            "lastName": "#(randomLastName)"
          },
          "address": {
            "street": "#(randomStreet)",
            "city": "#(randomCity)",
            "state": "#(randomState)",
            "zip": "#(randomZip)",
            "country": "United States"
          },
          "company": "#(randomCompany)",
          "boolean": true
        }
      """
    * method post
    * status 200

  Scenario: Generate a random request that is missing a required field (id) - should result in a 400
    * request
      """
        {
          "name": {
            "firstName": "#(randomFirstName)",
            "lastName": "#(randomLastName)"
          },
          "address": {
            "street": "#(randomStreet)",
            "city": "#(randomCity)",
            "state": "#(randomState)",
            "zip": "#(randomZip)",
          },
          "company": "#(randomCompany)",
          "boolean": true
        }
      """
    * method post
    * status 400
