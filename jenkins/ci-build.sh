#!/bin/sh
set -eu
IMAGE="react-midterm-ci:${BUILD_NUMBER}"
TEMP_CONTAINER="react-ci-extract-${BUILD_NUMBER}"
# Remove output left by earlier builds.
rm -rf artifacts extracted
mkdir -p artifacts extracted/site
cleanup() {
  docker rm -f "$TEMP_CONTAINER" >/dev/null 2>&1 || true
}
trap cleanup EXIT
# Install dependencies, test, and build using Dockerfile.
docker build --progress=plain -t "$IMAGE" .
# Extract the compiled application from the final image.
docker create --name "$TEMP_CONTAINER" "$IMAGE"
docker cp "$TEMP_CONTAINER:/usr/share/nginx/html/." extracted/site/
# Record the source CI build and Git commit.
cat > extracted/site/release.json <<EOF
{
  "ci_build": "${BUILD_NUMBER}",
  "git_commit": "${GIT_COMMIT}"
}
EOF
# Include the Dockerfile used to serve the artifact.
cp Dockerfile.deploy extracted/Dockerfile
# Package the compiled files and serving Dockerfile.
tar -czf "artifacts/react-app-${BUILD_NUMBER}.tar.gz" \
  -C extracted site Dockerfile
echo "Created artifact: react-app-${BUILD_NUMBER}.tar.gz"
echo "Source commit: ${GIT_COMMIT}"
