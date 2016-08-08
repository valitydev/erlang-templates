#!groovy

def finalHook = {
  runStage('store CT logs') {
    dir('snakeoil') {
      archive '_build/test/logs/'
    }
  }
}

build('erlang-service-template', 'docker-host', finalHook) {
  ws {
    try {
      checkoutRepo()
      loadBuildUtils()

      runStage('get ws path') {
        sh 'echo $PWD  > .ws_path'
        env.WS_PATH = readFile('.ws_path').trim()
      }

      runStage('generate erlang service') {
        docker.withRegistry('https://dr.rbkmoney.com/v2/', 'dockerhub-rbkmoneycibot') {
          docker.image('rbkmoney/build:latest').inside("-e HOME=${env.WS_PATH}") {
            sh 'make gen'
          }
        }
      }

      runStage('archive snakeoil') {
        archive 'snakeoil/'
      }

      // Update service_erlang image
      if (env.BRANCH_NAME == 'master') {
        runStage('build image') {
          sh "make build_image"
        }
        runStage('push image') {
          sh "make push_image"
        }
      }
    } finally {
      runStage('cleanup sub ws') {
        sh 'rm -rf * .* || echo ignore'
      }
    }
  } //close other ws

  runStage('unarchive snakeoil') {
    unarchive mapping: ['snakeoil/': '.']
    sh 'chmod 755 snakeoil/Dockerfile.sh snakeoil/docker-compose.sh'
  }

  dir('snakeoil') {
    runStage('init git repo') {
      sh 'git init'
      sh 'git config user.email "$CHANGE_AUTHOR_EMAIL"'
      sh 'git config user.name "$COMMIT_AUTHOR"'
      sh 'git add README.md'
      sh 'git commit -m "Initial commit"'
    }

    runStage('add git submodule') {
      withGithubCredentials("submodule add -b master git@github.com:rbkmoney/build_utils.git build_utils")
    }

    def pipeDefault
    runStage('load service pipeline') {
      env.JENKINS_LIB = "build_utils/jenkins_lib"
      pipeDefault = load("${env.JENKINS_LIB}/pipeDefault.groovy")
    }

    pipeDefault() {
      def imageTags = "BASE_IMAGE_TAG=latest BUILD_IMAGE_TAG=530114ab63a7ff0379a2220169a0be61d3f7c64c"

      runStage('compile service') {
        sh "make wc_compile ${imageTags}"
      }
      runStage('xref service') {
        sh "make wc_xref ${imageTags}"
      }
      runStage('dialyze service') {
        sh "make wc_dialyze ${imageTags}"
      }

      runStage('test service') {
        sh "make wdeps_test ${imageTags}"
      }
      runStage('lint service') {
        sh "make wc_lint ${imageTags}"
      }
    }
  }
}

