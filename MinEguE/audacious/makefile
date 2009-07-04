SKIN_NAME = minEguE-xmms-v2
SKIN_FILES = README.txt COPYING Makefile \
	main.bmp balance.bmp cbuttons.bmp eq_ex.bmp eqmain.bmp \
	monoster.bmp nums_ex.bmp playpaus.bmp pledit.bmp text.bmp \
	posbar.bmp shufrep.bmp titlebar.bmp volume.bmp \
	pledit.txt viscolor.txt
CLEAN_FILES = *~ $(SKIN_NAME).tgz


.PHONY: all
all: skin

.PHONY: skin
skin: $(SKIN_FILES)
	GZIP=--best tar czf $(SKIN_NAME).tgz $(SKIN_FILES)

.PHONY: clean
clean:
	rm -rf $(CLEAN_FILES)