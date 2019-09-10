#!/bin/bash

set -o errexit # Exit immediately if a simple command exits with a non-zero status
set -o nounset # Report the usage of uninitialized variables

echo "Update App"

updated_app_repository_dir=${PWD}/updated-app
app_tag=$(<${PWD}/app-release/tag)

echo 'Clone repository...'
# We can't clone the repository in all cases because of the
# submodules. For this we would need a git private key and
# so on. Therefore, we copy it and so we are safe.
rsync -a ${PWD}/boshrelease/ ${updated_app_repository_dir}
cd ${updated_app_repository_dir}

echo 'Update app submodule...'

echo 'Commit updated app...'
git add src/cfeu19-sample-app
git commit -m "Update App to ${app_tag}"

echo 'Done'
