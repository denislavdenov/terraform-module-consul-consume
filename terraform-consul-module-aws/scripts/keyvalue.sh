#!/usr/bin/env bash
# Code used to insert a key/value into the KV store of Consul
export DEBIAN_FRONTEND=noninteractive
set -x

curl \
    --request PUT \
    --data '
<!DOCTYPE html>
<html>
<head>
<title>Welcome to ip-172-31-17-11!</title>
<style>
body {
    width: 35em;
    margin: 0 auto;
    font-family: Tahoma, Verdana, Arial, sans-serif;
}
</style>
</head>
<body>
<h1>Welcome to ip-172-31-17-11!</h1>
<p><em>Thank you for using ip-172-31-17-11.</em></p>
</body>
</html>'  \
    http://127.0.0.1:8500/v1/kv/ip-172-31-17-11/site

curl \
    --request PUT \
    --data '
<!DOCTYPE html>
<html>
<head>
<title>Welcome to ip-172-31-33-11!</title>
<style>
body {
    width: 35em;
    margin: 0 auto;
    font-family: Tahoma, Verdana, Arial, sans-serif;
}
</style>
</head>
<body>
<h1>Welcome to ip-172-31-33-11!</h1>
<p><em>Thank you for using ip-172-31-33-11.</em></p>
</body>
</html>'  \
    http://127.0.0.1:8500/v1/kv/ip-172-31-33-11/site
