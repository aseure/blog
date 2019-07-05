all: convert build deploy

convert:
	./convert.sh

build:
	hugo

deploy:
	rsync -e 'ssh -i ~/.ssh/scaleway' -avz --delete public/* anthony@aseure.fr:/home/anthony/web/aseure.fr/

.PHONY: convert build deploy
