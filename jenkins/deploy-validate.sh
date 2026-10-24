#!/bin/sh
set -eu
case "$TARGET_ENVIRONMENT" in
  dev|test|acceptance|production) ;;
  *) echo "Invalid deployment environment."; exit 1 ;;
esac
case "$CI_BUILD_NUMBER" in
  ""|*[!0-9]*)
    echo "Enter a valid numeric CI build number."
    exit 1
    ;;
esac
rm -rf incoming deploy-context
mkdir -p incoming deploy-context
