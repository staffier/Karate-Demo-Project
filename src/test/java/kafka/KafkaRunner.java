package kafka;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class KafkaRunner {
    @Test
    void testParallel() {
        Results results =
                Runner.path("classpath:kafka")
                        .tags("~@ignore")
                        .parallel(1);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
