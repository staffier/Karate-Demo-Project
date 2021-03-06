package sample_tests;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class TestRunner {
    @Test
    void testParallel() {
        Results results =
                Runner.path("classpath:sample_tests/functional_tests")
                        .tags("~@ignore")
                        .parallel(10);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
