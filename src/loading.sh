#!/bin/bash

PARSERS=()
GENERATORS=()

loadConfig() {
  argsRequired 1 $#
  msg2 "config file"
  [ -f "$1" ] && parseConfigFile "$1"
}

loadParsers() {
  argsRequired 1 $#
  msg2 "parsers"

  local name i
  for i in ${1}/*; do
    source "$i"
    name="$(basename "$i")"
    name="${name/%.sh/}"
    type -t "parser_${name}" &> /dev/null
    (( $? != 0 )) && die "Invalid parser file '$i'"
    found2 "$name"
    PARSERS+=("$name")
  done
}

loadGenerators() {
  argsRequired 1 $#
  msg2 "generators"

  local name i
  for i in ${1}/*; do
    source "$i"
    name="$(basename "$i")"
    name="${name/%.sh/}"
    type -t "generator_${name}" &> /dev/null
    (( $? != 0 )) && die "Invalid generator file '$i'"
    found2 "$name"
    GENERATORS+=("$name")
  done
}
