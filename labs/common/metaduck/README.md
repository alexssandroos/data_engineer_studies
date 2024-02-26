docker run -d -p 3002:3000 \
  -e "MB_DB_TYPE=postgres" \
  -e "MB_DB_DBNAME=metabase" \     
  -e "MB_DB_PORT=5432" \
  -e "MB_DB_USER=metabase" \
  -e "MB_DB_PASS=metabase" \
  -e "MB_DB_HOST=host.docker.internal" \
   --name metabase metabase/metabase