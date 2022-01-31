# Getting started with your newly generated project

**IMPORTANT: This file is only meant to be a checklist of things to do after your project is generated. As such, it should not be commited to SVC.**

- [ ] **Using thrift**

    By default this project is already setup to use thrift. Please follow instructions marked by comments beginning with `# @SETUP-THRIFT`  inside the `rebar.config` to setup it correctly.
    
    If, for some reason, your project does not require thrift, please go through the following files and uncomment/delete sections marked by comments beginning with `# @SETUP-THRIFT`.

    - [ ] `.github/workflows/erlang-checks.yml`
    - [ ] `.env`
    - [ ] `Dockefile.dev`

- [ ] **Documentation**

    Please write a couple of words about what your project does and how it does it in appropriate section of the `README.md`.
