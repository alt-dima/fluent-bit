#!/bin/bash
set -eu

REMOTE_HOST=${REMOTE_HOST:-127.0.0.1}

if command -v http; then
    http -v "$REMOTE_HOST":2020/api/v1/trace/dummy.0 output=stdout prefix=trace. params:='{"format":"json"}'
elif command -v curl; then
    curl --header 'Content-Type: application/json' --data '{"output": "stdout", "params": { "format": "json" }, "prefix": "trace."}' "$REMOTE_HOST":2020/api/v1/trace/dummy.0
else
    echo "No curl or httpie installed"
    if command -v apt-get; then
        apt-get update
        apt-get install -y curl
    elif command -v yum; then
        yum install -y curl
    else
        exit 1
    fi
    curl --header 'Content-Type: application/json' --data '{"output": "stdout", "params": { "format": "json" }, "prefix": "trace."}' "$REMOTE_HOST":2020/api/v1/trace/dummy
fi
