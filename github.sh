#!/bin/sh

#Altere as variáveis abaixo de acordo com a sua necessidade
#na variável repositório, prefira a url do repositório baseada em https para nao termos que configurar SSH
export name='victorhugonicolau'
export email="victor.castro29@etec.sp.gov.br"
export repositorio="https://github.com/daniykt/RastroBus.git";

#Daqui pra baixo mexa somente se for realmente necessário ou se souber o que está fazendo :P

export branch_name="RastroBus-$(date +%d%m%Y)"

rm -Rf .git

#add linux, mac and windows folders to gitignore
echo "" >> .gitignore
echo "#ignoring windows, mac and linux folders" >> .gitignore
echo "windows" >> .gitignore
echo "mac" >> .gitignore
echo "linux" >> .gitignore

git init
git remote add origin $repositorio
git checkout -b $branch_name

git config --global user.name $name
git config --global user.email $email

git add .gitignore
git commit -m "added ignored files" .gitignore

git add .

git commit -am "RastroBus - Formatando e criando o tema + google fontes - $(date)"

git push origin $branch_name