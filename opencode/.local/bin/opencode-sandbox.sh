#!/bin/bash

# NOTE: no git access

WORKSPACE_DIR=${1:-"$HOME/sandbox-workspace"}
CONFIG_DIR="$HOME/.dotfiles/opencode/.config/opencode"
AUTH_DIR="$HOME/.local/share/opencode/auth.json"

# check workspace dir exists
if [ ! -d "$WORKSPACE_DIR" ]; then
	echo "Workspace directory '$WORKSPACE_DIR' does not exist."
	exit 1
fi

EMPTY_MASK=$(mktemp)
trap 'rm -f "$EMPTY_MASK"' EXIT

# ========== Hide sensitive files ==========
MASK_ARGS=()
# .env
while IFS= read -r env_file; do
	relative_path="${env_file#$WORKSPACE_DIR/}"
	MASK_ARGS+=("--bind" "$EMPTY_MASK" "/home/agent/project/$relative_path") # empty tmpfs, masking the .env file
done < <(find "$WORKSPACE_DIR" -name ".env*" -not -name ".env.example")
# ==========================================

bwrap \
	--unshare-all \
	--share-net \
	--die-with-parent \
	--new-session \
	\
	--ro-bind /usr /usr \
	--ro-bind /bin /bin \
	--ro-bind /lib /lib \
	--ro-bind /lib64 /lib64 \
	--ro-bind /sbin /sbin \
	\
	--proc /proc \
	--dev /dev \
	--tmpfs /tmp \
	--tmpfs /run \
	\
	--ro-bind /etc/resolv.conf /etc/resolv.conf \
	--ro-bind /etc/hosts /etc/hosts \
	--ro-bind /etc/nsswitch.conf /etc/nsswitch.conf \
	--ro-bind /etc/passwd /etc/passwd \
	--ro-bind /etc/group /etc/group \
	--ro-bind /etc/localtime /etc/localtime \
	\
	--ro-bind /etc/ssl /etc/ssl \
	--ro-bind /etc/ca-certificates /etc/ca-certificates \
	\
	--tmpfs /home/agent \
	--dir /home/agent/.config \
	--dir /home/agent/project \
	\
	--bind "$WORKSPACE_DIR" "/home/agent/project" \
	--bind-try "$HOME/.local/share/opencode" "/home/agent/.local/share/opencode" \
	--bind-try "$HOME/.local/state/opencode" "/home/agent/.local/state/opencode" \
	--ro-bind "$CONFIG_DIR" "/home/agent/.config/opencode" \
	--ro-bind "$AUTH_DIR" "/home/agent/.local/share/opencode/auth.json" \
	\
	--chdir /home/agent/project \
	"${MASK_ARGS[@]}" \
	\
	--setenv HOME /home/agent \
	--setenv XDG_CONFIG_HOME /home/agent/.config \
	--setenv PATH /usr/bin:/bin \
	opencode
