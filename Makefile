all: build

build:
	gcc intro.c -o intro

run: build
	./intro

clean:
	rm -f intro intro_args