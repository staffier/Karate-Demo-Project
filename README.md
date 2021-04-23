# Karate-Demo-Project

This is a simple demo project designed to help folks learn to use Karate for both client- & server-side testing, as well as load/performance testing.

## jbang

Before you get started, I recommend installing [`jbang`](https://www.jbang.dev).  Once installed, I further recommend you install `karate` as a local command-line application (replace `RELEASE` with the Karate version you're working with, e.g. `1.0.1`):

```
jbang app install --name karate com.intuit.karate:karate-core:RELEASE
```

This will make the command `karate` available in your terminal...meaning you can now do things like this:

```
karate -h
```

...or start a mock server on port 8080 like this:

```
karate -m ~/KarateDemo/src/test/java/examples/tests/server.feature -p 8080
```

## Gatling

For performance testing, you'll need to add the following dependency to your pom:

```xml
<dependency>
    <groupId>com.intuit.karate</groupId>
    <artifactId>karate-gatling</artifactId>
    <version>${karate.version}</version>
    <scope>test</scope>
</dependency>  
```

You will also need the [Gatling Maven Plugin](https://github.com/gatling/gatling-maven-plugin).

The sample below assumes you're using a typical Karate project, where feature files are in `src/test/java`.

```xml
  <plugin>
      <groupId>io.gatling</groupId>
      <artifactId>gatling-maven-plugin</artifactId>
      <version>${gatling.plugin.version}</version>
      <configuration>
          <simulationsFolder>src/test/java</simulationsFolder>
          <includes>
              <include>examples.tests.GatlingWithKarate</include>
          </includes>
      </configuration>
      <executions>
          <execution>
              <phase>test</phase>
              <goals>
                  <goal>test</goal>
              </goals>
          </execution>
      </executions>                
  </plugin>
```

Because the `<execution>` phase is defined, just running `mvn clean test` will work.  But if you prefer not to run Gatling tests as part of the normal Maven "test" lifecycle, you can avoid the `<executions>` section and instead manually invoke the Gatling plugin from the command-line:

```
mvn clean test-compile gatling:test
```

And if you have multiple simulation files in your project, but only want to run one, you can do something like this:

```
mvn clean test-compile gatling:test -Dgatling.simulationClass=examples.tests.GatlingWithKarate
```
