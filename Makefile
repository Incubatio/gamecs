build: clean
	coffee --compile --output build src

watch:
	coffee --compile --watch --output build src

install:
	r.js -o baseUrl=build/lib/ name=gamecs out=assets/js/gamecs.min.js

clean: 
	rm -rf build

doc: 
	rm -rf docs/api
	ringo-doc -q --file-urls --source build/lib/ --directory docs/api/ --name 'GameCs API'


server: 
	@python -um SimpleHTTPServer 2>&1| grep -v KeyboardInterrupt

deploy: 
	git push -f origin HEAD:gh-pages
