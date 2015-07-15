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

```bash
$ docker run -d --name myjenkins-sl mizunashi/jenkins-slave
```

And, linked jenkins container:

```bash
$ docker run -d --name myjenkins-sl mizunashi/jenkins-slave
$ docker run -d --name myjenkins --link myjenkins-sl:myjenkins-sl jenkins
```

Then, you must be also setup jenkins slave.
