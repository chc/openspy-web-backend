# Openspy Web Backend

This is a .NET Core 3.1 project to perform various functions needed by the openspy core, or things which integrate with openspy.

This project should be rearchitected at some point as its roles and responsibilities are wide reaching.

A [docker-compose](/docker-compose.yaml) script and [Dockerfile](/Dockerfile) have been provided for reference on how to run it.

```sh
git clone https://github.com/chc/openspy-web-backend.git
cd openspy-web-backend
docker build -t os-core-web .
docker-compose up
```

## Plain text passwords
Due to some unfortunate choices by GameSpy, a "client challenge" is used in combination with a server challenge in the GP protocol. The server responds with an expected result, which is calculated using the md5 hash of the plaintext password. At best an unsalted MD5 hash can be used, however at this point in time it is kept plain text due to this reason, and to avoid potential issues with future services which are integrated. A solution being considered is to instead assign the user a password, however its unclear how to get this information to the user, as most games do not expect anything like email verification before being able to use their account. Another idea is "per game" passwords, but in the end they would be plain text (or unsalted MD5) anyways.

## Generating an API Key

### HTTP Auth Private Key
This key can be of any length

`sh
openssl genrsa -out http_auth_key.pem 2048
`

Take the base64 string, and make it into 1 line. That string is value to set APIKeyPrivateKey to.

### Generating an HTTP Auth Key for requests

This next part needs improvement, but basically comment out the Authorize attribute in the APIKeyController, and make a request to GenerateKey to make an admin key. This is for your first key, any key made after will not require this, so its easier to just do it locally.

`sh
curl -X POST "http://localhost:5000/api/APIKey/GenerateKey" -H  "accept: text/plain" -H  "Content-Type: application/json-patch+json" -d "{  \"name\": \"dev test key\",  \"roles\": [    \"Admin\"  ]}"
`

### Presence Preauth Key

This key should be 512 bits, otherwise some games may not work properly, due to exceeding the maximum size for auth tokens. Most games can handle longer, but some such as Battlefield 2142 cannot.

`sh
openssl genrsa -out preauth_key.pem 512
`

