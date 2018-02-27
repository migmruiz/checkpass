#!/bin/bash

me=$(basename "$0")

command -v curl >/dev/null 2>&1 || command -v http >/dev/null 2>&1 || {
	echo >&2 "$me require cURL or HTTPie but none of them are installed. Aborting."
	exit 1
}

get() {
	if command -v http 2>/dev/null; then
		http GET "$@" --body
	else
		curl --silent "$@"
	fi
}

read -rsp 'Type the password you want to check: ' passvar
echo

hash=$(echo -n "$passvar" | openssl sha1)
passvar=

prefix=$(echo -n "$hash" | cut -c1-5)
suffix=$(echo -n "$hash" | cut -c6-)

breaches=$(get "https://api.pwnedpasswords.com/range/$prefix" | grep -i "$suffix" | cut -c37- | tr -dc '0-9')

printf "%d" "$breaches"

if [ ! -z "$breaches" ]; then
	printf ' passwords breaches... :(\n'
else
	printf '\bNo passwords breaches! Congrats ;)\n'
fi

exit 0
