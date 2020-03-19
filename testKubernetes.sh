#!/usr/bin/env bats
source /vagrant/params.sh

@test "Test Suite for InfluxDB" {
  # 1. Create file with records
  /vagrant/create_data.sh > $IMPORT_PATH
  # 2. Insert records
  influx -import -path=$IMPORT_PATH
  # 3. Test records count
  N_ROWS=$(influx -database=$DATABASE -execute "select * from temperature"|tail -n +4|wc -l)
  [ "$N_ROWS" -eq $N ]
  # 4. Call API to insert 1 new record
  curl -i -XPOST "http://localhost:8086/write?db=$DATABASE&precision=s" --data-binary 'temperature,mytag=1 myfield=90 1463683075'
  let M=$N+1
  N_ROWS=$(influx -database=$DATABASE -execute "select * from temperature"|tail -n +4|wc -l)
  [ "$N_ROWS" -eq $M ]
}

@test "Check Grafana" {
  TITLE=$(wget http://localhost:3000 -O - 2>/dev/null|grep title|sed -r "s/<title>//g"|sed -r "s/<\/title>//g"|awk '{print $1}')
  [ "$TITLE" = "Grafana" ]
}
