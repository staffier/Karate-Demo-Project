package sample_tests.performance_tests

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import io.gatling.http.Predef._

import scala.concurrent.duration._
import scala.language.postfixOps

class GatlingWithoutKarate extends Simulation {

  val protocol = karateProtocol()

  val startServer = scenario("Start the server")
    .exec(karateFeature("classpath:sample_tests/functional_tests/start-server.feature"))

  val httpProtocol = http
    .baseUrl("http://localhost:8080")

  val happyPath = scenario("Happy Path Test")
    .exec(
      http("Happy Path Request")
        .post("/happy")
        .header("Auth", "valid-auth-header")
        .body(StringBody("""{ "id": "12345", "username": "validUser" }""")).asJson
        .check(
          status.is(200),
          jsonPath("$.message").is("Everything looks good!"),
          jsonPath("$.timestamp").ofType[String]
        ).requestTimeout(30 seconds)
    )

  val sadPath = scenario("Sad Path Test")
    .exec(
      http("Sad Path Request")
        .post("/not-so-happy")
        .header("Auth", "valid-auth-header")
        .body(StringBody("""{ "id": "321", "username": "yetAnotherValidUser" }""")).asJson
        .check(
          status.is(404),
          jsonPath("$.message").is("You're trying to reach an invalid link"),
          jsonPath("$.timestamp").ofType[String]
        ).requestTimeout(30 seconds)
    )

  val optionalFields = scenario("Optional Fields")
    .exec(
      http("Optional Fields Request")
        .post("/happy")
        .header("Auth", "valid-auth-header")
        .header("Optional-Header", "this value shouldn't matter")
        .body(StringBody(
          """
          |{
          |  "id": "888",
          |  "username": "HandsomeTony",
          |  "optional": {
          |    "optionalA": "who cares",
          |    "optionalB": "this doesn't matter, either"
          |  }
          |}
          """
          .stripMargin)).asJson
        .check(
          status.is(200),
          jsonPath("$.message").is("Everything looks good!"),
          jsonPath("$.timestamp").ofType[String]
        ).requestTimeout(30 seconds)
    )

  setUp(
    startServer.inject(atOnceUsers(1)).protocols(protocol)
      .andThen(
        happyPath.inject(
          rampUsersPerSec(0) to (50) during (20 seconds),
          constantUsersPerSec(50) during (30 seconds)
        ).protocols(httpProtocol),
        sadPath.inject(
          rampUsersPerSec(0) to (50) during (20 seconds),
          constantUsersPerSec(50) during (30 seconds)
        ).protocols(httpProtocol),
        optionalFields.inject(
          rampUsersPerSec(0) to (50) during (20 seconds),
          constantUsersPerSec(50) during (30 seconds)
        ).protocols(httpProtocol)
      )
  )

}
