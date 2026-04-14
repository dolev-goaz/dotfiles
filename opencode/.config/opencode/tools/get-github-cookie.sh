#!/bin/bash

COOKIE_DB=$(find ~/.zen -name cookies.sqlite)
TMP_FILE=$(mktemp)
trap "rm -f $TMP_FILE" EXIT

cp "$COOKIE_DB" "$TMP_FILE"
SESSION_COOKIE=$(sqlite3 "$TMP_FILE" \
	"SELECT value \
        FROM moz_cookies \
        WHERE host = 'github.com' \
          AND name = 'user_session' \
        ORDER BY lastAccessed DESC \
        LIMIT 1;")

if [ -z "$SESSION_COOKIE" ]; then
	echo "Error: No GitHub session cookie found." >&2
	exit 1
fi

echo "$SESSION_COOKIE"
