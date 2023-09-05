#! /bin/bash

databases=();

use_red()
{
  printf "\033[0;31m$*\033[0m";
}

create_databases()
{
  createdb ${CLIENTE}_eblood_bloodbank
  createdb ${CLIENTE}_eblood_auth
  createdb ${CLIENTE}_eblood_billing
  createdb ${CLIENTE}_eblood_labs
}

while getopts 'hemr' OPTION; do
  case "$OPTION" in
    h)
      echo "flag [-e] para criar todos os bancos do cliente atual"
      echo "flag [-r] para restaurar todos os bancos do cliente atual"
      echo "flag [-m] migrar os bancos"
      exit 1;
    ;;
    e)
      create_databases
      exit 1;
    ;;
    m)
      echo "deseja realizar migrations em $(use_red bloodbank)?(y/n)"
       read  bloodbank
       if [ $bloodbank = "y" ]; then databases+=( "bloodbank" ); fi

       echo "deseja realizar migrations em $(use_red labs)?(y/n)"
       read  labs
       if [ $labs = "y" ]; then databases+=( "labs" ); fi

       echo "deseja realizar migrations em $(use_red billing)?(y/n)"
       read  billing
       if [ $billing = "y" ]; then databases+=( "billing" ); fi


       for database in ${databases[@]}; do
         echo "$(use_red Migrando para ${database})"
         cd ~/dev/eblood/eblood_$database
         rails db:migrate
       done
    exit 1;
    ;;
    r)
      create_databases
      echo "deseja restaurar $(use_red bloodbank)?(y/n)"
      read  bloodbank
      if [ $bloodbank = "y" ]; then databases+=( "bloodbank" ); fi

      echo "deseja restaurar $(use_red labs)?(y/n)"
      read  labs
      if [ $labs = "y" ]; then databases+=( "labs" ); fi

      echo "deseja restaurar $(use_red billing)?(y/n)"
      read  billing
      if [ $billing = "y" ]; then databases+=( "billing" ); fi

      echo "deseja restaurar $(use_red auth)?(y/n)"
      read  auth
      if [ $auth = "y" ]; then databases+=( "auth" ); fi

      for database in ${databases[@]}; do
        database_name="${CLIENTE}_eblood_${database}"
        echo "$(use_red iniciando o dump do banco $database_name)"
        cd ~/dev/eblood/eblood_bloodbank
        (sleep 1; echo ${CLIENTE}; sleep 1; echo $database; sleep 1; echo "y") | eblood_utils dump
        tar xvf "${CLIENTE}_${database}.tar.gz"
        rm -rf "${CLIENTE}_${database}.tar.gz"
        pg_restore --clean -O -U gabriel -d "${CLIENTE}_eblood_${database}" -v -Fd "${CLIENTE}_${database}"
        rm -rf "${CLIENTE}_${database}"
        echo "$(use_red dump do banco $database_name foi finalizado)"
      done

      exit 1;
    ;;
  esac
done

echo "Qual o $(use_red nome do banco)?"
read -r nome
createdb $nome
