#! /usr/bin/bash

ISTIO_LATEST=$(curl -sL https://github.com/istio/istio/releases | grep -o 'releases/[0-9]*.[0-9]*.[0-9]*/' | sort -V | tail -1 | awk -F'/' '{ print $2}')

jq -n --arg istio_latest "$ISTIO_LATEST" \
      '{"istio_latest":$istio_latest}'


