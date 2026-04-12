#!/bin/bash

# Restart with systemd-run to apply resource limits
if [[ "$1" != "--inside-scope" ]]; then
	echo "Starting sandbox with resource limits..."
	systemd-run --user --scope \
		-p MemoryMax=12G \
		-p CPUWeight=40 \
		-p TasksMax=2000 \
		"$0" --inside-scope "$@"
	exit $?
fi
shift # remove --inside-scope from args

WORKSPACE_DIR=${1:-"$HOME/sandbox-workspace"}
WORKSPACE_DIR="$(realpath "$WORKSPACE_DIR")"
CONFIG_DIR="$HOME/.dotfiles/opencode/.config/opencode"
AUTH_DIR="$HOME/.local/share/opencode/auth.json"

# INNER_HOME="/home/agent"
# WORKSPACE_RELATIVE="$(echo "$WORKSPACE_DIR" | sed "s|$HOME/||")" # without $HOME prefix
# INNER_WORKSPACE_DIR="$INNER_HOME/$WORKSPACE_RELATIVE"
INNER_HOME="$HOME"
INNER_WORKSPACE_DIR="$WORKSPACE_DIR" # kinda necessary for python venvs

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
	MASK_ARGS+=("--bind" "$EMPTY_MASK" "$INNER_WORKSPACE_DIR/$relative_path") # empty tmpfs, masking the .env file
done < <(find "$WORKSPACE_DIR" -name ".env*" -not -name ".env.example")
# ==========================================

# ============== Add binaries ==============
BIN_ARGS=()
# node
NODE_BIN="$(which node | sed "s|$HOME/||")" # without $HOME prefix
if [ -n "$NODE_BIN" ]; then
	BIN_DIR="$(dirname "$NODE_BIN")"
	NODE_DIR="$(dirname "$BIN_DIR")"
	BIN_ARGS+=("--ro-bind" "$HOME/$NODE_DIR" "$INNER_HOME/$NODE_DIR")
	BIN_ARGS+=("--setenv" "PATH" "$INNER_HOME/$BIN_DIR:/usr/bin:/bin") # PATH
	BIN_ARGS+=("--bind" "$HOME/.npm" "$INNER_HOME/.npm")               # npm cache and config
fi
# python
# PYTHON_BIN="$(which python | sed "s|$HOME/||")" # without $HOME prefix
# if [ -n "$PYTHON_BIN" ]; then
# 	BIN_DIR="$(dirname "$PYTHON_BIN")"
# 	PYTHON_DIR="$(dirname "$BIN_DIR")"
# 	BIN_ARGS+=("--ro-bind" "$HOME/$PYTHON_DIR" "$INNER_HOME/$PYTHON_DIR")
# 	BIN_ARGS+=("--setenv" "PATH" "$INNER_HOME/$BIN_DIR:/usr/bin:/bin") # PATH
# fi
GH_EXISTS=$(which gh)
if [ -n "$GH_EXISTS" ]; then
	GH_TOKEN="$(gh auth token 2>/dev/null)"
	if [ -n "$GH_TOKEN" ]; then
		BIN_ARGS+=("--setenv" "GH_TOKEN" "$GH_TOKEN")
	fi
fi
GIT_EXISTS=$(which git)
if [ -n "$GIT_EXISTS" ]; then
	BIN_ARGS+=("--ro-bind" "$HOME/.gitconfig" "$INNER_HOME/.gitconfig")
fi
# chromium devtools
CHROMIUM_BIN=$(which chromium)
if [ -n "$CHROMIUM_BIN" ]; then
	mkdir -p "$HOME/.config/chromium/opencode-profile"
	CHROMIUM_DIR="$(dirname "$CHROMIUM_BIN")"
	BIN_ARGS+=("--bind" "$CHROMIUM_DIR" "$CHROMIUM_DIR")
	BIN_ARGS+=("--bind" "$HOME/.config/chromium/opencode-profile" "$INNER_HOME/.config/chromium/opencode-profile")
	BIN_ARGS+=("--dev-bind" "/dev/shm" "/dev/shm")
	BIN_ARGS+=("--dev-bind" "/dev/dri" "/dev/dri")
fi
# allow running graphical apps if inside a Wayland session
if [ -n "$WAYLAND_DISPLAY" ]; then
	BIN_ARGS+=("--ro-bind" "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY")
	BIN_ARGS+=("--setenv" "WAYLAND_DISPLAY" "$WAYLAND_DISPLAY")
fi

# include zen browser stuff
if [ -d "$HOME/.zen" ]; then
	BIN_ARGS+=("--ro-bind" "$HOME/.zen" "$INNER_HOME/.zen")
fi

# Docker
DOCKER_SOCK="/var/run/docker.sock"
if [ -S "$DOCKER_SOCK" ]; then
	BIN_ARGS+=("--bind" "$DOCKER_SOCK" "$DOCKER_SOCK")

	if [ -d "$HOME/.docker" ]; then
		BIN_ARGS+=("--ro-bind" "$HOME/.docker" "$INNER_HOME/.docker")
	fi
fi
# ==========================================

bwrap \
	--unshare-all \
	--share-net \
	--die-with-parent \
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
	--dir "$INNER_WORKSPACE_DIR" \
	\
	--bind "$WORKSPACE_DIR" "$INNER_WORKSPACE_DIR" \
	--bind-try "$HOME/.local/share/opencode" "$INNER_HOME/.local/share/opencode" \
	--bind-try "$HOME/.local/state/opencode" "$INNER_HOME/.local/state/opencode" \
	--ro-bind "$CONFIG_DIR" "$INNER_HOME/.config/opencode" \
	--ro-bind "$AUTH_DIR" "/$INNER_HOME/.local/share/opencode/auth.json" \
	\
	--chdir "$INNER_WORKSPACE_DIR" \
	"${MASK_ARGS[@]}" \
	\
	--setenv HOME "$INNER_HOME" \
	--setenv XDG_CONFIG_HOME "$INNER_HOME/.config" \
	--setenv PATH /usr/bin:/bin \
	\
	"${BIN_ARGS[@]}" \
	opencode
