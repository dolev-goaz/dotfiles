#!/bin/bash
echo "Deleting remote deleted branches from local git..."

git fetch --all --prune

for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do
    git branch -d $branch
done

echo "Done!"
