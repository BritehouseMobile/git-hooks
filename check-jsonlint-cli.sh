#!/bin/sh
#
# An example hook script to verify what is about to be committed.
# Called by "git commit" with no arguments.  The hook should
# exit with non-zero status after issuing an appropriate message if
# it wants to stop the commit.
#
# To enable this hook, rename this file to "pre-commit".

files=$(git diff --cached --name-only --diff-filter=ACM | grep -e "\.json\$")
if [ "$files" != "" ]; then
	pass=true
	for file in $files; do
		output=$(jsonlint-cli ${file} 2>&1)
		result=$?
		if [ $result -eq 0 ]; then
			echo "\t\033[32mjsonlint-cli Passed: ${file}\033[0m"
		else
			echo "\t\033[31mjsonlint-cli Failed: ${file}\033[0m"
			echo $output
			pass=false
		fi
	done

	if ! $pass; then
		exit 1
	fi
fi

exit 0
