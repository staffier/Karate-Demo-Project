@ignore
Feature: All this does is start a mock server on localhost:8080

  The @ignore tag up top is to make our runner class (TestRunner) ignore this feature file when it tries to
  execute every feature file within the ../sample_tests/functional_tests folder

  Scenario:
    * karate.start({ mock: 'classpath:mock_servers/server.feature', port: 8080 })
