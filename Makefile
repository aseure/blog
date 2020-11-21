build: css html

html:
	hugo --minify

css:
	hugo gen chromastyles --style=tango                            > assets/syntax.css
	NODE_ENV=production npx tailwindcss build assets/tailwind.css -o assets/style.css

serve:
	NODE_ENV=development npx tailwindcss build assets/tailwind.css -o assets/style.css
	hugo serve

deploy: build
    rsync -e 'ssh -o \"StrictHostKeyChecking no\" -i ~/.ssh/digital_ocean' \
	      -avz                                                             \
		  --delete public/*                                                \
		  anthony@aseure.fr:/home/anthony/blog.aseure.fr/
