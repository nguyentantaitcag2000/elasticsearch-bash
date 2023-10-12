#!/bin/bash
curl --user $CURL_USER -XGET "http://localhost:9200/_cat/indices?v"
bash ~/bash/index/helper.sh