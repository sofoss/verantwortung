#!/bin/bash 
current_time=$(date "+%Y.%m.%d-%H.%M.%S")

FILE=lastimport.txt
if test -f "$FILE"; then
    echo "$FILE exists."
    last_import=$(head -n 1 lastimport.txt)
else 
    last_import="1900.01.01-00.00.01"
fi

while read p; do
  echo "twint -u $p -o export.json --json --since $last_import"
  ./../twint/twint -u $p -o export.json --json --since "$last_import"
done <users.txt

echo "Aktualisiere Import-Datum: $current_time"
echo "$current_time" > lastimport.txt
