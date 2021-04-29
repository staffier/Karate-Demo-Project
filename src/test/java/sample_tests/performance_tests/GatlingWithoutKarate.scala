package sample_tests.performance_tests

import io.gatling.core.Predef._
import io.gatling.http.Predef._

import scala.concurrent.duration._
import scala.language.postfixOps

class GatlingWithoutKarate extends Simulation {

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
          jsonPath("$.message").is("You're not authorized to access this link"),
          jsonPath("$.timestamp").ofType[String]
        ).requestTimeout(30 seconds)
    )

  val optionalFields = scenario("Optional Fields")
    .exec(
      http("Optional Fields Request")
        .post("/happy")
        .header("Auth", "valid-auth-header")
        .header("Optional-Header", "this value shouldn't matter")
        .body(StringBody("""{ "id": "888", "username": "HandsomeTony", "optional": { "optionalA": "who cares", "optionalB": "this doesn't matter, either" } }""")).asJson
        .check(
          status.is(200),
          jsonPath("$.message").is("Everything looks good!"),
          jsonPath("$.timestamp").ofType[String]
        ).requestTimeout(30 seconds)
    )

  setUp(
    happyPath.inject(
      rampUsersPerSec(0) to (50) during (10 seconds),
      constantUsersPerSec(50) during (20 seconds)
    ).protocols(httpProtocol),
    sadPath.inject(
      rampUsersPerSec(0) to (25) during (10 seconds),
      constantUsersPerSec(25) during (20 seconds)
    ).protocols(httpProtocol),
    optionalFields.inject(
      rampUsersPerSec(0) to (25) during (10 seconds),
      constantUsersPerSec(25) during (20 seconds)
    ).protocols(httpProtocol)
  )

}
