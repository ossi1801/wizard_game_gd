#!/bin/sh
echo -ne '\033c\033]0;WizardGame\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/WizardGame.x86_64" "$@"
