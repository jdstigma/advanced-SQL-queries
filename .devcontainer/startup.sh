#!/bin/bash

# Fix hostname resolution
echo "127.0.0.1 $(hostname)" | sudo tee -a /etc/hosts > /dev/null

# Wait for PostgreSQL
echo "Waiting for PostgreSQL..."
for i in $(seq 1 30); do
  psql -h 127.0.0.1 -U postgres postgres -c '\q' 2>/dev/null && break
  echo "Attempt $i/30 - waiting..."
  sleep 2
done

# Run setup SQL
if [ -f .devcontainer/setup-postgresql.sql ]; then
  psql -h 127.0.0.1 -U postgres postgres < .devcontainer/setup-postgresql.sql
fi
