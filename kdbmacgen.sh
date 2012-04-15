#!/bin/sh
# Generates kdb mac file: writes to $KDB_MAC_FILE lines like "sys_iface_eth0_mac=00:33:...".
# MAC-addresses are generated continuosly.
# Written by Kazantsev A.V., Sigrand, Novosibirsk, kazantsev@sigrand.ru

IFACE_TYPE1_NAME="eth"
IFACE_TYPE1_NUM="6"
IFACE_TYPE2_NAME="dsl"
IFACE_TYPE2_NUM="32"
IFACE_TYPE3_NAME="E1_"
IFACE_TYPE3_NUM="32"

MACCOUNTER=$1
KDB_MAC_FILE=$2

showerr()
{
    echo $1
    exit 1
}

[ -z $2 ] && echo "Usage: $0 maccounter_file kdb_mac_file" && exit 1

# check files permissions
[ -r $MACCOUNTER -a -w $MACCOUNTER ] || showerr "Unable to read or write mac counter file $MACCOUNTER"
[ -w `dirname $KDB_MAC_FILE` ] || showerr "Unable to write kdb mac file $KDB_MAC_FILE"

rm -f $KDB_MAC_FILE

# read current MAC counter
curmac=$(cat $MACCOUNTER)

# generate KDB records
for i in 1 2 3; do
    unset iface_name iface_num
    eval 'iface_name=$'IFACE_TYPE${i}_NAME
    eval 'iface_num=$'IFACE_TYPE${i}_NUM
    iface_idx=0
    while [ $iface_idx -lt $iface_num ]; do
        curmachex=$(printf "%.12x" $curmac)
        mac_formatted=${curmachex:0:2}:${curmachex:2:2}:${curmachex:4:2}:${curmachex:6:2}:${curmachex:8:2}:${curmachex:10:2}
        echo sys_iface_${iface_name}${iface_idx}_mac=$mac_formatted >>$KDB_MAC_FILE
        curmac=$(($curmac + 1))
        iface_idx=$(($iface_idx + 1))
    done
done

# update mac counter
echo $curmac > $MACCOUNTER
