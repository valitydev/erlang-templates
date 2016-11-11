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

      runStage('generate erlang service: snakeoil') {
        sh 'make wc_gen'
      }

      runStage('archive snakeoil') {
        archive 'snakeoil/'
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
      withGithubSshCredentials {
        sh "git submodule add -b master git@github.com:rbkmoney/build_utils.git build_utils"
      }
    }

    def pipeDefault
    def withWsCache
    runStage('load service pipeline') {
      env.JENKINS_LIB = "build_utils/jenkins_lib"
      pipeDefault = load("${env.JENKINS_LIB}/pipeDefault.groovy")
      withWsCache = load("${env.JENKINS_LIB}/withWsCache.groovy")
    }

    pipeDefault() {
      def imageTags = "BASE_IMAGE_TAG=4000337c0ca19978467f62ca6505a03c2569de40 BUILD_IMAGE_TAG=80c38dc638c0879687f6661f4e16e8de9fc0d2c6"

      runStage('compile service') {
        withGithubPrivkey {
          sh "make wc_compile ${imageTags}"
        }
      }
      runStage('lint service') {
        sh "make wc_lint ${imageTags}"
      }
      runStage('xref service') {
        sh "make wc_xref ${imageTags}"
      }
      runStage('dialyze service') {
        withWsCache("_build/default/rebar3_18.3_plt") {
          sh "make wc_dialyze ${imageTags}"
        }
      }
      runStage('test service') {
        sh "make wdeps_test ${imageTags}"
      }
      runStage('release service') {
        withGithubPrivkey {
          sh "make wc_release ${imageTags}"
        }
      }
    }
  }
}

