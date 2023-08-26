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

