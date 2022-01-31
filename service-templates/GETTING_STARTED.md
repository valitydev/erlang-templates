# Getting started with your newly generated project

**IMPORTANT: This file is only meant to be a checklist of things to do after your project is generated. As such, it should not be commited to SVC.**

- [ ] **Using thrift**

    By default this project is already setup to use thrift. Please follow instructions marked by comments beginning with `# @SETUP-THRIFT`  inside the `rebar.config` to setup it correctly.
    
    If, for some reason, your project does not require thrift, please go through the following files and uncomment/delete sections marked by comments beginning with `# @SETUP-THRIFT`.

    - [ ] `.github/workflows/build-image.yml`
    - [ ] `.github/workflows/erlang-checks.yml`
    - [ ] `.env`
    - [ ] `docker-compose.yaml`
    - [ ] `Dockefile`
    - [ ] `Dockefile.dev`

- [ ] **Using swagger-codegen**

    If your project requires the usage of `swagger-codegen`, please go through the following files and uncomment/delete sections marked by comments beginning with `# @SETUP-CODEGEN`.

    - [ ] `.github/workflows/build-image.yml`
    - [ ] `.github/workflows/erlang-checks.yml`
    - [ ] `.env`
    - [ ] `docker-compose.yaml`
    - [ ] `Dockefile`
    - [ ] `Dockefile.dev`

- [ ] **Using docker-compose**

    If your project requires tests to be run inside of docker-compose environment, please go through the following files and uncomment/delete sections marked by comments beginning with `# @SETUP-COMPOSE`.

    - [ ] `.github/workflows/erlang-checks.yml`

    Please also edit the `docker-compose.yaml` file accordingly. Don't forget to change `hostname` and `depends_on` keys of the `testrunner` container as needed.

- [ ] **Documentation**

    Please write a couple of words about what your service does and how it does it in appropriate section of the `README.md`.
