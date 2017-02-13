all: deploy

deploy:
	rm -rf public db.json
	hexo generate
	hexo deploy

