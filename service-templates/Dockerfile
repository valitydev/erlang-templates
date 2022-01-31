ARG OTP_VERSION

# Build the release
FROM docker.io/library/erlang:${OTP_VERSION} AS builder

ARG BUILDARCH

## Install swagger-codegen
## @CODEGEN Uncomment if you need swagger-codegen

# ARG CODEGEN_VERSION
# ARG GENERATOR_VERSION

# RUN apt-get update && \
#     apt-get install -y openjdk-11-jdk ca-certificates-java && \
#     apt-get clean && \
#     update-ca-certificates -f;

# ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
# RUN export JAVA_HOME

# RUN mkdir -p /usr/local/lib/swagger-codegen && \
#     wget "https://repo1.maven.org/maven2/io/swagger/swagger-codegen-cli/${CODEGEN_VERSION}/swagger-codegen-cli-${CODEGEN_VERSION}.jar" -O /usr/local/lib/swagger-codegen/swagger-codegen-cli.jar && \
#     wget "https://github.com/valitydev/swagger-generator-erlang/releases/download/v${GENERATOR_VERSION}/swagger-generator-erlang-v${GENERATOR_VERSION}.jar" -O /usr/local/lib/swagger-codegen/swagger-generator-erlang.jar && \
#     echo "#!/bin/sh" > /usr/local/bin/swagger-codegen && \
#     echo "java -cp /usr/local/lib/swagger-codegen/swagger-generator-erlang.jar:/usr/local/lib/swagger-codegen/swagger-codegen-cli.jar io.swagger.codegen.SwaggerCodegen \$*" >> /usr/local/bin/swagger-codegen && \
#     chmod +x /usr/local/bin/swagger-codegen

# Install thrift compiler
## @THRIFT Delete the following section if your service does not require thrift

ARG THRIFT_VERSION

RUN wget -q -O- "https://github.com/valitydev/thrift/releases/download/${THRIFT_VERSION}/thrift-${THRIFT_VERSION}-linux-${BUILDARCH}.tar.gz" \
    | tar -xvz -C /usr/local/bin/

# Copy sources
RUN mkdir /build
COPY . /build/

# Build the release
WORKDIR /build
RUN rebar3 compile
RUN rebar3 as prod release

# Make a runner image
FROM docker.io/library/erlang:${OTP_VERSION}-slim

ARG SERVICE_NAME

# Set env
ENV CHARSET=UTF-8
ENV LANG=C.UTF-8

# Set runtime
WORKDIR /opt/${SERVICE_NAME}

COPY --from=builder /build/_build/prod/rel/${SERVICE_NAME} /opt/${SERVICE_NAME}

ENTRYPOINT []
CMD /opt/${SERVICE_NAME}/bin/${SERVICE_NAME} foreground

EXPOSE 8022
