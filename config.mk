SRC_ICON_FILE = $(SOURCE_DIR)/icon.png

VERSION = 1.4.0
MANUAL_URL  = https://ftpmirror.gnu.org/gnu/guix/guix-$(VERSION).tar.gz
MANUAL_SRC = tmp/guix-$(VERSION)
MANUAL_SRC_MAKEFILE = $(MANUAL_SRC)/Makefile
MANUAL_FILE = $(MANUAL_SRC)/doc/guix.html

$(MANUAL_SRC): tmp
	curl -L -o $@.tar.gz $(MANUAL_URL)
	tar -x -z -f $@.tar.gz -C tmp

$(MANUAL_SRC_MAKEFILE): $(MANUAL_SRC)
	cd $(MANUAL_SRC) && ./configure

$(MANUAL_FILE): $(MANUAL_SRC_MAKEFILE)
	cd $(MANUAL_SRC) && make html

$(DOCUMENTS_DIR): $(RESOURCES_DIR) $(MANUAL_FILE)
	mkdir -p $@
	cp -r $(MANUAL_FILE)/* $@

$(INDEX_FILE): $(SOURCE_DIR)/src/index-pages.py $(SCRIPTS_DIR)/gnu/index-terms-colon.py $(DOCUMENTS_DIR)
	rm -f $@
	$(SOURCE_DIR)/src/index-pages.py $@ $(DOCUMENTS_DIR)/*.html
	$(SCRIPTS_DIR)/gnu/index-terms-colon.py "Entry" $@ $(DOCUMENTS_DIR)/Concept-Index.html
	$(SCRIPTS_DIR)/gnu/index-terms-colon.py "Variable" $@ $(DOCUMENTS_DIR)/Programming-Index.html
