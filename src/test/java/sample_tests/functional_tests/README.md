# Client-Side Karate

The tests in the [`client.feature`](https://github.com/staffier/Karate-Demo-Project/blob/main/src/test/java/sample_tests/functional_tests/client.feature) file will be executed against a server-side Karate file, [`server.feature`](https://github.com/staffier/Karate-Demo-Project/blob/main/src/test/java/mock_server/server.feature), located in the `src/test/java/mock_server` folder.

This server is launched using the `karate.start()` API, and will validate the request method, path, header and payload for incoming requests and respond accordingly:
 - If the method isn't POST, you'll get a 405 - Method Not Allowed error
 - If the path does not match "happy," you'll get a 403 - Forbidden error
 - If the "Auth" header is missing, or its value is not "valid-auth-header," you'll get a 404 - Unauthorized error
 - If the payload does not contain an ID or Username, you'll get a 400 - Bad Request error

The tests in the [`schema-test.feature`](https://github.com/staffier/Karate-Demo-Project/blob/main/src/test/java/sample_tests/functional_tests/schema-test.feature) file will also be executed against a server-side Karate file, [`schema_server.feature`](https://github.com/staffier/Karate-Demo-Project/blob/main/src/test/java/mock_server/schema_server.feature), located in the `src/test/java/mock_server` folder.

This server is also launched using the `karate.start()` API, and will evaluate incoming requests against a schema using a custom JS function, `schemaValidator()`.  If this schema validation check fails, the server will look for a URL parameter named `key`, and if it fails to find that, an error will be returned. 
