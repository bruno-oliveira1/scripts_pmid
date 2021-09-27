#!/bin/bash
#
#
#  todosadapters.sh - Esse script tem como objetivo consultar todos os apontamentos dos serviços NMWS da máquina
#
#
#       Versão: 1.0
#               Autor: Bruno da Silva Oliveira <bruno.oliveira2@engdb.com.br>
#               Date: 24/09/2021
#               Descrição: Versão ininicial

#Diretório onde estão os adapters
arquivos=/nmws_app/nmws26/repository/resources/adapters

#Pega o hostname para definir qual é o ambiente
namespace=$(hostname | cut -d. -f1)

#Caminho do viewAdapters.sh (modificado para retornar somente o necessário)
todosadapters=/nmws_app/cmd/adapters.sh

#Baseado no hostname define se é uat1, 2 ou 3. Essa variável será usada para nomear o arquivo posteriormente.
case $namespace in
                snelnxj50|snelnxj49)
                        namespace=uat
                        ;;
                snelnxj51|snelnxj52)
                        namespace=uat2
                        ;;
                snelnxj47|snelnxj48)
                        namespace=uat3
                        ;;
                *)
                        echo "Hostname diferente do esperado - Ex: snelnxj50, snelnxj52, snelnxj48, etc ..."
        esac

#Pega todos os arquivos de adapters e guarda dentro de um vetor
adapter=( $(ls $arquivos/adapters_app_*.xml | awk -F '/adapters_app_' '{print $2}' | cut -d. -f1 ) )

#Conta quantos arquivos tem para que com esse valor controlar a execução do loop
quantidade=$(ls $arquivos/adapters_app_*.xml | wc -l )

#Remove o conteúdo ou cria os arquivos caso eles não existam
> apontamentos_nmws_$namespace
> apontamentos_nmws_$namespace.txt


#Variável de contador - define o inicio do vetor
int=0

#Aqui que onde acontece a ciência
#Enquanto o valor de int for menor que o de quantidade os comandos abaixo serão executados
while [ $int -lt $quantidade ]
do
        #Verifica o apontamento do serviço que estiver na posição definida por int do vetor e guarda na variavel nome
        nome=$($todosadapters ${adapter[$int]})

        #Joga o conteúdo de nome para o arquivo
        echo $nome >> apontamentos_nmws_$namespace

        #Incrementa 1 a int
        int=$(( $int + 1 ))
done
        #Remove da lista os serviços que chamam o salt (orchs, etc)
        grep -vi salt apontamentos_nmws_$namespace > apontamentos_nmws_$namespace.txt

        #Pega o arquivo anterior e copia os serviços que estão com apontamento em branco para outro arquivo
        grep -vi endpoint:  apontamentos_nmws_$namespace.txt > apontamentos_nmws_sem_provedor_$namespace.txt

        #Filtra os serviços que tem apontamento para outro arquivo
        grep -i endpoint:  apontamentos_nmws_$namespace.txt > apontamentos_nmws_$namespace

        #Converte a tabulação do arquivo de UNIX para DOS (Windows), sendo assim possível abrir o arquivo no notepad comum
        awk 'sub("$", "\r")' < apontamentos_nmws_$namespace > apontamentos_nmws_$namespace.txt

        #Remove o arquivo que foi usado como redirecionador
        rm -rf apontamentos_nmws_$namespace
