#!/bin/bash

command -v http >/dev/null 2>&1 || { echo >&2 "I require http but it's not installed. Install it with brew: 'brew install httpie'. Aborting."; exit 1; }

read -sp 'Type the password you want to check: ' passvar
echo

hash=$(echo -n $passvar | openssl sha1)
passvar=

prefix=$(echo -n $hash | cut -c1-5)
suffix=$(echo -n $hash | cut -c6-)

breaches=$(http GET https://api.pwnedpasswords.com/range/$prefix --body | grep -i $suffix  | cut -c37- | tr -dc '0-9')

printf "%d" $breaches

if [ $breaches > "0" ]; then
	printf " passwords breaches... :(\n"
else
	printf "\bNo passwords breaches! Congrats ;)\n"
fi

exit 0
