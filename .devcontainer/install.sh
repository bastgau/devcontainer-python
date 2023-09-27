#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

cd "$WORKSPACE_PATH/.devcontainer/install"

install_files=$(ls [0-9][0-9]* | sort)
count_files=$(ls [0-9][0-9]* | wc -l)

echo -e "\n${BLUE} We have found $count_files installation files.${ENDCOLOR}"

for install_file in $install_files; do
    if [ -f "$install_file" ]; then
        echo -e "\n\e[104m Execute: $install_file \e[49m"

        if [ ! -x "$install_file" ]; then
            chmod +x "$install_file"
        fi

        ./"$install_file"

        if [ "$?" -ge 1 ]; then
            exit 1
        else
            echo -e "${YELLOW}... Press any key to continue ..."
            read -s -p " " -n 1 -r
            echo -e "${ENDCOLOR}"
        fi

    fi
done

echo -e "${YELLOW}Installation is finished!${ENDCOLOR}"
echo -e "${YELLOW}You can close all terminal windows and re-open a new terminal!${ENDCOLOR}\n"
