#!/bin/bash

# NOTE: no git access

# Restart with systemd-run to apply resource limits
if [[ "$1" != "--inside-scope" ]]; then
	echo "Starting sandbox with resource limits..."
	systemd-run --user --scope \
		-p MemoryMax=6G \
		-p CPUWeight=40 \
		-p TasksMax=1000 \
		"$0" --inside-scope "$@"
	exit $?
fi
shift # remove --inside-scope from args

WORKSPACE_DIR=${1:-"$HOME/sandbox-workspace"}
CONFIG_DIR="$HOME/.dotfiles/opencode/.config/opencode"
AUTH_DIR="$HOME/.local/share/opencode/auth.json"

INNER_HOME="/home/agent"

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
	MASK_ARGS+=("--bind" "$EMPTY_MASK" "$INNER_HOME/project/$relative_path") # empty tmpfs, masking the .env file
done < <(find "$WORKSPACE_DIR" -name ".env*" -not -name ".env.example")
# ==========================================

# ============== Add binaries ==============
BIN_ARGS=()
NODE_BIN="$(which node | sed "s|$HOME/||")" # without $HOME prefix
if [ -n "$NODE_BIN" ]; then
	BIN_DIR="$(dirname "$NODE_BIN")"
	NODE_DIR="$(dirname "$BIN_DIR")"
	BIN_ARGS+=("--ro-bind" "$HOME/$NODE_DIR" "$INNER_HOME/$NODE_DIR")
	BIN_ARGS+=("--setenv" "PATH" "$INNER_HOME/$BIN_DIR:/usr/bin:/bin") # PATH
fi
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
	--tmpfs "$INNER_HOME" \
	--dir "$INNER_HOME/.config" \
	--dir "$INNER_HOME/project" \
	\
	--bind "$WORKSPACE_DIR" "$INNER_HOME/project" \
	--bind-try "$HOME/.local/share/opencode" "$INNER_HOME/.local/share/opencode" \
	--bind-try "$HOME/.local/state/opencode" "$INNER_HOME/.local/state/opencode" \
	--ro-bind "$CONFIG_DIR" "$INNER_HOME/.config/opencode" \
	--ro-bind "$AUTH_DIR" "/$INNER_HOME/.local/share/opencode/auth.json" \
	\
	--chdir "$INNER_HOME/project" \
	"${MASK_ARGS[@]}" \
	\
	--setenv HOME "$INNER_HOME" \
	--setenv XDG_CONFIG_HOME "$INNER_HOME/.config" \
	--setenv PATH /usr/bin:/bin \
	\
	"${BIN_ARGS[@]}" \
	opencode
