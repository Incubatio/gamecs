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
	@python -m SimpleHTTPServer 2>/dev/null

deploy: 
	git push -f origin HEAD:gh-pages
