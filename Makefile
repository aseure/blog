all: convert build deploy

convert:
	./convert.sh

build:
	hugo

deploy:
	rsync -e 'ssh -i ~/.ssh/scaleway' -avz --delete public/* anthony@51.158.112.48:/home/anthony/web/aseure.fr/

.PHONY: convert build deploy
