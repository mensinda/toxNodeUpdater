# TOX Node List Updater

This is a bash scipt for generating a [TOX](https://github.com/irungentoo/toxcore/) bootstrap node list. Currently supported output formats
are:

 - JSON

The default node list source is https://wiki.tox.chat/users/nodes, the default parser is html1 and the default file generator is JSON.

## Usage

Main Usage: `./updater.sh [OPTIONS] <output file>`

Options:

|        option        |                  Description                  |
|----------------------|-----------------------------------------------|
| -h, --help           | Show a help message and exit                  |
| -g, --generator  [g] | Use the output file generator [g]             |
| -p, --parser     [p] | Use the file parser [p] to generate the list  |
| -s, --source     [s] | Use [s] as the source                         |


NOTE: this program uses `wget` to download files.

## Adding a parser

Create a file `parsers/<parserName>.sh` containing a function `parser_<parserName>`.

This function takes one argument: a path to the temporary source file.

### Functions

#### addNode

Parameters:

| Num | Description |
|-----|-------------|
|  1  | IPv4 address|
|  2  | IPv6 address|
|  3  | Port        |
|  4  | Public key  |
|  5  | Maintainer  |
|  6  | Location    |
|  7  | Status      |

## Adding a generator

Create a file `generators/<generatorName>.sh` containing a function `generator_<generatorName>`.

This function takes *no* argument. The content should be written to stdout.

### Functions

#### getNumNodes

Parameters: NONE

Prints the number of nodes added with `addNode` to stdout

#### getNode

Parameters:

| Num | Description  |
|-----|--------------|
|  1  | Node index   |
|  2  | Property name|

Possible property names:

 - IPv4
 - IPv6
 - port
 - key
 - maintainer
 - location
 - status


The property will be printed to stdout
