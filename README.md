# slack message dump

# curl で必要なもの

## 1つめのAPI

rest spec
```
GET https://slack.com/api/conversations.history
Authorization: Bearer xoxb-your-token
{
  channel: "CONVERSATION_ID_HERE"
}
```

curlのサンプル1
```
curl "https://slack.com/api/conversations.history?channel=xxxxx" \
-H 'Authorization: Bearer yyyyy' 
```

format
```
grep thread_ts 1.out.json | awk -F '"' '{ print "2nd.sh " $4  " > " $4".out" }'
```

## 2つめのAPI
rest spec
```
url: GET https://slack.com/api/conversations.replies
token:yyyyy
channel:xxxxx
ts: 1692977241.572959
```

curlのサンプル2
```
curl -X POST "https://slack.com/api/conversations.replies?channel=xxxxx&ts={$1}" \
-H 'Authorization: Bearer yyyyy' \
-H 'application/x-www-form-urlencoded'　> {$1}.out
```


# test_slack_msg_dump.sh
run
```
sh ./test_slack_msg_dump.sh

```

# (補足) jq コマンドの例

csv出力　※各項目の指定が必要
```
$ cat 1693036015.886299.json | jq -c '.messages[] | [.client_msg_id,.type] | @csv'
$ cat 1693036015.886299.json | jq -r '.messages[] | [.client_msg_id,.type] | @csv'

# "" を削除する
$ cat 1693036015.886299.json | jq -r '.messages[] | [.client_msg_id,.type] | @csv' | sed 's/"//g'
54FC1C6B-9801-408A-A85D-DFD502920D9F,message
6FF85FBD-502F-4DAB-AD06-B7B762D42088,message
3C83A6B4-DA71-43E7-8511-CF2B37DA6234,message
```

messages(配列)の client_msg_id と type を csv で出力
※ messagesは配列である必要がある
※ -c は改行を削除するオプション
