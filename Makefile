test:
	@cat *.json | docker run -i --rm -v $(PWD):/scripts fluent/fluent-bit /fluent-bit/bin/fluent-bit -c /scripts/fluent-bit.conf
