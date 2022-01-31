# {{name}}

{{description}}

## Building

To build the project, run the following command:

```bash
$ make compile
```

## Running

To enter the [Erlang shell][1] with the project running, run the following command:

```bash
$ make rebar-shell
```

## Development environment

### Run in a docker container

You can run any of the tasks defined in the Makefile from inside of a docker container (defined in `Dockerfile.dev`) by prefixing the task name with `wc-`.

#### Example

* This command will run the `compile` task in a docker container:
```bash
$ make wc-compile
```

### Run in a docker-compose environment

Similarily, you can run any of the tasks defined in the Makefile from inside of a docker-compose environment (defined in `docker-compose.yaml`) by prefixing the task name with `wdeps-`.

#### Example

* This command will run the `test` task in a docker-compose environment:
```bash
$ make wdeps-test
```

## Documentation

@TODO

[1]: http://erlang.org/doc/man/shell.html