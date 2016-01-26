# Erlang service template

Шаблон проекта для быстрого старта написания сервиса на Erlang, в комплекте:

 - rebar.config
 - release
 - wercker config
 - documentation stubs

Чтобы опробовать в деле, надо всего лишь:

```bash
$ mkdir -p ~/.config/rebar3/templates
$ cd $_
$ git clone git@bitbucket.org:rbk-money/erlang-service-template.git .
$ cd ~
$ rebar3 new erlang-service name=snakeoil
$ cd snakeoil
...
```

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
