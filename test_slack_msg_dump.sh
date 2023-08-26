#!/bin/bash

TOKEN=$1
CHANNEL_ID=$2

# 引数のチェック
if [ $# != 2 ]; then
  echo "引数に slackapi の token と channel_id を指定してください"
  echo " 例) $ ./test_slack_msg_dump.sh <token> <channel_id>"
  exit 1
fi

# conversations.historyを使って、下記時間以降の会話を取得する　
# 2023年7月1日00:00:00JST (= 1688137200.000000 in unix time)
# 2023年8月26日00:00:00JST (= 1692975600.000000 in unix time)

curl -X POST "https://slack.com/api/conversations.history?channel=$CHANNEL_ID&oldest=1692975600.000000" \
-H "Authorization: Bearer $TOKEN" \
-H "Content-Type: application/json; charset=utf-8" | jq . > history.json

# conversations.historyの結果から、thread_tsを抽出する
grep thread_ts history.json | awk -F '"' '{ print $4 }' > thread_ts.txt

# レスポンスを格納するディレクトリを作成する
MYDIR_NAME=response_$(date '+%Y%m%d_%H%M%S')
mkdir -p $MYDIR_NAME

# conversations.repliesをコールし、thread_ts.txtに書かれている各thread_tsに紐づいたレスポンスを取得する
while read LINE
do
  curl -X POST "https://slack.com/api/conversations.replies?channel=$CHANNEL_ID&ts=$LINE" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'application/x-www-form-urlencoded' | jq . > ./$MYDIR_NAME/$LINE.json

# slack apiのrate limit が 50req/1min なので、1分に50回以上リクエストを送るとエラーになる
sleep 2

done < thread_ts.txt
