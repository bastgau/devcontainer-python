#!/bin/bash

. "$WORKSPACE_PATH/tools/color.sh"

echo -e "\n${BLUE}#############################################################${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#####     Fix Mypy extension                            #####${ENDCOLOR}"
echo -e "${BLUE}#####                                                   #####${ENDCOLOR}"
echo -e "${BLUE}#############################################################${ENDCOLOR}"

echo -e "\n${GREEN}> Fix Mypy extension.${ENDCOLOR}\n"

ORIGINAL_FILE="$HOME/.vscode-server/extensions/ms-python.mypy-type-checker-2023.4.0/bundled/tool/lsp_server.py"

if [ -f "$ORIGINAL_FILE" ]; then

    cp "$ORIGINAL_FILE" /tmp/lsp_server.py

    # MODIFICATION #1.

cat <<EOF >>/tmp/python_script.py

new_string = 'r"^(?P<location>(?P<filepath>..[^:]*):(?P<line>\d+)(?::(?P<char>\d+))?(?::(?P<end_line>\d+)(?::(?P<end_char>\d+))?)?): (?P<type>\w+): (?P<message>.*?)(?:  \[(?P<code>[\w-]+)\])?$"'
old_string = 'r"^(?P<location>(?P<filepath>..[^:]*):(?P<line>\d+):(?P<char>\d+)(?::(?P<end_line>\d+):(?P<end_char>\d+))?): (?P<type>\w+): (?P<message>.*?)(?:  \[(?P<code>[\w-]+)\])?$"'

with open("/tmp/lsp_server.py", "r") as file:
    content = file.read()

content = content.replace(old_string, new_string)

with open("/tmp/lsp_server.py", "w") as file:    file.write(content)
EOF

    python3 "/tmp/python_script.py"

    # MODIFICATION #2.

cat <<EOF >>/tmp/python_script.py
new_string = """
        try: # modified
            start_char =  int(data["char"]) # modified
        except: # modified
            start_char = 1 # modified
"""

old_string = '    start_char = int(data["char"])'

with open("/tmp/lsp_server.py", "r") as file:
    content = file.read()

content = content.replace(old_string, new_string)

with open("/tmp/lsp_server.py", "w") as file:
    file.write(content)
EOF

    python3 "/tmp/python_script.py"

    # MODIFICATION #3.

cat <<EOF >>/tmp/python_script.py
new_string = """
        try: # modified
            end_char =  data["end_char"] # modified
        except: # modified
            end_char = None # modified
"""

old_string = '    end_char = data["end_char"]'

with open("/tmp/lsp_server.py", "r") as file:
    content = file.read()

content = content.replace(old_string, new_string)

with open("/tmp/lsp_server.py", "w") as file:
    file.write(content)
EOF

    python3 "/tmp/python_script.py"

    rm "/tmp/python_script.py"

    cp "$ORIGINAL_FILE" "$ORIGINAL_FILE".bkp
    mv "/tmp/lsp_server.py" "$ORIGINAL_FILE"

    echo -e "Extension file has been modified to fix issue.\n"

else
    echo -e "\n${YELLOW}> Nothing to do ... Maybe a new extension version was releases (2023.4.0).${YELLOW}\n"
fi
