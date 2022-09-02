#! /bin/bash

#### VARIAVEIS
projects=();

#### CORES
use_red()
{
  printf "\033[0;31m$*\033[0m";
}

#### FUNÇOES
open_tab()
{
  gnome-terminal --tab -t "$1" -- bash -c "cd $2; $3; exec zsh";
}

up_server()
{
  for project in ${projects[@]}; do
    $project;
  done
}

#### APLICAÇOES
bloodbank()
{
  tabname="BloodBank"
  path="$HOME/dev/eblood/eblood_bloodbank";
  open_tab $tabname $path "rails server -p 3000";
}

labs()
{
  tabname="Labs";
  path="$HOME/dev/eblood/eblood_labs";
  open_tab $tabname $path "rails s -p 3001";
}

billing()
{
  tabname="Billing";
  path="$HOME/dev/eblood/eblood_billing";
  open_tab $tabname $path "rails s -p 3002";
}

user()
{
  tabname="User";
  path="$HOME/dev/eblood/eblood_users";
  open_tab $tabname $path "bundle exec puma";
}

#### RODANDO

## QUANDO TEM 0 ARGUMENTOS
if [ $# -eq 0 ]; then
  projects=( "bloodbank" "labs" "billing" "user" );
fi

## QUANDO TEM ENTRE 1 E 4 ARGUMENTOS
if [ $# -gt 0 ] && [ $# -lt 5 ]; then
  for i in $*; do
    if [ $i == "bloodbank" ] || [ $i == "labs" ] || [ $i == "billing" ] || [ $i == "user" ]; then
      projects+=( $i );
    else
      echo "Erro ao conectar com o servidor $(use_red $i), apenas as opçoes $(use_red [bloodbank, labs, billing, user])";
      exit 1;
    fi
  done
fi

## QUANDO TEM MAIS DE 4 ARGUMENTOS
if [ $# -gt 4 ]; then
  echo "Argumentos demais, $(use_red maximo 4 argumentos)";
  exit 1;
fi

## SUBINDO APLICAÇOES
up_server;
kill -9 $PPID;

