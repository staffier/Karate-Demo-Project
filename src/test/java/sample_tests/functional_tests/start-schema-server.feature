@ignore
Feature: All this does is start a mock server on localhost:8080

  Scenario:
    * karate.start({ mock: 'classpath:mock_servers/schema_server.feature', port: 8080 })
