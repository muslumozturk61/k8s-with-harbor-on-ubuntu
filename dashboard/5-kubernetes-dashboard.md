# Kubernetes Dashboard
**Kubernetes Dashboard** kurulumu adımlarına buradan ulaşabilirsiniz.

**1:** dashboard kurulumu
```shell
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

$ kubectl proxy

```

Tarayıcıdan [http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/) sayfası açılır

**2:** kullanıcı tanımlama ve token oluşturma
```shell
$ kubectl apply -f dashboard-adminuser.yaml

$ kubectl -n kubernetes-dashboard create token admin-user

```
Oluşan token ile dashboard arayüzüne giriş yapılır


##Kaynaklar

[https://github.com/kubernetes/dashboard](https://github.com/kubernetes/dashboard)

[https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md)