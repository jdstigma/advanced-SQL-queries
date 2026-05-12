#!/bin/bash

echo "127.0.0.1 $(localhost)" | sudo tee -a /etc/hosts > /dev/null

echo "Waiting for PostgreSQL..."
for i in $(seq 1 60); do
  psql -h db -U postgres postgres -c '\q' 2>/dev/null && break
  echo "Attempt $i/60 - waiting..."
  sleep 10
done

if [ -f .devcontainer/setup-postgresql.sql ]; then
  psql -h db -U postgres postgres < .devcontainer/setup-postgresql.sql
fi
