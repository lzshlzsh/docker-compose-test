.PHONY: sr_destory sr_init sleep sr

sr_destory:
	docker compose stop sr sr_be{1..3}
	docker compose rm -f sr sr_be{1..3}
	docker volume rm -f docker-compose-test_sr_fe1 docker-compose-test_sr_be{1..3}
	docker compose up -d sr sr_be{1..3}

sr_init:
	echo 'ALTER SYSTEM ADD BACKEND "sr_be1:9050"; ALTER SYSTEM ADD BACKEND "sr_be2:9050"; ALTER SYSTEM ADD BACKEND "sr_be3:9050";' | mysql -h127.0.0.1 -uroot -P9030
	echo "SET PASSWORD FOR 'root' = PASSWORD('123456');" | mysql -h127.0.0.1 -uroot -P9030
	echo "SHOW PROC '/frontends'; SHOW PROC '/backends'" | mysql -h127.0.0.1 -uroot -P9030 --binary-as-hex -p123456

sleep:
	sleep 15

sr: sr_destory sleep sr_init
