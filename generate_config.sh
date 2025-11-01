#!/bin/bash

set -e

if [ -z "$PANGOLIN_HOST" ]; then
  echo "Error: PANGOLIN_HOST environment variable is not set."
  exit 1
fi

SECRET=$(openssl rand -hex 32)

cat > config.yml <<EOF
app:
  dashboard_url: "https://$PANGOLIN_HOST"
domains:
  domain1:
    base_domain: "$PANGOLIN_HOST"
    cert_resolver: "myresolver"
server:
  secret: "$SECRET"
gerbil:
  base_endpoint: "$PANGOLIN_HOST"
flags:
  require_email_verification: false
  disable_signup_without_invite: true
  disable_user_create_org: true
EOF

echo "config.yml generated successfully."
echo "You can now populate the 'pangolin-config' volume with this file."
echo "For example, you can use the following command after creating the volume with 'docker-compose up -d --no-start':"
echo "docker cp $(pwd)/config.yml $(docker-compose ps -q pangolin):/app/config/config.yml"
