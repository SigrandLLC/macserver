#!/bin/bash
# Generates single MAC address.
# MAC-addresses are generated continuosly.
# Written by Dmitry A. Fedorov <dm.fedorov@gmail.com>, Sigrand LLC <http://sigrand.ru>, Novosibirsk
# Derived from kdbmacgen.sh by Kazantsev A.V., Sigrand, Novosibirsk, kazantsev@sigrand.ru

showerr()
{
    echo "$@"
    exit 1
}

[ -z $1 ] && showerr "Usage: $0 maccounter_file"


MACCOUNTER=$1


# check files permissions
[ -r $MACCOUNTER -a -w $MACCOUNTER ] || showerr "Unable to read or write mac counter file $MACCOUNTER"

# read current MAC counter
curmac=$(cat $MACCOUNTER)
curmachex=$(printf "%.12x" $curmac)

# update mac counter
curmac=$(($curmac + 1))
echo $curmac > $MACCOUNTER

# /bin/bash required due to line below:
mac_formatted=${curmachex:0:2}:${curmachex:2:2}:${curmachex:4:2}:${curmachex:6:2}:${curmachex:8:2}:${curmachex:10:2}

echo $mac_formatted
