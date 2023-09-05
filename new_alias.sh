#! /bin/bash

use_red()
{
  printf "\033[0;31m$*\033[0m";
}

use_green()
{
  printf "\033[0;32m$*\033[0m"
}

comentario()
{
  printf "\033[0;34m#$*\033[0m";
}

add_view()
{
  #Verificando se o arquivo existe
  path=/home/gabriel/.scripts/my_alias.sh
  if [ -f $path ]; then
    echo -e "echo -e \"$(comentario $comentario)\"" >> $path
    echo -e "echo -e \"alias $nome=\\\"$comando\\\"\"" >> $path
  else
    touch $path
    chmod +x $path
    echo "#! /bin/bash" >> $path
    echo "comentario(){ printf \"\033[0;34m#$*\033[0m\";}" >> $path
    add_view
  fi
}

echo "Qual o $(use_red nome do alias)?"
read -r nome

echo "Qual o $(use_red comando)?"
read -r comando

echo "Qual o $(use_red comentario)?"
read -r comentario

echo -e "\n==========================="

echo "$(comentario $comentario)"
echo "$nome=\"$comando\""

echo -e "===========================\n"
echo "Seu alias está correto? ($(use_green y)/$(use_red n))"
read -r correto

if [ $correto == "y" ]; then
  echo -e "#$comentario \nalias $nome=\"$comando\"" >> ~/.zshrc
  echo "Alias adicionado com sucesso! :)"

  echo "Deseja adicionar ao arquivo de visualizaçao? ($(use_green y)/$(use_red n))"
  read -r adicionar
  if [ $adicionar == "y" ]; then add_view; fi
  exec /bin/zsh;
fi