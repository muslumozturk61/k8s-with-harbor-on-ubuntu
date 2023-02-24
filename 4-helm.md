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
**2:** metallb kurulumu

```shell
$ kubectl edit configmap -n kube-system kube-proxy

# aşağıdaki gibi değitirilmelidir
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "ipvs"
ipvs:
  strictARP: true

# see what changes would be made, returns nonzero returncode if different
$ kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
$ kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

$ kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.9/config/manifests/metallb-native.yaml

$ sudo apt install sipcalc

$ ip a

$ sipcalc 192.168.199.51/24

$ cat > metallb-config.yaml << EOF
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.199.10-192.168.199.10
EOF

$ kubectl apply -f metallb-config.yaml

```


**3:** ingress-nginx kurulumu

```shell
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

$ helm repo update

$ helm install ingress-controller ingress-nginx/ingress-nginx

$ helm ls

$ kubectl get deployments
```

```shell
$ cat > sample-deployment.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    run: nginx
  name: nginx-deploy
spec:
  replicas: 1
  selector:
    matchLabels:
      run: nginx
  template:
    metadata:
      labels:
        run: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
EOF

$ kubectl apply -f sample-deployment.yaml

$ kubectl expose deploy nginx-deploy --port 80

$ cat > ingress.yaml << EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/configuration-snippet: |
      more_set_headers "X-Frame-Options: Deny";
      more_set_headers "X-Xss-Protection: 1; mode=block";
      more_set_headers "X-Content-Type-Options: nosniff";
  name: nginx-deploy
  namespace: default
spec:
  rules:
    - host: mysite.muslumozturk.com
      http:
        paths:
        - backend:
            service:
              name: nginx-deploy
              port: 
                number: 80
          path: /
          pathType: ImplementationSpecific
EOF

$ kubectl apply -f ingress.yaml

$ sudo nano /etc/hosts
 
192.168.199.10  mysite.muslumozturk.com 
 
Save it and check

$ curl http://nginx.devops.com
```





*check is ingress-nginx working*

```shell
# to see http and https ports
$ kubectl --namespace default get services -o wide -w ingress-controller-ingress-nginx-controller

# testing ports, must return http 404 exception
$ curl http://192.168.199.51:31035 

$ curl --insecure https://192.168.199.51:32381
```

*Note : to uninstall ingress-controller from kubernetes*
```shell
$ # helm uninstall ingress-controller
```






## Kaynaklar

[https://helm.sh/docs/intro/install](https://helm.sh/docs/intro/install)

[https://devopscube.com/install-configure-helm-kubernetes/](https://devopscube.com/install-configure-helm-kubernetes/)

ingress kurulumu adımları bu sitede

[https://kubernetes.github.io/ingress-nginx/deploy/#docker-for-mac](https://kubernetes.github.io/ingress-nginx/deploy/#docker-for-mac)


[https://metallb.universe.tf/installation/](https://metallb.universe.tf/installation/)

[https://www.shawonruet.com/2021/09/how-to-setup-metal-lb-for-nginx-ingress.html](https://www.shawonruet.com/2021/09/how-to-setup-metal-lb-for-nginx-ingress.html)

[https://www.youtube.com/watch?v=7dGLnDHJ4vU](https://www.youtube.com/watch?v=7dGLnDHJ4vU)
