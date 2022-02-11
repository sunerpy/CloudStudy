git status
git add -A
git commit -m "Initsetup"
git remote add origin git@github.com:sunerpy/archinstall.git
git remote -v
git push -u origin dev
git checkout master 
git status
git push -u origin master
git push git@github.com:sunerpy/archinstall.git


#多分支
git remote add aur ssh://aur@aur.archlinux.org/picgo-appimage-beta.git
git pull aur master --allow-unrelated-histories




#cgproxy
yay -Rsnc v2ray-cap-git
yay -S v2ray-cap-git
先启动cgproxy再启动qv2ray

#一次推送两个git仓库

git init
git remote add origin git@github.com:sunerpy/ansible.git
git push --set-upstream origin develop
git remote set-url --add origin git@gitee.com:sunerpy/ansible.git
git push --set-upstream origin develop
cat config
git push

