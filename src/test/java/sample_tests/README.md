# Using a Test Runner

A [runner class]() is included here, allowing you to execute multiple Karate tests in parallel. 

  ```
  @Test
  void testParallel() {
      Results results =
              Runner.path("classpath:sample_tests/functional_tests")
                      .tags("~@ignore")
                      .parallel(10);
      assertEquals(0, results.getFailCount(), results.getErrorMessages());
  }
  ```
