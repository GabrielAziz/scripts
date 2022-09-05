#! /bin/bash

#### VARIAVEIS
projects=();
default_projects=(bloodbank labs billing);

#### CORES
use_red()
{
  printf "\033[0;31m$*\033[0m";
}

#### APLICAÇOES A SEREM SUBIDAS
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

#### FUNÇOES
open_tab()
{
  gnome-terminal --tab -t "$1" -- bash -c "cd $2; $3; exec zsh";
}

up_server()
{
  projects+=( "user" );
  for project in ${projects[@]}; do
    $project;
  done
  kill -9 $PPID;
}


capture_args()
{
  ## QUANDO TEM 0 ARGUMENTOS
  if [ $# -eq 0 ]; then
    projects=${default_projects[@]}
  fi

  ## QUANDO TEM ENTRE 1 E 3 ARGUMENTOS
  if [ $# -gt 0 ] && [ $# -lt 4 ]; then
    for i in $*; do
      if [ $i == "bloodbank" ] || [ $i == "labs" ] || [ $i == "billing" ] ; then
        projects+=( $i );
      else
        echo "Erro ao conectar com o servidor $(use_red $i), apenas as opçoes $(use_red [bloodbank, labs, billing])";
        exit 1;
      fi
    done
  fi

  ## QUANDO TEM MAIS DE 4 ARGUMENTOS
  if [ $# -gt 4 ]; then
    echo "Argumentos demais, $(use_red maximo 4 argumentos)";
    exit 1;
  fi

up_server;
}

#### CAPTURANDO ARGUMENTOS
while getopts 'idh' OPTION; do
  case "$OPTION" in
    i)
      ##BloodBank
      echo "deseja subir $(use_red bloodbank)?(y/n)"
      read -r bloodbank_up
      if [ $bloodbank_up != "y" ] && [ $bloodbank_up != "n" ]; then echo "resposta invalida, apenas s/n"; exit 1; fi

      ##Labs
      echo "deseja subir $(use_red labs)?(y/n)"
      read -r labs_up
      if [ $labs_up != "y" ] && [ $labs_up != "n" ]; then echo "resposta invalida, apenas s/n"; exit 1; fi

      ##Billing
      echo "deseja subir $(use_red billing)?(y/n)"
      read -r billing_up
      if [ $billing_up != "y" ] && [ $billing_up != "n" ]; then echo "resposta invalida, apenas s/n"; exit 1; fi


      if [ $bloodbank_up = "y" ]; then projects+=( "bloodbank" ); fi
      if [ $labs_up = "y" ]; then projects+=( "labs" ); fi
      if [ $billing_up = "y" ]; then projects+=( "billing" ); fi
      up_server;

      exit 1;
      ;;
    d)
	##BloodBank
      echo "deseja adicionar $(use_red bloodbank) ao default?(y/n)"
      read -r bloodbank_up
      if [ $bloodbank_up != "y" ] && [ $bloodbank_up != "n" ]; then echo "resposta invalida, apenas s/n"; exit 1; fi

      ##Labs
      echo "deseja adcionar $(use_red labs) ao default?(y/n)"
      read -r labs_up
      if [ $labs_up != "y" ] && [ $labs_up != "n" ]; then echo "resposta invalida, apenas s/n"; exit 1; fi

      ##Billing
      echo "deseja adcionar $(use_red billing) ao default?(y/n)"
      read -r billing_up
      if [ $billing_up != "y" ] && [ $billing_up != "n" ]; then echo "resposta invalida, apenas s/n"; exit 1; fi


      if [ $bloodbank_up = "y" ]; then projects+=( "bloodbank" ); fi
      if [ $labs_up = "y" ]; then projects+=( "labs" ); fi
      if [ $billing_up = "y" ]; then projects+=( "billing" ); fi
	new_default_projects_string="${projects[@]// / }"
        default_projects_string="${default_projects[@]// / }"
        sed -i "5 s/default_projects=($default_projects_string)/default_projects=($new_default_projects_string)/" ~/.scripts/eblood_start.sh
	echo "Projetos que vo subir por padrao alterado"
	exit 1
        ;;
    h)
      echo "Voce pode apenas dar eblood_start e subir $(use_red [bloodbank, labs, billing e user])"
      echo "Mas se voce prefere argumentos pode passa-los, sera aceito $(use_red [bloodbank, labs, billing])"
      echo "Ou passar a flag $(use_red -i) para escolher interativamente quais subir"
      exit 1;
      ;;
    ?)
      echo "$(use_red Flag desconhecida:) use $(use_red [-h]) para acessar o tutorial "
      exit 1;
      ;;
  esac
done


#### RODANDO
capture_args $*;

