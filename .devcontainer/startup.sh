#!/bin/bash

echo "127.0.0.11 $(hostname)" | sudo tee -a /etc/hosts > /dev/null

echo "Waiting for PostgreSQL..."
for i in $(seq 1 30); do
  psql -h db -U postgres postgres -c '\q' 2>/dev/null && break
  echo "Attempt $i/30 - waiting..."
  sleep 2
done

if [ -f .devcontainer/setup-postgresql.sql ]; then
  psql -h db -U postgres postgres < .devcontainer/setup-postgresql.sql
fi
