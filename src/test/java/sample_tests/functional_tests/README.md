# Client-Side Karate

The tests in our [`client.feature`](https://github.com/staffier/Karate-Demo-Project/blob/main/src/test/java/sample_tests/functional_tests/client.feature) file will be executed against a server-side Karate file located in the [`src/test/java/mock_server`](https://github.com/staffier/Karate-Demo-Project/blob/main/src/test/java/mock_server/server.feature) folder.  This server will validate the request method, path, header and payload for incoming requests and respond accordingly:
 - If the method isn't POST, you'll get a 405 - Method Not Allowed error
 - If the path does not match "happy," you'll get a 403 - Forbidden error
 - If the "Auth" header is missing, or its value is not "valid-auth-header," you'll get a 404 - Unauthorized error
 - If the payload does not contain an ID or Username, you'll get a 400 - Bad Request error
