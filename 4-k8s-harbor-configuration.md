# Kubernetes-Harbor Ayarları
**Kubernetes ile Harbor** arasındaki yapılması gerekenlerin Ubuntu 22.04 ortamındaki adımlarına buradan ulaşabilirsiniz.

Harbor kurulum sürecinde oluşturduğumuz sertifikaları kullanacacağız.

**1:** host dosyasına domain'in tanımlanması

```shell
$ echo '192.168.199.54  harbor.muslumozturk.com' | sudo tee -a /etc/hosts
```

**2:** ubuntuda kök sertifikaların tanılması

*Bu işlemler hem master hemde worker node'larda yapılacaktır*

```shell
$ sudo apt-get install -y ca-certificates

$ sudo cp ca.crt /usr/local/share/ca-certificates

$ sudo update-ca-certificates
```

**3:** kubernetes ayarları

kubernetes için öncelikle bir private registry secret üreteceğiz. username ve password olarak açtığımız admin yetkili user ı verebiliriz.

```shell
$ kubectl create secret docker-registry muslumozturk-harbor-registry --docker-server=<registry> --docker-username=<username> --docker-password=<password> --docker-email=<email_address>
```
daha sonra bu secret in bütün podlarda kullanılaması için default service account a inject etmemiz gerekiyor. ister editleyerek ister patchleyerek bunu yapabiliriz.

```shell
$ kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "muslumozturk-harbor-registry"}]}'
```

## Kaynaklar

[https://ubuntu.com/server/docs/security-trust-store](https://ubuntu.com/server/docs/security-trust-store)


[https://www.youtube.com/watch?v=Zx4KTsxs0XE](https://www.youtube.com/watch?v=Zx4KTsxs0XE)

[https://github.com/alperen-selcuk/private-registry-harbor-installation](https://github.com/alperen-selcuk/private-registry-harbor-installation)

[https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)