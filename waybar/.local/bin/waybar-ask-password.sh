#!/usr/bin/env bash
exec yad --entry \
	--title="Authentication Required" \
	--text="Enter your sudo password:" \
	--hide-text
