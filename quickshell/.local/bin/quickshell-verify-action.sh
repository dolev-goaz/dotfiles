# requires yad
# theme with nwg-look as yad's gtk
ACTION_NAME="$1"
COMMAND="$2"
if yad \
	--text="\n<span font='16'>$ACTION_NAME?</span>\n\n\n" \
	--text-align="center" \
	--button='Cancel':1 --button="$ACTION_NAME":0; then
	if [ -n "$COMMAND" ]; then
		"$COMMAND"
	else
		exit 0
	fi
else
	exit 1
fi
