package sample_tests.functional_tests

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._

import scala.concurrent.duration._
import scala.language.postfixOps

class GatlingWithKarate extends Simulation {

  val protocol = karateProtocol()

  val happyPath = scenario("Happy Path Test")
    .exec(karateFeature("classpath:sample_tests/performance_tests/performance-test.feature@happy-path"))

  val sadPath = scenario("Sad Path Test")
    .exec(karateFeature("classpath:sample_tests/performance_tests/performance-test.feature@not-so-happy-path"))

  val optionalFields = scenario("Optional Fields")
    .exec(karateFeature("classpath:sample_tests/performance_tests/performance-test.feature@optional-fields"))

  val allScenarios = scenario("All Scenarios")
    .exec(karateFeature("classpath:sample_tests/performance_tests/performance-test.feature"))

  setUp(
    happyPath.inject(
      rampUsersPerSec(0) to (50) during (10 seconds),
      constantUsersPerSec(50) during (20 seconds)
    ).protocols(protocol),
    sadPath.inject(
      rampUsersPerSec(0) to (25) during (10 seconds),
      constantUsersPerSec(25) during (20 seconds)
    ).protocols(protocol),
    optionalFields.inject(
      rampUsersPerSec(0) to (25) during (10 seconds),
      constantUsersPerSec(25) during (20 seconds)
    ).protocols(protocol)
  )

//  setUp(
//    allScenarios.inject(
//      rampUsersPerSec(0) to (33) during (10 seconds),
//      incrementUsersPerSec(11)
//        .times(5)
//        .eachLevelLasting(10 seconds)
//        .separatedByRampsLasting(5 seconds)
//        .startingFrom(33)
//    )
//  )

}