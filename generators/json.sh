#!/bin/bash

addToConfig "jsonGenerator_indent"   "2"     "Num of spaces / tabs to indent"
addToConfig "jsonGenerator_useTabs"  "false" "Use tabs instead of space"
addToConfig "jsonGenerator_rootName" "nodes" "Name of the root array"

generator_json() {
  local spaceChar=' ' indent="${CONFIG[jsonGenerator_indent]}" level=1
  [[ "${CONFIG[jsonGenerator_useTabs]}" == "true" ]] && spaceChar='\t'

  echo "{"
  printNumChar $(( level * indent )) "$spaceChar"
  echo "\"${CONFIG[jsonGenerator_rootName]}\": ["
  (( level++ ))

  local numNodes i
  numNodes=$(getNumNodes)

  for (( i=0; i < numNodes; i++ )); do
    printNumChar $(( level * indent )) "$spaceChar"
    echo '{'
    (( level++ ))

    for j in IPv4 IPv6 port key maintainer location; do
      printNumChar $(( level * indent )) "$spaceChar"
      echo "\"$j\": \"$(getNode $i $j)\","
    done

    printNumChar $(( level * indent )) "$spaceChar"
    echo "\"status\": \"$(getNode $i status)\""

    (( level-- ))
    printNumChar $(( level * indent )) "$spaceChar"
    if (( i == (numNodes - 1) )); then
      echo '}'
    else
      echo '},'
    fi
  done

  (( level-- ))
  printNumChar $(( level * indent )) "$spaceChar"
  echo "]"
  echo "}"
}
