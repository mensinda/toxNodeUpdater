#!/bin/bash

PARSER_NAME=""
GENERATOR_NAME=""
SOURCE=""
OUTPUT=""

showHelp() {
  argsRequired 0 $#
  echo ""
  msg1 "Usage: $0 [OPTIONS] <output file>"
  echo ""
  msg1 "OPTIONS:"
  msg2 "-h, --help           -- Show this help message and exit"
  msg2 "-g, --generator  <g> -- Use the output file generator <g>"
  msg2 "-p, --parser     <p> -- Use the file parser <p> to generate the list"
  msg2 "-s, --source     <s> -- Use <s> as the source"
  echo ""
  msg1 "Generators:"
  local i
  for i in "${GENERATORS[@]}"; do
    msg2 "$i"
  done
  echo ""
  msg1 "Parsers:"
  for i in "${PARSERS[@]}"; do
    msg2 "$i"
  done
  echo ""
}

parseArgs() {
  local ARGS=( "$@" ) i
  for (( i=0; i < ${#ARGS[@]}; i++ )); do
    case "${ARGS[$i]}" in
      -g|--generator)
        (( i++ ))
        for j in "${GENERATORS[@]}"; do
          if [[ "$j" == "${ARGS[$i]}" ]]; then
            GENERATOR_NAME="$j"
            j=-1
            break
          fi
        done
        (( j == -1 )) && continue
        showHelp
        die "Unknown generator '${ARGS[$i]}'";;
      -p|--parser)
        (( i++ ))
        for j in "${PARSERS[@]}"; do
          if [[ "$j" == "${ARGS[$i]}" ]]; then
            PARSER_NAME="$j"
            j=-1
            break
          fi
        done
        (( j == -1 )) && continue
        showHelp
        die "Unknown parser '${ARGS[$i]}'";;
      -s|--source)
        (( i++ ))
        SOURCE="${ARGS[$i]}" ;;
      -h|--help)
        showHelp
        exit 0 ;;
      -*|--*)
        showHelp
        exit 0 ;;
      *) OUTPUT="${ARGS[$i]}";;
    esac
  done

  [ -z "$GENERATOR_NAME" ] && GENERATOR_NAME="${CONFIG[defGenerator]}"
  [ -z "$PARSER_NAME" ]    && PARSER_NAME="${CONFIG[defParser]}"
  [ -z "$SOURCE" ]         && SOURCE="${CONFIG[source]}"

  if [ -z "$OUTPUT" ]; then
    showHelp
    error "No output file provided"
    exit 2
  fi

  msg1 "Info"
  msg2 "Using generator \x1b[35m$GENERATOR_NAME"
  msg2 "Using parser    \x1b[35m$PARSER_NAME"
  msg2 "Using source    \x1b[33m$SOURCE"
  msg2 "Output file     \x1b[36m$OUTPUT"
}
