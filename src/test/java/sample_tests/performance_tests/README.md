# Karate + Gatling = Performance Testing

Karate integrates with Gatling to allow you to re-use feature files for performance testing purposes.  In short, you'll define your load model in a Gatling Scala file -- [`GatlingWithKarate.scala`](https://github.com/staffier/Karate-Demo-Project/tree/main/src/test/java/sample_tests/performance_tests/GatlingWithKarate.scala) in this example -- and let Karate take care of building requests and validating the responses coming back (see [`performance-test.feature`](https://github.com/staffier/Karate-Demo-Project/tree/main/src/test/java/sample_tests/performance_tests/performance-test.feature) for details). 

You can invoke the Gatling plugin and run this performance test using by running the following from your command line inside the Karate-Demo-Project parent folder:

```
mvn clean test-compile gatling:test
```

If you have multiple Scala files to your project, but only want to run one of them, you can specify which you wish to run list this:

```
mvn clean test-compile gatling:test -Dgatling.simulationClass=examples.tests.GatlingWithKarate
```

## gatling-akka.conf

If your tests are getting jammed up, you can control your thread pool size using the [`gatling-akka.conf`](https://github.com/staffier/Karate-Demo-Project/tree/main/src/test/java/sample_tests/performance_tests/gatling-akka.conf) file. 

Additional details can be found here: https://github.com/intuit/karate/tree/master/karate-gatling#increasing-thread-pool-size

## gatling.conf

You can define all sorts of additional configurations using the [`gatling.conf`](https://github.com/staffier/Karate-Demo-Project/tree/main/src/test/java/sample_tests/performance_tests/gatling.conf) file. 

Details on these configuration settings can be found here: https://gatling.io/docs/current/general/configuration/

Only a subset of settings were included in this example.  If you're interested in seeing a more comprehensive file in action, this is the place to do so: https://github.com/gatling/gatling/blob/master/gatling-core/src/main/resources/gatling-defaults.conf. 
