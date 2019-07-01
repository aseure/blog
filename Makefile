all: convert build deploy

convert:
	./convert.sh

build:
	hugo

deploy:
	rsync -e 'ssh -i ~/.ssh/scaleway' -avz --delete public root@212.47.249.142:/var/www/

.PHONY: convert build deploy
