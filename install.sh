#!/bin/bash
#!/bin/bash

apt-get update && apt-get upgrade
apt-get install curl apt-transport-https git iptables-persistent

swapoff -a
/etc/fstab
#/swap.img      none    swap    sw      0       0

/etc/modules-load.d/k8s.conf
br_netfilter
overlay

modprobe br_netfilter
modprobe overlay

/etc/sysctl.d/k8s.conf 
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1

iptables -I INPUT 1 -p tcp --match multiport --dports 6443,2379:2380,10250:10252 -j ACCEPT
netfilter-persistent save

apt-get install docker docker.io
systemctl enable docker


echo '{'> /etc/docker/daemon.json
echo '  "exec-opts": ["native.cgroupdriver=systemd"],'>> /etc/docker/daemon.json
echo '  "log-driver": "json-file",' >> /etc/docker/daemon.json
echo '  "log-opts": { ' >> /etc/docker/daemon.json
echo '  "max-size": "100m" ' >> /etc/docker/daemon.json
echo '  }, ' >> /etc/docker/daemon.json
echo '  "storage-driver": "overlay2", ' >> /etc/docker/daemon.json
echo '  "storage-opts": [ ' >> /etc/docker/daemon.json
echo '    "overlay2.override_kernel_check=true"' >> /etc/docker/daemon.json
echo '  ] ' >> /etc/docker/daemon.json
echo '}' >> /etc/docker/daemon.json

systemctl restart docker

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
apt-get update
apt-get install kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

export KUBECONFIG=/etc/kubernetes/admin.conf

/etc/environment
export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
