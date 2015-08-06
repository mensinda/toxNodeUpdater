#!/bin/bash

__NODE_COUNTER=0
declare -A __TOX_NODES

addNode() {
  argsRequired 7 $#
  __TOX_NODES["${__NODE_COUNTER}_ipv4"]="$1"
  __TOX_NODES["${__NODE_COUNTER}_ipv6"]="$2"
  __TOX_NODES["${__NODE_COUNTER}_port"]="$3"
  __TOX_NODES["${__NODE_COUNTER}_pkey"]="$4"
  __TOX_NODES["${__NODE_COUNTER}_user"]="$5"
  __TOX_NODES["${__NODE_COUNTER}_loca"]="$6"
  __TOX_NODES["${__NODE_COUNTER}_stat"]="$7"
  (( __NODE_COUNTER++ ))
}

getNumNodes() {
  echo $__NODE_COUNTER
}

getNode() {
  argsRequired 2 $#
  (( $1 >= __NODE_COUNTER )) && die "Index to high ($1)"
  case $2 in
    IPv4)       echo "${__TOX_NODES[${1}_ipv4]}";;
    IPv6)       echo "${__TOX_NODES[${1}_ipv6]}";;
    port)       echo "${__TOX_NODES[${1}_port]}";;
    key)        echo "${__TOX_NODES[${1}_pkey]}";;
    maintainer) echo "${__TOX_NODES[${1}_user]}";;
    location)   echo "${__TOX_NODES[${1}_loca]}";;
    status)     echo "${__TOX_NODES[${1}_stat]}";;
    *) die "Unknown property $2";;
  esac
}
