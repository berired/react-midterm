#!/bin/sh
set -eu
case "$TARGET_ENVIRONMENT" in
  dev) PORT=8081 ;;
  test) PORT=8082 ;;
  acceptance) PORT=8083 ;;
  production) PORT=8084 ;;
  *) echo "Invalid environment."; exit 1 ;;
esac
ARTIFACT="incoming/react-app-${CI_BUILD_NUMBER}.tar.gz"
CONTAINER="react-${TARGET_ENVIRONMENT}"
IMAGE="react-midterm-release:${CI_BUILD_NUMBER}"
test -f "$ARTIFACT"
tar -xzf "$ARTIFACT" -C deploy-context
test -f deploy-context/site/index.html
test -f deploy-context/site/release.json
test -f deploy-context/Dockerfile
# Package existing files with Nginx; do not rebuild React.
docker build -t "$IMAGE" deploy-context
# Replace only the selected environment.
if docker container inspect "$CONTAINER" >/dev/null 2>&1; then
  docker rm -f "$CONTAINER"
fi
docker run -d \
  --name "$CONTAINER" \
  --label "midterm.ci-build=${CI_BUILD_NUMBER}" \
  --label "midterm.environment=${TARGET_ENVIRONMENT}" \
  -p "${PORT}:80" \
  "$IMAGE"
READY=0
for attempt in 1 2 3 4 5; do
  if docker exec "$CONTAINER" \
    wget -q -O /dev/null http://127.0.0.1/; then
    READY=1
    break
  fi
  sleep 2
done
if [ "$READY" -ne 1 ]; then
  echo "Deployment failed its application check."
  docker logs "$CONTAINER"
  exit 1
fi
echo "Deployment successful."
echo "Environment: ${TARGET_ENVIRONMENT}"
echo "Source CI build: ${CI_BUILD_NUMBER}"
echo "Browser URL: http://localhost:${PORT}"
cat deploy-context/site/release.json
