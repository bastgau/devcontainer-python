#!/bin/bash

. "$WORKSPACE_PATH/.devcontainer/install/color.sh"

cd "$WORKSPACE_PATH/.devcontainer/install"

install_files=$(ls [0-9][0-9]* | sort)
count_files=$(ls [0-9][0-9]* | wc -l)

echo -e "\n${BLUE} We have found $count_files installation files.${ENDCOLOR}"

for install_file in $install_files; do
  if [ -f "$install_file" ];
  then
    echo -e "\n\e[104m Execute: $install_file \e[49m"
    chmod +x $install_file
    ./"$install_file"
    read -p "Are you sure? " -n 1 -r
  fi
done
