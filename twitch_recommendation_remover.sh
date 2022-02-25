#!/bin/bash

enable_auto_updates=true #Set to 'false' to disable auto updates

USAGE='Usage: '"$0"' TYPE "NAME" Authorization_TOKEN Client-Id_TOKEN'"\n\n"'TYPE is either "channel" or "category".'"\n"'NAME is the name of the channel or the category.'"\n\n"'The "Authorization" and "Client-Id" tokens can be obtained when you open the Developer tools in your browser, then look at the Network requests, and search for the ones named "gql" to look at their Request Headers. (you obviously need to be logged in)'"\n\n"'Example:'"\n""$0"' category "Pools, Hot Tubs, and Beaches" a1b2c3d4e5f6g7h8i9j10k11l12m13 m13l12k11j10i9h8g7f6e5d4c3b2a1'

auto_update () {
    if wget -V > /dev/null 2>&1; then
        if ! file_network=$(wget -qO- "$1"); then
            return 1
        fi
    elif curl -V > /dev/null 2>&1; then
        if ! file_network=$(curl -fsSL "$1"); then
            return 1
        fi
    else
        # wget and curl not found, can't check for update
        return 2
    fi
    hash_local=$(md5sum "$2" | awk '{ print $1 }')
    hash_network=$(echo -E "$file_network" | md5sum | awk '{ print $1 }')
    if [[ "$hash_local" != "$hash_network" ]]; then
        tmpfile=$(mktemp "${2##*/}".XXXXXXXXXX --tmpdir)
        echo -E "$file_network" > "$tmpfile"
        chown --reference="$2" "$tmpfile"
        chmod --reference="$2" "$tmpfile"
        mv "$tmpfile" "$(realpath "$2")"
        exec "${@:2}"
    fi
}

parsing () {
    if [[ "$#" -ne 4 ]]; then
        echo -e "$USAGE"
        exit 1
    fi

    if [[ "${1^^}" != "CATEGORY" && "${1^^}" != "CHANNEL" ]]; then
        echo -e "$USAGE" >&2
        exit 2
    fi

    if ! curl -V > /dev/null 2>&1; then
        echo "'curl' command not found." >&2
        exit 3
    fi
}

regex_check () {
    #$1: OUTPUT [$2: REGEX]
    http_code='([0-9]+$)'

    shopt -s extglob
    shopt -s nocasematch
    if [[ $1 =~ $http_code && "${BASH_REMATCH[1]}" != "200" ]]; then
        echo 'Error: HTTP response code: '"${BASH_REMATCH[1]}"'.' >&2
        exit 4
    fi
    if [ ! -z "$2" ]; then
        if ! [[ $1 =~ $2 ]]; then
            echo 'Error: no match found for the query "'"$query"'".' >&2
            exit 5
        fi
    fi
    shopt -u nocasematch
    shopt -u extglob
}

get_category_id () {
    cmd_get='curl -s -X POST "https://gql.twitch.tv/gql" --data '"'"'[{"operationName":"DirectoryPage_Game","variables":{"name":"'"$query"'","sortTypeIsRecency":false,"limit":0},"extensions":{"persistedQuery":{"version":1,"sha256Hash":"d5c5df7ab9ae65c3ea0f225738c08a36a4a76e4c6c31db7f8c4b8dc064227f9e"}}}]'"'"' -H "Client-Id: '"$Client_Id"'" --write-out "\nResponse code: %{http_code}"'
    data_get=$(bash -c "$cmd_get")

    #echo -e "GET Request:\n$cmd_get\n"
    echo -e "GET Response:\n$data_get\n"

    regex_check "$data_get" '("game":\{"id":")([0-9]+)(")'

    Target_Id="${BASH_REMATCH[2]}"
}

get_channel_id () {
    cmd_get='curl -s -X POST "https://gql.twitch.tv/gql" --data '"'"'[{"operationName":"ReportMenuItem","variables":{"channelLogin":"'"$query"'"},"extensions":{"persistedQuery":{"version":1,"sha256Hash":"8f3628981255345ca5e5453dfd844efffb01d6413a9931498836e6268692a30c"}}}]'"'"' -H "Client-Id: '"$Client_Id"'" --write-out "\nResponse code: %{http_code}"'
    data_get=$(bash -c "$cmd_get")

    #echo -e "GET Request:\n$cmd_get\n"
    echo -e "GET Response:\n$data_get\n"

    regex_check "$data_get" '("user":\{"id":")([0-9]+)(")'

    Target_Id="${BASH_REMATCH[2]}"
}

main () {
    type="${1^^}"
    query="$2"
    Authorization="$3"
    Client_Id="$4"

    Target_Id=""

    case "$type" in
        "CATEGORY" )
            get_category_id ;;
        "CHANNEL" )
            get_channel_id ;;
    esac

    cmd_post='curl -s -X POST https://gql.twitch.tv/gql --data '"'"'[{"operationName":"AddRecommendationFeedback","variables":{"input":{"category":"NOT_INTERESTED","itemID":"'"$Target_Id"'","itemType":"'"$type"'","sourceItemPage":"twitch_home","sourceItemRequestID":"0000-000-0000","sourceItemTrackingID":""}},"extensions":{"persistedQuery":{"version":1,"sha256Hash":"8aae43e5b7fe68adc70608e35a4c9ec859d2cfde8962347487114703845d7887"}}}]'"'"' -H "Client-Id: '"$Client_Id"'" -H "Authorization: OAuth '"$Authorization"'" --write-out "\nResponse code: %{http_code}"'
    data_post=$(bash -c "$cmd_post")

    #echo -e "POST Request:\n$cmd_post\n"
    echo -e "POST Response:\n$data_post\n"

    regex_check "$data_post"
}

if [ "$enable_auto_updates" = true ] ; then
    auto_update "https://raw.githubusercontent.com/Sad-theFaceless/twitch_recommendation_remover/main/twitch_recommendation_remover.sh" "$0" "$@"
fi
parsing "$@"
main "$@"
echo "Recommendation removed. Check the following page:"
echo "https://www.twitch.tv/settings/recommendations"

exit 0
