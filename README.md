# docker-jenkins-slave
Jenkins Slave Dockerfile

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
$ docker run -d --name myjenkins-sl mizunashi/jenkins-slave
```

And, linked jenkins container:

```bash
$ docker run -d --name myjenkins-sl mizunashi/jenkins-slave
$ docker run -d --name myjenkins --link myjenkins-sl:myjenkins-sl jenkins
```

Then, you must be also setup jenkins slave.

**Attension: Quickstart uses public authorized id keys!! So, it is very dangerous that you publish the quickstart port globally!**

Using custom authorized_keys:

```bash
$ docker run -d --name myjenkins-sl -e AUTHORIZED_KEYS_URL='https://your domain/your keys' mizunashi/jenkins-slave
```

Or

```bash
$ docker run -d --name myjenkins-sl -e AUTHORIZED_KEY_STRING='your key string' mizunashi/jenkins-slave
```
