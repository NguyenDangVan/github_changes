#!/bin/bash

#!/bin/bash

read -p "Enter the username: " USER
read -p "Enter the time period(ex: 1 week ago or 2024-07-01): " SINCE

# Get commit hashes for the specified user and time period
COMMITS=$(git log --author="$USER" --since="$SINCE" --pretty=format:"%H")

ADDED=0
DELETED=0
MODIFIED=0

# Loop through each commit and count lines
for COMMIT in $COMMITS; do
  STATS=$(git show --pretty="" --numstat $COMMIT)
  while read -r LINE; do
    ADDED_LINES=$(echo $LINE | awk '{print $1}')
    DELETED_LINES=$(echo $LINE | awk '{print $2}')
    # Ignore binary files marked with "-"
    if [ "$ADDED_LINES" != "-" ] && [ "$DELETED_LINES" != "-" ]; then
      ADDED=$((ADDED + ADDED_LINES))
      DELETED=$((DELETED + DELETED_LINES))
      MODIFIED=$((MODIFIED + ADDED_LINES + DELETED_LINES))
    fi
  done <<< "$STATS"
done

# Output the results
echo "Weekly stats for user $USER:"
echo "Lines added: $ADDED"
echo "Lines deleted: $DELETED"
echo "Lines modified: $MODIFIED"
