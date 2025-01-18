DEST=/usr/local/bin/sind

.PHONY: install
install: $(DEST)

$(DEST):
	cp sind $(DEST)
