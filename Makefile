certs:
	@bash gen-certs.sh

.PHONY: clean
clean: stop
	@bash -c "test -d certs && rm -r certs || :"
	@bash -c "rm -r data* || :"
	@bash -c "rm -f *tgz; test -d foo && rm -r foo || :"

.PHONY: start
start: certs
	docker compose up -d

.PHONY: restart
restart: stop start

.PHONY: run
run: start logs

.PHONY: logs
logs:
	docker compose logs -f

.PHONY: stop
stop:
	docker compose down
