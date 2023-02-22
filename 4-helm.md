# Helm
**Helm** uygulamasının Ubuntu 22.04 ortamında kurulumu adımlarına buradan ulaşabilirsiniz.


**1:** helm kurulumu

```shell
$ curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

$ sudo apt-get install apt-transport-https --yes

$ echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

$ sudo apt-get update

$ sudo apt-get install helm
```

**2:** ingress-nginx kurulumu

```shell
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

$ helm repo update

$ helm install ingress-controller ingress-nginx/ingress-nginx

$ helm ls

$ kubectl get deployments
```

*check is ingress-nginx working*

```shell
# to see http and https ports
$ kubectl --namespace default get services -o wide -w ingress-controller-ingress-nginx-controller

# testing ports, must return http 404 exception
$ curl http://192.168.199.51:31035 

$ curl --insecure https://192.168.199.51:32381
```

*note : to uninstall ingress-controller from kubernetes*
```shell
$ # helm uninstall ingress-controller
```

## Kaynaklar

[https://helm.sh/docs/intro/install](https://helm.sh/docs/intro/install)

[https://devopscube.com/install-configure-helm-kubernetes/](https://devopscube.com/install-configure-helm-kubernetes/)

ingress kurulumu adımları bu sitede

[https://kubernetes.github.io/ingress-nginx/deploy/#docker-for-mac](https://kubernetes.github.io/ingress-nginx/deploy/#docker-for-mac)
