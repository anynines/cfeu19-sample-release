#!/bin/bash

set -o errexit # Exit immediately if a simple command exits with a non-zero status
set -o nounset # Report the usage of uninitialized variables

echo "Build final release"

final_boshrelease_repository_dir=${PWD}/final-boshrelease-repository
final_boshrelease_artifacts_dir=${PWD}/final-boshrelease-artifacts
boshrelease_version=$(<${PWD}/version/version)
boshrelease_name=cfeu19-sample-${boshrelease_version}
boshrelease_manifest_file=${final_boshrelease_repository_dir}/releases/cfeu19-sample/${boshrelease_name}.yml
boshrelease_tarball_file=${final_boshrelease_artifacts_dir}/${boshrelease_name}.tgz
boshrelease_checksum_file=${final_boshrelease_artifacts_dir}/${boshrelease_name}.tgz.sha256

echo 'Clone release repository...'
# We can't clone the repository in all cases because of the
# submodules. For this we would need a git private key and
# so on. Therefore, we copy it and so we are safe.
rsync -a ${PWD}/boshrelease/ ${final_boshrelease_repository_dir}
cd ${final_boshrelease_repository_dir}

# Make it idempotent
if ! [ -e ${boshrelease_manifest_file} ]; then
  echo 'Create config/private.yml...'
  echo "${BOSHRELEASE_PRIVATE_CONFIG}" > ${final_boshrelease_repository_dir}/config/private.yml

  echo 'Create final release...'
  bosh --non-interactive create-release --final --name cfeu19-sample --version "${boshrelease_version}"

  echo 'Commit final release...'
  git add .final_builds/ releases/
  git commit -m "Release v${boshrelease_version}"
fi

echo 'Create final release tarball...'
bosh --non-interactive create-release --tarball ${boshrelease_tarball_file} ${boshrelease_manifest_file}

echo 'Create checksum for final release...'
cd ${final_boshrelease_artifacts_dir}
shasum -a 256 ${boshrelease_name}.tgz > ${boshrelease_checksum_file}
echo $(<${boshrelease_checksum_file})

echo 'Done'
