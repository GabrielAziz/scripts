#! /bin/bash

clientes_cadastrados=("clinhemo" "colsan" "ctn" "cts" "haima" "ihemo" "shhsjc" "homolog")

use_red()
{
  printf "\033[0;31m$*\033[0m";
}

atualizar_cliente()
{
  if egrep -q "export CLIENTE=" ~/.zshrc ;then
    sed -i "s/export CLIENTE=$CLIENTE/export CLIENTE=$cliente/" ~/.zshrc
  else
    echo -e "#Cliente atual\nexport CLIENTE=$cliente" >> ~/.zshrc
  fi
}


  printf "Escolha um cliente $(use_red [clinhemo colsan ctn cts haima ihemo shhsjc homolog]):"
  read -r cliente

  if egrep -qw "$cliente" <<< "${clientes_cadastrados[@]}";then
    atualizar_cliente
    echo "Cliente anterior: $(use_red $CLIENTE)"
    echo "Cliente novo: $(use_red $cliente)"
    exec /bin/zsh
  else
    echo "Cliente $cliente nao foi ENCONTRADO... Tente novamente";
  fi

