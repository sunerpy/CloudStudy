#!/bin/bash
export LANG=en_US.utf-8
##########################################################################
#    @File    :   get_harbor_images.sh
#    @Time    :   2022/02/10 11:42:41
#    @Author  :   sunerpy
#    @Version :   1.0
#    @Contact :   sunerpy<nkuzhangshn@gmail.com>
#    @Desc    :   Get images and tags with Harbor API 2.0 

#harbor地址
HURL="http://harbor.io"
#harbor用户和密码
HUSER='admin'
HPASSWD='Harbor12345'
IMAGEURL=${HURL/http*\/\//}

# curl -s 去除统计信息
projectLists=$(curl -s -u $HUSER:$HPASSWD -H "Content-Type: application/json" -X GET "${HURL}/api/v2.0/projects" | python -m json.tool | awk -F '"' '/"name"/{print $4}')
for projectList in $projectLists; do
    imageNames=$(curl -s -u $HUSER:$HPASSWD -H "Content-Type: application/json" -X GET "${HURL}/api/v2.0/projects/${projectList}/repositories" -k | python -m json.tool | awk -F '"' '/"name"/{print $4}')
    for imageName in $imageNames; do
        imageTags=$(curl -s -u $HUSER:$HPASSWD -H "Content-Type: application/json" -X GET "${HURL}/v2/${imageName}/tags/list" -k | awk -F '"' '{print $8,$10,$12}')
        for imageTag in $imageTags; do
            echo -e "${IMAGEURL}/$imageName:$imageTag"
        done
    done
done