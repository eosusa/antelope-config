#!/bin/bash
NODEOSBINDIR="/opt/wax-5.0.0"
DATADIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

$DATADIR/stop.sh
echo -e "Starting Nodeos \n";

ulimit -c unlimited
ulimit -n 65535
ulimit -s 64000

$NODEOSBINDIR/nodeos --data-dir $DATADIR --config-dir $DATADIR "$@" > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/nodeos.pid

