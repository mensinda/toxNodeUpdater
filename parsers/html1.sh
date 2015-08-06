#!/bin/bash

addToConfig "html1Parser_sectioneditNum" "3" "Sectionedit table id"

parser_html1() {
  argsRequired 1 $#
  local FILE i rowCounter=1 node=()
  msg2 "Reading file"
  FILE="$(<"$1")" # Read entire file

  msg2 "Removing unnecessary stuff"

  # Remove everything but the table we want
  FILE="${FILE##*sectionedit${CONFIG[html1Parser_sectioneditNum]}}"
  FILE="${FILE%%</table></div>*}"
  FILE="${FILE##*</thead>}"

  # Remove all strings we do not need (extglob patterns are to slow)
  FILE="${FILE//<tr class=\"/}"
  FILE="${FILE//<td class=\"/}"
  FILE="${FILE//\">/}"
  FILE="${FILE//<\/tr>/}"
  FILE="${FILE//<\/td>/}"

  FILE="$(echo "$FILE" | tr -d '\n')"  # Remove newlines
  FILE="$(echo "$FILE" | tr '\t' ' ')" # Tabs to spaces
  FILE="$(echo "$FILE" | tr -s ' ')"   # Remove duplicate spaces

  FILE=( $FILE ) # Convert to array

  msg2 "Parsing remainig bits"
  for (( i=0; i < ${#FILE[@]}; )); do
    assertEqual "${FILE[$i]}" "row${rowCounter}"; (( i++ ));
    assertEqual "${FILE[$i]}" "col0";             (( i++ ));
    node[0]="${FILE[$i]}";                        (( i++ )); # IPv4
    assertEqual "${FILE[$i]}" "col1";             (( i++ ));
    node[1]="${FILE[$i]}";                        (( i++ )); # IPv6
    assertEqual "${FILE[$i]}" "col2";             (( i++ ));
    node[2]="${FILE[$i]}";                        (( i++ )); # Port
    assertEqual "${FILE[$i]}" "col3";             (( i++ ));
    node[3]="${FILE[$i]}";                        (( i++ )); # Key
    assertEqual "${FILE[$i]}" "col4";             (( i++ ));
    node[4]="${FILE[$i]}";                        (( i++ )); # Maintainer
    while [[ "${FILE[$i]}" != "col5" ]]; do
      node[4]+=" ${FILE[$i]}";                    (( i++ ));
    done
    assertEqual "${FILE[$i]}" "col5";             (( i++ ));
    node[5]="${FILE[$i]}";                        (( i++ )); # Location
    assertEqual "${FILE[$i]}" "col6";             (( i++ ));
    node[6]="${FILE[$i]}";                        (( i++ )); # Status

    addNode "${node[0]}" "${node[1]}" "${node[2]}" "${node[3]}" "${node[4]}" "${node[5]}" "${node[6]}"

    (( rowCounter++ ))
  done
}
