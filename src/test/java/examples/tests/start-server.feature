@ignore
Feature: All this does is start a mock server on localhost:8080

  The @ignore tag up top is to make our runner class (ExamplesTest) ignore this feature file when it tries to 
  execute every feature file within the ../tests folder

  Scenario:
    * karate.start({ mock: 'server.feature', port: 8080 })
