all: clean convert build

clean:
	git clean -xfd

convert:
	./convert.sh

build:
	hugo gen chromastyles --style=borland > assets/scss/syntax.css
	hugo

.PHONY: convert build deploy
