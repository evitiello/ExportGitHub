#!/bin/bash

GITHUB_TOKEN="YOUR GITHUB TOKEN"
GITHUB_USERNAME="YOUR USERNAME"

repos=$(curl -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/user/repos?per_page=100&affiliation=owner" | \
  jq -r '.[].name')

for repo in $repos; do
  echo "Cloning $repo..."
  
  git clone https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$repo.git
done