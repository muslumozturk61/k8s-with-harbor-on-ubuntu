# Verdaccio kurulumu
**Verdaccio** nun Ubuntu 22.04 ortamındaki adımlarına buradan ulaşabilirsiniz.


**1:** curl kurulumu

```shell
$ sudo apt install curl

$ curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - && sudo apt-get install -y nodejs

$ sudo npm install --location=global verdaccio
```

**2:** verdaccio kurulumu

```shell
# NOT:ubuntu da kullanıcı oluşturma adımları uygulamıyoruz
# vuser isimli verdaccio kullanıcısını oluşturuyoruz
$ sudo adduser --system --gecos 'Verdaccio NPM mirror' --group --home /var/lib/vuser vuser

# vuser kullanıcısının hesabına geçiyoruz
$ sudo su -s /bin/bash vuser

# verdaccci kullanısıcının home klasörüne gidiyoruz
$ cd

# verdaccio uygulamasını config dosyaları oluşması için ilk kez çalıştırıyoruz 
$ verdacccio

# aşağıdaki adreste config dosyası oluşmuş oluyor
$ /var/lib/vuser/verdaccio/config.yaml


# verdaccio nun çalıştığını kontrol ediyoruz
$ curl http://localhost:4873/
```

**3:** verdaccio kullanıcı işlemleri

```shell

# kullanıcı ekleme
$ npm adduser --registry http://localhost:4873/ --auth-type=legacy
$ npm adduser --registry https://npm.muslumozturk.com:4873/ --auth-type=legacy

# login olmak için 
$ npm login --registry http://localhost:4873/ --auth-type=legacy
$ npm login --registry https://npm.muslumozturk.com:4873/ --auth-type=legacy

# kodların verdaccio'ya push edilmesi
$ npm publish --registry http://localhost:4873/
$ npm publish --registry https://npm.muslumozturk.com:4873/

```



**2:** uygulamanın servis olarak çalışması

```shell
# systemctl dosyasını oluşturuyoruz
$ cat <<EOF | sudo tee /etc/systemd/system/verdaccio.service
[Unit]
Description=Verdaccio Service
After=network.target

[Service]
Type=simple
Restart=always
WorkingDirectory=/var/lib
ExecStart=verdaccio

[Install]
WantedBy=multi-user.target
EOF

# servisi aktif edip başlatıyoruz
$ sudo systemctl daemon-reload
$ sudo systemctl enable verdaccio.service
$ sudo systemctl start verdaccio.service

```
**2** sertikifa üretimi
```shell
$ mkdir certs && cd certs

$ sudo apt install openssl

$ openssl genrsa -out ca.key 4096

$ openssl req -x509 -new -nodes -sha512 -days 3650 -subj "/C=CN/ST=Istanbul/L=Istanbul/O=devops/OU=Personal/CN=npm.yaz.com.tr" -key ca.key -out ca.crt

$ openssl genrsa -out npm.yaz.com.tr-key.pem 4096

$ openssl req -sha512 -new -subj "/C=CN/ST=Istanbul/L=Istanbul/O=devops/OU=Personal/CN=npm.yaz.com.tr" -key npm.yaz.com.tr-key.pem -out npm.yaz.com.tr-csr.pem

$ cat > v3.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=npm.yaz.com.tr
DNS.2=npm.yaz
DNS.3=npmsrv
EOF

$ openssl x509 -req -sha512 -days 3650 -extfile v3.ext -CA ca.crt -CAkey ca.key -CAcreateserial -in npm.yaz.com.tr-csr.pem -out npm.yaz.com.tr-crt.pem

$ openssl x509 -inform PEM -in npm.yaz.com.tr-crt.pem -out npm.yaz.com.tr.cert

$ openssl x509 -inform PEM -in ca.crt -out ca.cert

$ openssl x509 -inform PEM -in npm.yaz.com.tr.cert -out npm.yaz.com.tr.crt
```


**3:**ssl ayarları
```shell

# /etc/hosts dosyası içinde domain yönlendirmemizi yapıyorz
$ echo '127.0.0.1  npm.muslumozturk.com' | sudo tee -a /etc/hosts

# /var/lib/vuser/verdaccio/config.yaml dosyasında aşağıdaki değişiklik yapılır
listen: https://npm.muslumozturk.com:443
# - localhost:4873            # default value
# - http://localhost:4873     # same thing
# - 0.0.0.0:4873              # listen on all addresses (INADDR_ANY)
# - https://npm.muslumozturk.com:4873  # if you want to use https
# - "[::1]:4873"                # ipv6
# - unix:/tmp/verdaccio.sock    # unix socket


# ssl sertifikaları oluşturulur

$ sudo mkdir /etc/verdaccio

$ sudo cp npm.yaz.com.tr-csr.pem /etc/verdaccio
$ sudo cp npm.yaz.com.tr-key.pem /etc/verdaccio
$ sudo cp npm.yaz.com.tr-crt.pem /etc/verdaccio

$ sudo cp npm.yaz.com.tr.cert /usr/share/ca-certificates

$ sudo update-ca-certificates


# config dosyasında sertifakalar ayarları aktif hale getirilerek aşağıdaki gibi tanımlanır 
https:
    key: /etc/verdaccio/npm.yaz.com.tr-key.pem
    cert: /etc/verdaccio/npm.yaz.com.tr-crt.pem
    ca: /etc/verdaccio/npm.yaz.com.tr-csr.pem


# npm login self-signed certificate hatası çözümü 
# $ npm config set ca ""
$ npm config set strict-ssl false


Not:

npm global dosya yolunu verir
npm root -g
/usr/lib/node_modules


npm config set auth-type legacy
npm set registry https://npm.muslumozturk.com:6100/

verdaccio -c /home/muslum/Desktop/ver-config/config.yaml


```
## Kaynaklar

[https://verdaccio.org/docs/server-configuration](https://verdaccio.org/docs/server-configuration)

[https://iamdual.com/posts/systemd/](https://iamdual.com/posts/systemd/)

[https://verdaccio.org/docs/ssl](https://verdaccio.org/docs/ssl)

