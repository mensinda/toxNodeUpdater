#!/bin/bash

shopt -s extglob

ROOTDIR="$(dirname "$0")"
CONFIG_FILE="$ROOTDIR/config.conf"

# Including utils and src
for i in $ROOTDIR/utils/*.sh $ROOTDIR/src/*.sh; do
  source "$i"
done



addToConfig "parserDir"    "$(readlink -f "$ROOTDIR/parsers")"    "Path to the parsers directory"
addToConfig "generatorDir" "$(readlink -f "$ROOTDIR/generators")" "Path to the generators directory"
addToConfig "source"       "https://wiki.tox.chat/users/nodes"    "Default Path / Link to the node list"
addToConfig "defParser"    "html1"                                "Default parser for the node list"
addToConfig "defGenerator" "json"                                 "Default generator"
addToConfig "tempFile"     "$(readlink -f "$ROOTDIR/source")"     "Where the downloaded files will be stored"



NAME="TOX Node List Updater (TNLU)"

msg1 ""
msg1 "        $NAME"
msg1 "        $(printNumChar ${#NAME} "=")"
msg1 ""
msg1 ""
msg1 "Loading..."
loadConfig      "${CONFIG_FILE}"
loadParsers     "${CONFIG[parserDir]}"
loadGenerators  "${CONFIG[generatorDir]}"

parseArgs "$@"

msg1 "Parsing source file..."

if [[ "$SOURCE" == "http"* ]]; then
  msg2 "Downloading File '$SOURCE'"
  downloadFile "$SOURCE" "${CONFIG[tempFile]}" die
else
  msg2 "Creating temporary copy of file '$SOURCE'"
  cp "$SOURCE" "${CONFIG[tempFile]}"
  (( $? != 0 )) && die "Failed to copy file '$SOURCE'"
fi

eval "parser_${PARSER_NAME} \"${CONFIG[tempFile]}\""

msg1 "Generating '$OUTPUT'"
eval "generator_${GENERATOR_NAME} > \"$OUTPUT\""

msg1 "Cleaning up"
msg2 "Removing temporary source file"
[ -e "${CONFIG[tempFile]}" ] && rm -rf "${CONFIG[tempFile]}"
msg2 "Generating config file '${CONFIG_FILE}'"
generateConfigFile "${CONFIG_FILE}"
