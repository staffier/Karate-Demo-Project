// mvn test-compile gatling:test -Dgatling.simulationClass=sample_tests.performance_tests.GatlingWithKarate

package sample_tests.performance_tests

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._

import scala.concurrent.duration.DurationInt
import scala.language.postfixOps

class GatlingWithKarate extends Simulation {

  val protocol = karateProtocol()

  val happyPath = scenario("Happy Path Test")
    .exec(karateFeature("classpath:sample_tests/performance_tests/performance-test.feature@happy-path"))

  val sadPath = scenario("Sad Path Test")
    .exec(karateFeature("classpath:sample_tests/performance_tests/performance-test.feature@not-so-happy-path"))

  val optionalFields = scenario("Optional Fields")
    .exec(karateFeature("classpath:sample_tests/performance_tests/performance-test.feature@optional-fields"))

  setUp(
    happyPath.inject(
      rampUsersPerSec(0) to (7) during (10 seconds),
      constantUsersPerSec(7) during (10 seconds)
    ),
    sadPath.inject(
      rampUsersPerSec(0) to (2) during (10 seconds),
      constantUsersPerSec(2) during (10 seconds)
    ),
    optionalFields.inject(
      rampUsersPerSec(0) to (1) during (10 seconds),
      constantUsersPerSec(1) during (10 seconds)
    )
  ).protocols(protocol)

}
