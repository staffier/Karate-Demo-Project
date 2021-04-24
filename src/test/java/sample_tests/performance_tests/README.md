# Karate + Gatling = Performance Testing

Karate integrates with Gatling to allow you to re-use feature files for performance testing purposes.  In short, you'll define your load model in a Gatling Scala file -- [`GatlingWithKarate.scala`](https://github.com/staffier/Karate-Demo-Project/tree/main/src/test/java/sample_tests/performance_tests/GatlingWithKarate.scala) in this example -- and let Karate take care of building requests and validating the responses coming back (see [`performance-test.feature`](https://github.com/staffier/Karate-Demo-Project/tree/main/src/test/java/sample_tests/performance_tests/performance-test.feature) for details). 

You can invoke the Gatling plugin and run this performance test by running the following from your command line inside the Karate-Demo-Project parent folder:

```
mvn clean test-compile gatling:test
```

If you have multiple Scala files in your project, but only want to run one of them, you can specify which you wish to run list this:

```
mvn clean test-compile gatling:test -Dgatling.simulationClass=examples.tests.GatlingWithKarate
```

## Starting & Stopping a Server

A couple shell scripts are included in this folder to start and stop our [mock server](https://github.com/staffier/Karate-Demo-Project/tree/main/src/test/java/mock_server/server.feature).  The [server starter](https://github.com/staffier/Karate-Demo-Project/tree/main/src/test/java/sample_tests/performance_tests/server-starter.sh) assumes you have [jbang](https://www.jbang.dev/) installed.  And the [server stopper](https://github.com/staffier/Karate-Demo-Project/tree/main/src/test/java/sample_tests/performance_tests/server-stopper.sh) doesn't appear to be working at the moment, although it should: https://github.com/intuit/karate/tree/master/karate-netty#stopping. 

## Gatling Configuration

If your tests are getting jammed up, you can control your thread pool size using the [`gatling-akka.conf`](https://github.com/staffier/Karate-Demo-Project/tree/main/src/test/java/sample_tests/performance_tests/gatling-akka.conf) file. 

Details on this can be found here: https://github.com/intuit/karate/tree/master/karate-gatling#increasing-thread-pool-size. 

You can define all sorts of additional configurations using the [`gatling.conf`](https://github.com/staffier/Karate-Demo-Project/tree/main/src/test/java/sample_tests/performance_tests/gatling.conf) file, as well. 

Details on these configuration settings can be found here: https://gatling.io/docs/current/general/configuration/

Only a subset of settings were included in this example.  If you're interested in seeing a more comprehensive file in action, this is the place to do so: https://github.com/gatling/gatling/blob/master/gatling-core/src/main/resources/gatling-defaults.conf. 
