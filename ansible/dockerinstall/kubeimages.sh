#!/bin/bash
export LANG=en_US.utf-8
##########################################################################
#    @File    :   kubeimages.sh
#    @Time    :   2022/02/27 11:21:07
#    @Author  :   sunerpy
#    @Version :   1.0
#    @Contact :   sunerpy<nkuzhangshn@gmail.com>
#    @Desc    :   None
desturl=harbor.io/sunerpy
originurl=registry.aliyuncs.com/google_containers
version=v1.23.4
tmpfile=/root/tmpfile
kubeadm config images list --kubernetes-version=${version}|awk -F '/' '{print $2}'>/root/tmpfile
mapfile -t images < "${tmpfile}"
for imagename in "${images[@]}" ; do
  docker pull $originurl/"$imagename"
  docker tag $originurl/"$imagename" $desturl/"$imagename"
  docker rmi -f $originurl/"$imagename"
  docker save -o "${imagename}.tar"  $desturl/"$imagename"
  docker push $desturl/"$imagename"
done


#remote sh
desturl=harbor.io:8080/sunerpy
originurl=harbor.io/sunerpy
tmpfile=/root/tmpfile
docker images |awk '/harbor.io/ {print $1":"$2}'|awk -F '/' '{print $3}' >/root/tmpfile
mapfile -t images < "${tmpfile}"
for imagename in "${images[@]}" ; do
  docker tag $originurl/"$imagename" $desturl/"$imagename"
  docker rmi -f $originurl/"$imagename"
  docker push $desturl/"$imagename"
done