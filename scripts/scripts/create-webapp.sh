#!/bin/bash

# Usage: ./make-webapp.sh <url> [browser]
BROWSER="${2:-chromium}"
URL="$1"

if [ -z "$URL" ]; then
	echo "Usage: $0 <url> [browser]"
	exit 1
fi

DOMAIN=$(echo "$URL" | awk -F/ '{print $3}')

# Fetch HTML
HTML=$(curl -sL "$URL")

# Try to extract title
AUTO_TITLE=$(echo "$HTML" | grep -oP '(?<=<title>)(.*?)(?=</title>)' | head -n1)
if [ -z "$AUTO_TITLE" ]; then
	AUTO_TITLE="$DOMAIN"
fi

# Ask user to confirm or replace title
read -rp "Detected title: '$AUTO_TITLE'. Press Enter to accept or type a new title: " TITLE
TITLE=${TITLE:-$AUTO_TITLE}

# Extract icon candidates
ICON_CANDIDATES=$(echo "$HTML" |
	grep -oP '<link[^>]+rel=["'"'"'](?:icon|shortcut icon)["'"'"'][^>]+href=["'"'"'][^"'"'"']+' |
	grep -oP 'href=["'"'"'][^"'"'"']+' |
	sed 's/href=["'"'"']//')

# Ask user to confirm / pick icon
if [ -z "$ICON_CANDIDATES" ]; then
	echo "No icon found automatically."
	read -rp "Enter icon URL (or leave empty to use default web browser icon): " ICON_URL
else
	echo "Found icon candidates:"
	select ICON_URL in $ICON_CANDIDATES "Enter manually"; do
		if [ "$ICON_URL" = "Enter manually" ]; then
			read -rp "Enter icon URL: " ICON_URL
		fi
		break
	done
fi

# Handle relative URLs
if [[ -n "$ICON_URL" && "$ICON_URL" != http* ]]; then
	ICON_URL="https://$DOMAIN/$ICON_URL"
fi

# Download icon
ICON_PATH="$HOME/.local/share/icons/${DOMAIN}.png"
if [ -n "$ICON_URL" ]; then
	curl -sL "$ICON_URL" -o "$ICON_PATH" || ICON_PATH="/usr/share/icons/hicolor/48x48/apps/web-browser.png"
else
	ICON_PATH="/usr/share/icons/hicolor/48x48/apps/web-browser.png"
fi

# Create .desktop file
DESKTOP_FILE="$HOME/.local/share/applications/custom-webapp-${TITLE}.desktop"
cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=$TITLE
Exec=$BROWSER --app=$URL
Icon=$ICON_PATH
Type=Application
Categories=Network;
EOF

echo "Created launcher: $DESKTOP_FILE"
