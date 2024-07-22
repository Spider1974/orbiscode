# qu-seed (Quarkus seed)

[![Quality Gate Status](https://sonarqube.orbis.dedalus.com/vie-prod/api/project_badges/measure?project=orbis.u.qu-seed%3Aqu-seed&metric=alert_status)](https://sonarqube.orbis.dedalus.com/vie-prod/dashboard?id=orbis.u.qu-seed%3Aqu-seed)
[![Reliability Rating](https://sonarqube.orbis.dedalus.com/vie-prod/api/project_badges/measure?project=orbis.u.qu-seed%3Aqu-seed&metric=reliability_rating)](https://sonarqube.orbis.dedalus.com/vie-prod/dashboard?id=orbis.u.qu-seed%3Aqu-seed)
[![Security Rating](https://sonarqube.orbis.dedalus.com/vie-prod/api/project_badges/measure?project=orbis.u.qu-seed%3Aqu-seed&metric=security_rating)](https://sonarqube.orbis.dedalus.com/vie-prod/dashboard?id=orbis.u.qu-seed%3Aqu-seed)
[![Maintainability Rating](https://sonarqube.orbis.dedalus.com/vie-prod/api/project_badges/measure?project=orbis.u.qu-seed%3Aqu-seed&metric=sqale_rating)](https://sonarqube.orbis.dedalus.com/vie-prod/dashboard?id=orbis.u.qu-seed%3Aqu-seed)
[![Technical Debt](https://sonarqube.orbis.dedalus.com/vie-prod/api/project_badges/measure?project=orbis.u.qu-seed%3Aqu-seed&metric=sqale_index)](https://sonarqube.orbis.dedalus.com/vie-prod/dashboard?id=orbis.u.qu-seed%3Aqu-seed)
[![Vulnerabilities](https://sonarqube.orbis.dedalus.com/vie-prod/api/project_badges/measure?project=orbis.u.qu-seed%3Aqu-seed&metric=vulnerabilities)](https://sonarqube.orbis.dedalus.com/vie-prod/dashboard?id=orbis.u.qu-seed%3Aqu-seed)

## prerequisites

Read the [wiki article](https://wikihealthcare.agfa.net/x/JxHKEQ) about how to
start developing an ORBIS U application and verify if all required tools are
installed to build the project.

## build the application

The application can be build locally or inside a container. If you build the
application locally all requirements must be fulfilled. For example JDK 11.

Alternatively you can build the application inside a container. Then is a
container runtime required. For example `docker` or `podman`.

With the following commands can be build the application.

```bash
mvn clean install                   # locally
./scripts/docker/build-in-docker.sh # via container (if build-tools are not available)
```

## starting and stopping container images

**Since updating application-frame to >= 84.4001.14 the u-security is activated per default in the application-frame**

* blog-post: [https://confluence.dedalus.com/x/mYr7C](https://confluence.dedalus.com/x/mYr7C)
* disable u-security by setting the environment
  variable: [u_security_opt_out](https://trrsuv040.agfahealthcare.com/orbis-u/i-host-u/-/blob/master/documentation/user/environment-variables.md#u_security_opt_out)

The container environment is managed via multiple single shell scripts. Each
shell script requires at least two arguments. First the environment against
which the command is to be executed and last the addressed containers.

For example to start or stop the `oracle`, `application-frame` and `u-security`
container inside the `dev` environment use the following command.

```bash
./startup.sh dev oracle application-frame u-security   # starting
./shutdown.sh dev oracle application-frame u-security  # stopping
```

Analogously, the following pattern can be taken from it.

```bash
./startup.sh <environment> <container1> <container2> ... <containerN>
./shutdown.sh <environment> <container1> <container2> ... <containerN>
```

As soon all containers are healthy you should be able to access at least the following urls (maybe you have to adjust the hostname to your needs):
* [https://host.docker.internal/u/qu-seed/#/pizza-orders-overview](https://host.docker.internal/u/qu-seed/#/pizza-orders-overview)
* [https://host.docker.internal/u/qu-seed/#/configurations](https://host.docker.internal/u/qu-seed/#/configurations)

## run it in your local machine

Open a git bash and navigate to the project directory -> frontend -> ui and
execute:

`yarn start`

This will use `ng serve` with the right tooling to live-code your frontend. The
Angular/Webpack dev-server will listen on localhost:4200.

By setting the environment variable UPSTREAM_URL you can define from which
backend the DEV-Sever calls the REST resources.

To run the frontend-dev-server you can as well just execute the following
shell-script at the root folder of the project.

`./dev-frontent.sh`

The live-code the backend execute:

`./dev-backend.sh`

To run the frontend-dev-server to use the backend-dev-server run:

`./dev-frontend-to-dev-backend.sh`

To rebuild and restart the already running backend, run:

`./buildAndDeploy.sh <environmentName> [<extension 1>, ..., <extension N>]`

where `<extension 1> - <extension N>` are names of environment configs in
`environments`. Each next passed config extends or overwrites previously defined

## u-security

The app is using the [u-security lib](https://trrsuv040.agfahealthcare.com/orbis-u/u-security/-/blob/master/README.md).

Within the app setup a 'pizza-admin' profile is defined, which is used to
secure the frontend as well as the related backend services. Means the buttons
in the app to open the configuration and to delete all pizza orders are only
available, if the logged in user has a role assigned where the 'pizza-admin'
profile is set.
The same applies to the related backend services which are used to delete all
pizza orders and to change the configuration.

### assign 'pizza-admin' profile to role in u-security app

Important: It is recommended to log in to the pizza app or the application
frame with the user 'SCHULUNG/schulung'.

Steps:

1. Open the role search via the u-security app directly
   `https://[HOST]/u/security/#` or via the application-frame
   'Administration' > 'Security'
2. Open the role 'ADMIN' (should be assigned to user 'SCHULUNG',
   see tab 'Users')
3. Open tab 'Permissions'
4. Assign 'Administer pizza app' profile of 'QU Seed' app to role
5. Save changes

Afterward the changes will be synced with the pizza app. This means it will
take some seconds until the changes will have an effect on pizza app side.
If everything went well the buttons mentioned above should be available after
a reload of the app in the browser.

## timestamps

JSON-B (json binding) and JPA are able to map all time and date data types of
the 'java.time' package out of the box. There is no mapper needed anymore
Further information about timestamps in orbisu can be find
[here](http://wikihealthcare.agfa.net/x/3gpuFQ).

## OpenAPI

the OpenAPI (known as Swagger) of the project is configured in the
quarkus [application.properties](./backend/src/main/resources/application.properties)
and can be downloaded via https://localhost/u/qu-seed/openapi
or found in the build target directory `./backend/target/openapi/openapi.[json|.yaml]`

## Sonar

for static code analysis SonarQube is configured in the main [pom.xml](./pom.xml).
This projects is hosted here https://sonarqube.orbis.dedalus.com/vie-prod/dashboard?id=orbis.u.qu-seed%3Aqu-seed

See also here https://confluence.dedalus.com/display/ITSUPPORT/Sonar

## Metrics

As metrics are not accessible via proxy they are only available via
dev-mode: \
`http://localhost:8080/metrics`

## FAQ

### UnsupportedOperationException

When running `mvn clean quarkus:dev` and you get the following error

```txt
UnsupportedOperationException: Value found for #getJtaDataSource : not
supported yet
```

than run `./dev-backend.sh` to start the Quarkus backend or run `mvn quarkus:dev
-DSKIP_PARSE_PERSISTENCE_XML=true`.

### skipFrontendBuild maven profile

builds the application (backend and docker image) without invoking frontend
build usage:

`./mvn [clean] install -P skipFrontendBuild`

## Kafka support

See the [Kafka README](doc/KAFKA.md)
