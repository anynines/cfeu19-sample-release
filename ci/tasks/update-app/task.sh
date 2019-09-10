#!/bin/bash

set -o errexit # Exit immediately if a simple command exits with a non-zero status
set -o nounset # Report the usage of uninitialized variables

echo 'Update App'

updated_app_repository_dir=${PWD}/updated-app
app_src_dir=src/cfeu19-sample-app
app_tag=$(<${PWD}/app-release/tag)

echo 'Clone repository...'
# We can't clone the repository in all cases because of the
# submodules. For this we would need a git private key and
# so on. Therefore, we copy it and so we are safe.
rsync -a ${PWD}/boshrelease/ ${updated_app_repository_dir}
cd ${updated_app_repository_dir}

# Make it idempotent
if ! [ "$(git -C ${app_src_dir} describe --tags --always)" == "${app_tag}" ]; then
  echo 'Update app submodule...'
  git -C ${app_src_dir} checkout ${app_tag}

  echo 'Commit updated app...'
  git add ${app_src_dir}
  git commit -m "Update App to ${app_tag}"
fi

echo 'Done'
