# docker-jenkins-slave

Jenkins Slave Dockerfile

## Attention

The image includes default example ssh key.  
So, if you run this image without custom key option and publish ssh port, all of people can login.

**It is very dangerous that exposed ssh port publishes globally.**

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

The ssh key to login jenkins-slave is in `./ssh-keys` directory.

And, linked jenkins container:

```bash
$ docker run -d --name myjenkins-sl mizunashi/jenkins-slave
$ docker run -d --name myjenkins --link myjenkins-sl:myjenkins-sl jenkins
```

Then, you must be also setup jenkins slave.

Using custom authorized_keys:

```bash
$ docker run -d --name myjenkins-sl \
  -e AUTHORIZED_KEYS_URL='https://your domain/your keys' \
  mizunashi/jenkins-slave
```

Or

```bash
$ docker run -d --name myjenkins-sl \
  -e AUTHORIZED_KEY_STRING='your key string' \
  mizunashi/jenkins-slave
```

## Require Environments

Value type:
 * CONST - Contant value.  Dockerfile provided.  You can use entrypoint, building run or etc.
 * SETTABLE - Settable value.  You can set the value when `docker run` with `-e` or `--env` option.

| Name                  | Type     | Description |
|-----------------------|----------|-------------|
| JENKINS_WORKUSER      | CONST    | Setted `jenkins`. This is work username for SSH login. |
| JENKINS_WORKSPACE     | CONST    | Setted `/var/jenkins_ws`. This is work user's home dir. |
| SETUP_DIR             | CONST    | Setted `/var/cache/jenkins`. This is to lie setup files. |
| AUTHORIZED_KEY_STRING | SETTABLE | If this value was setted, `docker` make jenkins's authorized_keys this value. |
| AUTHORIZED_KEYS_URL   | SETTABLE | If `AUTHORIZED_KEY_STRING` was not setted and this value was setted, `docker` download and make jenkins's authorized_keys this value. |

If either `AUTHORIZED_KEY_STRING` or `AUTHORIZED_KEYS_URL` was not setted, `docker` use example key.

*It is very dangerous!!*  So, you must set either one.
