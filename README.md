# docker-jenkins-slave
Jenkins Slave Dockerfile

## Attention

The image includes default example ssh key.  
So, if you run this image without custom key option and publish ssh port, all of people can login.

It is very dangerous that exposed ssh port publishes globally.

## Installion

Pulling:

```bash
$ docker pull mizunashi/jenkins-slave
```

Building:

```bash
$ git clone https://github.com/mizunashi-mana/docker-jenkins-slave
$ cd docker-jenkins-slave
$ make build
```

## Usage

quickstart:

```bash
$ make quickstart
```

And, linked jenkins container:

```bash
$ docker run -d --name myjenkins-sl mizunashi/jenkins-slave
$ docker run -d --name myjenkins --link myjenkins-sl:myjenkins-sl jenkins
```

Then, you must be also setup jenkins slave.

Using custom authorized_keys:

```bash
$ docker run -d --name myjenkins-sl -e AUTHORIZED_KEYS_URL='https://your domain/your keys' mizunashi/jenkins-slave
```

Or

```bash
$ docker run -d --name myjenkins-sl -e AUTHORIZED_KEY_STRING='your key string' mizunashi/jenkins-slave
```
