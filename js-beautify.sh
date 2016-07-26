#!/bin/sh
#
# An example hook script to verify what is about to be committed.
# Called by "git commit" with no arguments.  The hook should
# exit with non-zero status after issuing an appropriate message if
# it wants to stop the commit.
#
# To enable this hook, rename this file to "pre-commit".

DIR=$(dirname $0)

files=$(git diff --cached --name-only --diff-filter=ACM | grep -e "\.\(js\|json\)\$")
if [ "$files" != "" ]; then
	for file in $files; do
		result=$(js-beautify -r ${file} | grep -oe "- unchanged")
		if [ "${result}" != "- unchanged" ]; then
			echo "\t\033[32mjs-beautify ${file}\033[0m (changed and adding changes to git before commit)"
			git add ${file}
		else
			echo "\tjs-beautify ${file} (unchanged)"
		fi
	done
fi

exit 0
