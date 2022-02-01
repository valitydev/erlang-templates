# Erlang service template

Шаблон проекта для быстрого старта написания сервиса на Erlang, в комплекте:

 - rebar.config
 - release
 - Jenkinsfile
 - Dockerfile template
 - docker-compose config template
 - documentation stubs
 - common test stub
 - elvis ruleset

Чтобы опробовать в деле, надо всего лишь:

```bash
$ mkdir -p ~/.config/rebar3/templates
$ cd $_
$ git clone https://github.com/valitydev/erlang-templates.git .
$ cd ~
$ rebar3 new erlang-service name=snakeoil
$ cd snakeoil
```

> _Хозяйке на заметку_. Для того, чтобы это всё заработало, необходимы следующие компоненты:
>
>  * GNU Make
>  * [rebar3](http://www.rebar3.org/)
>
> К счастью, теперь все это доступно в dev образе, работать с которым легко и удобно через `make`:
>  * wc-<target> - запустить в dev контейнере
>  * wdeps-<target> - запустить в dev контейнере вместе с необходимыми зависимыми сервисами, используя `docker-compose`.

Чтобы получить описание и поддерживаемые переменные:

```bash
$ rebar3 new help erlang-service
erlang-service:
    custom template (~/.config/rebar3/templates/erlang-service.template)
    Description: Erlang OTP Service
    Variables:
        name="myapp" (Name of the service, an application with this name will also be created)
        description="A service that does something" (Short description of purpose of the service)
        version="1" (Initial version string)
        date="2016-01-26"
        datetime="2016-01-26T14:17:58+00:00"
        author_name="Author Name"
        author_email="a.name@corporate.domain"
        copyright_year="2016"
        apps_dir="apps" (Directory where applications will be created if needed)
```

В случае необходимости доработки в первую очередь обращайтесь к [официальной документации](http://rebar3.org/docs/tutorials/templates/).

## Внесение изменений

Из-за наличия в коде mustache-плейсхолдеров следующего вида ( <file:service-templates/apps/app/test/app_tests_SUITE.erl>):
```erlang
-module({{name}}_tests_SUITE).
```

Форматирование через  `erlfmt` становится нетривиальным.

Для этого в `make format` сделана подмена на в большинстве случаев приемлимый для парсинга код через `find`, `xargs` и `sed` (`{{placeholder}}` -> `___placeholder___`) и должна работать для большинства случаев.
