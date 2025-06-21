# requires yad
# theme with nwg-look as yad's gtk
ACTION_NAME="$1"
COMMAND="$2"

yad \
	--text="\n<span font='16'>$ACTION_NAME?</span>\n\n\n" \
	--text-align="center" \
	--button='Cancel':0 --button="$ACTION_NAME":1 &&
	"$COMMAND"
