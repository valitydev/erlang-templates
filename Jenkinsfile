#!groovy

baseImageTag = "5ea1e10733d806e40761b6c8eec93fc0c9657992"
buildImageTag = "785d48cbfa7e7f355300c08ba9edc6f0e78810cb"

def finalHook = {
  runStage('store CT logs') {
    dir('snakeoil') {
      archive '_build/test/logs/'
    }
  }
}

def embedImageTagsInMakefile = {
    sh "sed -i " +
        "-e 's/^BASE_IMAGE_TAG :=.*\$/BASE_IMAGE_TAG := ${baseImageTag}/' " +
        "-e 's/^BUILD_IMAGE_TAG :=.*\$/BUILD_IMAGE_TAG := ${buildImageTag}/' Makefile"
}

build('erlang-templates', 'docker-host', finalHook) {
  runStage('clone build_utils') {
    withGithubSshCredentials {
      sh "git clone git@github.com:rbkmoney/build_utils.git build_utils"
    }
  }

  runStage('load library pipeline') {
    load("build_utils/jenkins_lib/setup.groovy")(
            ["pipeDefault", "pipeErlangService", "pipeErlangLib"])
  }

  // erlang-service-template
  ws {
    try {
      checkoutRepo()
      loadBuildUtils()

      runStage('generate erlang service: snakeoil') {
        pipeDefault() {
            sh 'make wc_gen_service'
        }
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
        sh "git submodule add git@github.com:rbkmoney/build_utils.git build_utils"
      }
    }

    embedImageTagsInMakefile()
    pipeErlangService.runPipe(true, true, 'test')
  }

  // erlang-library-template
  ws {
    try {
      checkoutRepo()
      loadBuildUtils()

      runStage('generate erlang library: trickster') {
        pipeDefault() {
            sh 'make wc_gen_library'
            sh """
            cp                                    \\
              service-templates/Dockerfile.sh     \\
              service-templates/docker-compose.sh \\
              trickster/
            """
        }
      }

      runStage('archive trickster') {
        archive 'trickster/'
      }
    } finally {
      runStage('cleanup sub ws') {
        sh 'rm -rf * .* || echo ignore'
      }
    }
  } //close other ws

  runStage('unarchive trickster') {
    unarchive mapping: ['trickster/': '.']
    sh 'chmod 755 trickster/Dockerfile.sh trickster/docker-compose.sh'
  }

  dir('trickster') {
    runStage('init git repo') {
      sh 'git init'
      sh 'git config user.email "$CHANGE_AUTHOR_EMAIL"'
      sh 'git config user.name "$COMMIT_AUTHOR"'
      sh 'git add README.md'
      sh 'git commit -m "Initial commit"'
    }

    runStage('add git submodule') {
      withGithubSshCredentials {
        sh "git submodule add git@github.com:rbkmoney/build_utils.git build_utils"
      }
    }

    embedImageTagsInMakefile()
    pipeErlangLib.runPipe(false, true, 'test')
  }
}
