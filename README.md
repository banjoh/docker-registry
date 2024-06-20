# Local image registry
Simple docker example to run a [registry](https://distribution.github.io/distribution/) as docker containers using various configurations. After running `make run` you should be able to see a number of containers exposing `500X` ports which will be configured with TLS, mTLS, basic-auth etc. The docker compose services will be named to reflect how they are configured e.g `registry-basic-auth-mtls` will run a registry that requires to use basic auth credentials and provide a client cert/key pair to successfully connect.

Certificates and keys will be generated using `make certs` target and will be stored in `certs` directory. Both client and server certs will be present. Docker compose services will mount this directory to load the necessary TLS files.

This is not meant to be used in live systems. You can use it to test a registry running locally for instance.

### Dependencies
- docker
- make
- bash
- openssl

### Usage
- Start the docker containers using the commands below
```sh
make run
```

- Simple test using `curl` to reach the mtls configured registry
```sh
curl https://localhost:5003 --cacert certs/ca.crt --cert certs/client.crt --key certs/client.key -I
HTTP/2 200
cache-control: no-cache
date: Thu, 20 Jun 2024 12:11:01 GMT
...
```

- Push a helm chart using this command
```sh
helm create foo
helm package foo/.
docker login localhost:5001 -u registry -p password
helm push foo-0.1.0.tgz oci://localhost:5001 --ca-file certs/ca.crt --cert-file certs/client.crt --key-file certs/client.key
helm push foo-0.1.0.tgz oci://localhost:5000
```

- Clean up
```sh
make clean
```
