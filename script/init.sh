#!/bin/bash

# clean up in case a container is commited and restarted
rm -f /usr/src/app/tmp/pids/server.pid /usr/src/app/log/*.log

# run script before rails server is started
/usr/src/app/script/pre_server.rb

# apply database changes specific to this container
bundle exec rake db:migrate

# start rails server
/usr/src/app/bin/rails server -b 0.0.0.0 &
# ... and wait until server is up
bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:3000/api/active)" != "200" ]]; do sleep 5; done'

# run script after rails server is started
/usr/src/app/script/post_server.rb

# keep running
sleep infinity
