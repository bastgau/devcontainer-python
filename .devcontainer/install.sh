#!/bin/bash

export RED="\e[31m"
export GREEN="\e[32m"
export BLUE="\e[34m"
export YELLOW="\e[33m"
export ENDCOLOR="\e[0m"

cd "$WORKSPACE_PATH/.devcontainer/install"

install_files=$(ls | sort)

for install_file in $install_files; do
  if [ -f "$install_file" ];
  then
    echo -e "\n\e[104m Execute: $install_file \e[49m"
    chmod +x $install_file
    ./"$install_file"
    read -p "Are you sure? " -n 1 -r
  fi
done
