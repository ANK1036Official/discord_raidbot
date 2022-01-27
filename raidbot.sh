#!/bin/bash
lgreen='\033[0;32m'
lred='\033[0;31m'
nc='\033[0m'

[ $# -eq 0 ] && { echo "Usage: $0 tokens.txt (PROXY_IP)"; echo "A proxy is not necissary, and must be http based. Example: http://202.54.1.1:3128/"; exit 1; }
[ $# -eq 2 ] && { export http_proxy=$2 export ; https_proxy=${http_proxy}; }
while :
do
    clear

    echo -e ${nc}"Welcome " ${lred}"${USER}" ${nc}" Discord-Spammer"
    echo ""
    echo -e ${nc}"1) Spam Server"
    echo ""
    echo -e ${nc}"2) Spam Friend Request"
    echo ""
    echo -e ${nc}"3) Spam DM"
    echo ""
    echo -e ${nc}"4) Join Server"
    echo ""
    echo -e ${nc}"5) Leave Server"
    echo ""
    echo -e ${nc}"0) exit"

    read -r menu1
    if [[ ${menu1} == "1" ]]; then
        echo -e ${lgreen}"Selected Spam Server..."
        echo "Enter channel ID"
        read -r -p '>> ' channelid
        echo "Enter message"
        read -r -p '>> ' message_data
            while : 
            do
                for token in $(cat $1); do
                printf "Token: ${token} , result: "
                RESULT=$(curl -s -H "Content-Type: application/json" -H "authorization: ${token}" -X POST -d '{"content":"'"${message_data}"'","nonce":"","tts":false}' "https://discordapp.com/api/v7/channels/${channelid}/messages")
                if [[ $(echo ${RESULT} | head -1) =~ "<html>" ]]; then
                    printf "fail\n"
                else
                    printf "success\n"
                fi
            done
        done
    fi
    if [[ ${menu1} == "2" ]]; then
        echo -e ${lgreen}"Selected Spam Friend Request"
        echo "Enter user ID"
        read -r -p '>> ' userid
        for token in $(cat $1); do
            printf "Token: ${token} , result: "
            RESULT=$(curl -s -H "Content-Type: application/json" -H "authorization: ${token}" -H 'Content-Length: 0' -X PUT "https://discordapp.com/api/v7/users/@me/relationships/${userid}")
            if [[ $(echo ${RESULT} | head -1) =~ "<html>" ]]; then
                printf "fail\n"
            else
                printf "success\n"
            fi
        done
    fi
    if [[ ${menu1} == "3" ]]; then
        echo -e ${lgreen}"Selected Spam DM"
        echo "Removed... Sorry."
    fi
    if [[ ${menu1} == "4" ]]; then
        echo -e ${lgreen}"Selected Join Server"
        echo "Enter invitelink regex (last part at the end of the invite link)"
        read -r -p '>> ' invitelink
        for token in $(cat $1); do
            printf "Token: ${token} , result: "
            RESULT=$(curl -s -H "authorization: ${token}" -H 'Content-Length: 0' -X POST "https://discordapp.com/api/v7/invite/${invitelink}")
            if [[ $(echo ${RESULT} | head -1) =~ "<html>" ]]; then
                printf "fail\n"
            else
                printf "success\n"
            fi
        done
    fi
    if [[ ${menu1} == "5" ]]; then
        echo -e ${lgreen}"Selected Leave server"
        echo "Enter guild ID"
        read -r -p '>> ' guildid
        for token in $(cat $1); do
            printf "Token: ${token} , result: "
            RESULT=$(curl -s -H "authorization: ${token}" -H 'Content-Length: 0' -X DELETE "https://discordapp.com/api/v7/users/@me/guilds/${guildid}")
            if [[ $(echo ${RESULT} | head -1) =~ "<html>" ]]; then
                printf "fail\n"
            else
                printf "success\n"
            fi
        done
    fi
    if [[ ${menu1} == "0" ]]; then
        echo "Exiting..."
        exit 1
    fi
done
