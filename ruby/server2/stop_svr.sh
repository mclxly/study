#!/bin/bash

root_doc=/var/www/html/colin/github/study/cellar/server

cat ${root_doc}/tmp/pids/unicorn.pid | xargs kill -QUIT
rm ${root_doc}/tmp/sockets/unicorn.sock
rm ${root_doc}/tmp/pids/unicorn.pid
