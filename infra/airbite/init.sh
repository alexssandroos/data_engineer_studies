#/bin/bash
# https://github.com/airbytehq/airbyte
git clone --depth 1 https://github.com/airbytehq/airbyte.git
cp .env airbyte/.env
cp .env.dev airbyte/.env.dev
cd airbyte
./run-ab-platform.sh 
