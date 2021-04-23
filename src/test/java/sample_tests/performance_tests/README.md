# Karate + Gatling

Karate integrates with Gatling to allow you to re-use feature files for performance testing purposes.  In short, you'll define your load model in a Gatling Scala file (GatlingWithKarate.scala in this example) and let Karate take care of building requests and validating the responses coming back. 

You can invoke the Gatling plugin and run this performance test using by running the following from your command line inside the Karate-Demo-Project parent folder:

```
mvn clean test-compile gatling:test
```

If you have multiple Scala files to your project, but only want to run one of them, you can specify which you wish to run list this:

```
mvn clean test-compile gatling:test -Dgatling.simulationClass=examples.tests.GatlingWithKarate
```
