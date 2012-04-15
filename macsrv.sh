#!/bin/sh
# TCP server. Listen for incoming connections.
# Command GENERATE_MAC forces to generate kdb mac file by calling KDBMACGEN.
# Command DELETE_MAC forces to delete generated kdb mac file.
# Written by Kazantsev A.V., Sigrand, Novosibirsk, kazantsev@sigrand.ru

export KDBMACGEN="/home/macsrv/kdbmacgen.sh"
export MACCOUNTER="/home/macsrv/maccounter"
export KDB_MAC_FILE="/tftpboot/kdbmac"
export LOG="/home/macsrv/log"
PID="/home/macsrv/pid"
IP="192.168.2.1"
PORT="1030"

echo $$ >$PID

echo "" >>$LOG
echo `date` "Started" >>$LOG

while true; do
    trap "exit 0" SIGTERM SIGINT
    nc -l -s $IP -p $PORT -c '\
        echo `date` "Incoming connection" >>$LOG
        echo "Connected. Enter command";\
        while read inline; do\
            case $inline in\
                "GENERATE_MAC")\
                    echo "Generating kdb mac file";\
                    $KDBMACGEN $MACCOUNTER $KDB_MAC_FILE;\
                    if [ $? = 0 ]; then\
                        echo "SUCCESS: kdb mac file generated";\
                        echo `date` "SUCCESS generated kdb mac file" >>$LOG
                    else\
                        echo "FAIL: There are errors while generating kdb mac file";\
                        echo `date` "FAIL while generated kdb mac file" >>$LOG
                    fi;\
                    exit 0;\
                    ;;\
                "DELETE_MAC")\
                    echo "Deleting kdb mac file";\
                    rm $KDB_MAC_FILE;\
                    echo "kdb mac file deleted";\
                    echo `date` "Deleting kdb mac file" >>$LOG
                    exit 0;\
                    ;;\
                *)\
                    echo "Unknown command";\
                    exit 0;\
                    ;;\
            esac\
        done'
    echo "" >>$LOG
done
