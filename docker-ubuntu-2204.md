# Docker &  Docker-Compose
**Docker ve  Docker-Compose'un** Ubuntu 22.04 ortamında kurulumu adımlarına buradan ulaşabilirsiniz.


**1:** docker kurulumu

```shell
$ sudo apt update

$ sudo apt upgrade

$ sudo apt install curl lsb-release ca-certificates apt-transport-https software-properties-common -y

$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

$ echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

$ sudo apt update

$ apt-cache policy docker-ce

$ sudo apt install docker-ce -y

$ sudo systemctl enable docker && sudo systemctl start docker
```

*check docker is working*

```
$ docker --version
```

**2:** docker-compose kurulumu

```shell
$ sudo usermod -aG docker ${USER}

$ sudo curl -SL https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

$ sudo chmod +x /usr/local/bin/docker-compose
```

*check docker-compose is working*

```
$ docker-compose --version
```


## Kaynaklar

[https://github.com/alperen-selcuk/docker-install](https://github.com/alperen-selcuk/docker-install)

