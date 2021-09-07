run:
	@TITLE="Kiru" ./build.sh

install:
	@cp build.sh /usr/bin/ksg
	@chmod 755 /usr/bin/ksg
