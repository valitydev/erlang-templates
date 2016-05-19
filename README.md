# Erlang service template [![wercker status](https://app.wercker.com/status/72b3d0cc27f1d63030839dbcb94f1212/s "wercker status")](https://app.wercker.com/project/bykey/72b3d0cc27f1d63030839dbcb94f1212)

Шаблон проекта для быстрого старта написания сервиса на Erlang, в комплекте:

 - rebar.config
 - release
 - wercker config
 - documentation stubs
 - common test stub
 - elvis ruleset

Чтобы опробовать в деле, надо всего лишь:

```bash
$ mkdir -p ~/.config/rebar3/templates
$ cd $_
$ git clone git@github.com:rbkmoney/erlang-service-template.git .
$ cd ~
$ rebar3 new erlang-service name=snakeoil
$ cd snakeoil
...
```

> _Хозяйке на заметку_. Для того, чтобы это всё заработало, необходимы следующие компоненты:
>
>  * GNU Make
>  * [rebar3](http://www.rebar3.org/)
>  * [elvis](https://github.com/inaka/elvis/releases)
>  * [wercker cli](http://devcenter.wercker.com/cli/index.html)

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

В случае необходимости доработки в первую очередь обращайтесь к [официальной документации](http://www.rebar3.org/docs/using-templates).
