all: clean convert build

clean:
	git clean -xfd

convert:
	./convert.sh

build:
	hugo

.PHONY: convert build deploy
