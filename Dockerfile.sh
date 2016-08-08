#!/bin/bash
cat <<EOF
FROM $BASE_IMAGE
MAINTAINER Anton Belyaev <a.belyaev@rbkmoney.com>
LABEL base_image_tag=$BASE_IMAGE_TAG
LABEL build_image_tag='n/a'
# A bit of magic to get a proper branch name
# even when the HEAD is detached (Hey Jenkins!
# BRANCH_NAME is available in Jenkins env).
LABEL branch=$( \
  if [ "HEAD" != $(git rev-parse --abbrev-ref HEAD) ]; then \
    echo $(git rev-parse --abbrev-ref HEAD); \
  elif [ -n "$BRANCH_NAME" ]; then \
    echo $BRANCH_NAME; \
  else \
    echo $(git name-rev --name-only HEAD); \
  fi)
LABEL commit=$(git rev-parse HEAD)
LABEL commit_number=$(git rev-list --count HEAD)
EOF

