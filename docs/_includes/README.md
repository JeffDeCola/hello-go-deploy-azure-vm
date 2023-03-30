  _built with
  [concourse](https://github.com/JeffDeCola/hello-go-deploy-azure-vm/blob/master/ci-README.md)_

# OVERVIEW

Every 2 seconds this App will print,

```txt
    INFO[0000] Let's Start this!
    Hello everyone, count is: 1
    Hello everyone, count is: 2
    Hello everyone, count is: 3
    etc...
```

## PREREQUISITES

You will need the following go packages,

```bash
go get -u -v github.com/sirupsen/logrus
go get -u -v github.com/cweill/gotests/...
```

## SOFTWARE STACK

* DEVELOPMENT
  * [go](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/development/languages/go-cheat-sheet)
* OPERATIONS
  * [concourse/fly](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations/continuous-integration-continuous-deployment/concourse-cheat-sheet)
    (optional)
  * [docker](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations/orchestration/builds-deployment-containers/docker-cheat-sheet)
* SERVICES
  * [dockerhub](https://hub.docker.com/)
  * microsoft azure vm

## RUN

To
[run.sh](https://github.com/JeffDeCola/hello-go-deploy-azure-vm/blob/master/hello-go-deploy-azure-vm-code/run.sh),

```bash
cd hello-go-deploy-azure-vm-code
go run main.go
```

To
[create-binary.sh](https://github.com/JeffDeCola/hello-go-deploy-azure-vm/blob/master/hello-go-deploy-azure-vm-code/bin/create-binary.sh),

```bash
cd hello-go-deploy-azure-vm-code/bin
go build -o hello-go ../main.go
./hello-go
```

This binary will not be used during a docker build
since it creates it's own.

## STEP 1 - TEST

To create unit `_test` files,

```bash
cd hello-go-deploy-azure-vm-code
gotests -w -all main.go
```

To run
[unit-tests.sh](https://github.com/JeffDeCola/hello-go-deploy-azure-vm/tree/master/hello-go-deploy-azure-vm-code/test/unit-tests.sh),

```bash
go test -cover ./... | tee test/test_coverage.txt
cat test/test_coverage.txt
```

## STEP 2 - BUILD (DOCKER IMAGE VIA DOCKERFILE)

This docker image is built in two stages.
In **stage 1**, rather than copy a binary into a docker image (because
that can cause issues), the Dockerfile will build the binary in the
docker image.
In **stage 2**, the Dockerfile will copy this binary
and place it into a smaller docker image based
on `alpine`, which is around 13MB.

To
[build.sh](https://github.com/JeffDeCola/hello-go-deploy-azure-vm/blob/master/hello-go-deploy-azure-vm-code/build/build.sh)
with a
[Dockerfile](https://github.com/JeffDeCola/hello-go-deploy-azure-vm/blob/master/hello-go-deploy-azure-vm-code/build/Dockerfile),

```bash
cd hello-go-deploy-azure-vm-code/build
docker build -f Dockerfile -t jeffdecola/hello-go-deploy-azure-vm .
```

You can check and test this docker image,

```bash
docker images jeffdecola/hello-go-deploy-azure-vm
docker run --name hello-go-deploy-azure-vm -dit jeffdecola/hello-go-deploy-azure-vm
docker exec -i -t hello-go-deploy-azure-vm /bin/bash
docker logs hello-go-deploy-azure-vm
docker rm -f hello-go-deploy-azure-vm
```

## STEP 3 - PUSH (TO DOCKERHUB)

You must be logged in to DockerHub,

```bash
docker login
```

To
[push.sh](https://github.com/JeffDeCola/hello-go-deploy-azure-vm/blob/master/hello-go-deploy-azure-vm-code/push/push.sh),

```bash
docker push jeffdecola/hello-go-deploy-azure-vm
```

Check the
[hello-go-deploy-azure-vm docker image](https://hub.docker.com/r/jeffdecola/hello-go-deploy-azure-vm)
at DockerHub.

## STEP 4 - DEPLOY (TO AZURE VM)

_Coming soon._

## CONTINUOUS INTEGRATION & DEPLOYMENT

Refer to
[ci-README.md](https://github.com/JeffDeCola/hello-go-deploy-azure-vm/blob/master/ci-README.md)
on how I automated the above steps using concourse.
