#!/usr/bin/env bash
set -e -u -x

echo "127.0.0.1 $(cat ~/orig_hostname)" >> /etc/hosts

(/usr/sbin/sshd -D &)

chmod u+s /bin/ping

su - gpadmin <<EOF

echo "host all all 0.0.0.0/0 md5" >> /gpdata/master/gpseg-1/pg_hba.conf
echo "host all all ::1/128 trust" >> /gpdata/master/gpseg-1/pg_hba.conf
echo "local all all trust" >> /gpdata/master/gpseg-1/pg_hba.conf

export MASTER_DATA_DIRECTORY=/gpdata/master/gpseg-1

source /usr/local/greenplum-db/greenplum_path.sh

gpstart -a

psql -d template1 -c "alter user gpadmin password 'gpadmin'"
EOF

tail -f $0
