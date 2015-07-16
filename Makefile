JENKINSSL_APP_NAME='myjenkinssl-app'
JENKINSSL_DATA_NAME='myjenkinssl-data'
SSH_KEYS_PATH="${PWD}/ssh-keys"

all: build

build:
	@docker build --tag=${USER}/jenkins-slave .

quickstart:
	@echo "Create SSH keys..."
	@mkdir -p ${SSH_KEYS_PATH}
	@[ -f ${SSH_KEYS_PATH}/id_rsa ] \
		|| ssh-keygen -t rsa -f ${SSH_KEYS_PATH}/id_rsa -C '' -N ''
	@echo "Starting jenkins slave container..."
	@docker run --name=${JENKINSSL_APP_NAME} -d \
		--env="AUTHORIZED_KEY_STRING=`head -1 ${SSH_KEYS_PATH}/id_rsa.pub`" \
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

test:
	@ssh jenkins@`docker inspect -f '{{.NetworkSettings.IPAddress}}' ${JENKINSSL_APP_NAME}` \
		-i ${SSH_KEYS_PATH}/id_rsa
