#!/bin/bash

GITHUB_TOKEN="YOUR TOKEN"
GITHUB_USERNAME="YOURUSERNAME"

GITEA_URL="http://some.gitea.host.somewhere"
GITEA_TOKEN="YOUR GITEA TOKEN"

repos=$(curl -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/user/repos?per_page=100&affiliation=owner" | \
  jq -r '.[].name')

for repo in $repos; do
  echo "Migrating $repo..."
  
  # Create migration via Gitea API with token in URL
  curl -X POST "$GITEA_URL/api/v1/repos/migrate" \
    -H "Authorization: token $GITEA_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"clone_addr\": \"https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$repo.git\",
      \"repo_name\": \"$repo\",
      \"auth_token\": \"$GITHUB_TOKEN\",
      \"service\": \"github\",
      \"issues\": true,
      \"pull_requests\": true,
      \"releases\": true,
      \"milestones\": true,
      \"labels\": true,
      \"wiki\": true
    }"
done