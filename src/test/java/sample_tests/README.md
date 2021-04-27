# Using a Test Runner

A [runner class](https://github.com/staffier/Karate-Demo-Project/blob/main/src/test/java/sample_tests/TestRunner.java) is included here, allowing you to execute multiple Karate tests in parallel. It's currently configured to execute scenarios -- in parallel, using 10 threads -- across all feature files housed in the `../sample_tests/functional_tests` folder, save for any tagged with `@ignore`: 

  ```java
  @Test
  void testParallel() {
      Results results =
              Runner.path("classpath:sample_tests/functional_tests")
                    .tags("~@ignore")
                    .parallel(10);
      assertEquals(0, results.getFailCount(), results.getErrorMessages());
  }
  ```
