#!/bin/bash
set -eu

active_layout=$(~/scripts/get-current-layout.sh)
~/scripts/get-layout-id.sh "$active_layout"
