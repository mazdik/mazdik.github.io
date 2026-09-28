#!/bin/bash

set -a
source <(cat .env | \
    sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g")
set +a

PGPASSWORD=$POSTGRES_DBPASS
DevzoneDb=$DEVZONE_PG_HOST
declare -A db_map
db_map[db_name1]="-n public -n schema_name1"
db_map[db_name2]="-n public -n schema_name2"

for DbName in "${!db_map[@]}"; do
    Schemas="${db_map[$DbName]}"
    echo "db: $DbName -> schemas: $Schemas"

    startTime=$(date +"%s%N")
    DumpFile=$DbName.dump

    docker exec -it dev-postgres //bin//bash -c "PGPASSWORD=$PGPASSWORD pg_dump -Fc -h $DevzoneDb -U $DbName $DbName $Schemas --no-owner --file=/export/$DumpFile"
    docker exec -it dev-postgres pg_restore -Fc -h localhost -U $DbName -d $DbName --clean --no-owner //export//$DumpFile
    rm $DumpFile

    elapsedTime=$((("$(date +"%s%N")"-"$startTime") / 1000000000))
    echo "$DumpFile time: $elapsedTime seconds"

done
