JENKINSSL_APP_NAME='myjenkinssl-app'
JENKINSSL_DATA_NAME='myjenkinssl-data'

all: build

build:
	@docker build --tag=${USER}/jenkins-slave .

quickstart:
	@echo "Create SSH keys..."
	@mkdir -p ssh-keys
	@[ -f ssh-keys/id_rsa ] \
		|| ssh-keygen -t rsa -f ssh-keys/id_rsa -C '' -N ''
	@echo "Starting jenkins slave container..."
	@docker run --name=${JENKINSSL_APP_NAME} -d \
		--env="AUTHORIZED_KEY_STRING=$(head -1 ssh-keys/id_rsa.pub)" \
		--publish=30022:22 \
		mizunashi/jenkins-slave
	@docker run --name=${JENKINSSL_DATA_NAME} -d \
		--volumes-from=${JENKINSSL_APP_NAME} \
		busybox
	@echo "Type 'make logs' for the logs"

stop:
	@echo "Stopping jenkins slave app..."
	@docker stop ${JENKINSSL_APP_NAME} >/dev/null
	@echo "Stopping jenkins slave data..."
	@docker stop ${JENKINSSL_DATA_NAME} >/dev/null

purge: stop
	@echo "Removing stopped containers..."
	@docker rm -v ${JENKINSSL_APP_NAME} >/dev/null
	@docker rm -v ${JENKINSSL_DATA_NAME} >/dev/null

logs:
	@docker logs -f ${JENKINSSL_APP_NAME}

