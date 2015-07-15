all: build

build:
	@docker build --tag=${USER}/jenkins-slave .
