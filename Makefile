all: clean convert build

clean:
	git clean -xfd

convert:
	./convert.sh

build:
	hugo

deploy:
	rsync -e 'ssh -o "StrictHostKeyChecking no" -i travis_aseure_blog' -avz --delete public/* anthony@aseure.fr:/home/anthony/blog.aseure.fr/

.PHONY: convert build deploy
