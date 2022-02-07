#!/bin/bash
#Esse script trabalha em conjunto com o todos_pods.sh e serve para levantar todos os apontamentos de todos os pods retornados pelos todos_pods.sh

#Converte os caracteres de caixa alta para caixa baixa os valores esperados são uat, uat2, uat3, prd, dev, etc.
namespace=$(echo "$1" | awk '{print tolower($0)}')

#Verifica se a variavel $namespace existe e/ou se é nula 
if [ -z $namespace ]; then
	#Se for verdadeira a condição verifica se o arquivo namespace.txt existe 
	if [ -f $HOME/namespace.txt ]; then
		#Se existir mapeia o valor de  $HOME/namespace.txt para a variavel namespace
		read -r namespace<$HOME/namespace.txt
	else
		#Se o arquivo  $HOME/namespace.txt não existir e logo a variavel namespace também é nula aborta o script e retorna código de erro 1 
        echo "Ambiente nao informado e arquivo  $HOME/namespace.txt nao existe"
        exit 1
        fi
else

#Pega o conteúdo do arquivo pods_ambiente (uat, uat2, etc) e mapeia para dentro do vetor pods 
pods=( $(cat pods_$namespace) )

#Calcula a quantidade de pods
quantidade=$(cat pods_$namespace | wc -l)

#Apaga o conteúdo do arquivo apontamentos_ambiente (uat, uat2, etc) se ele existir senão existir cria o arquivo
> apontamentos_$namespace

#Variável de contador
int=0

#Compara se o valor de int é menor que o de quantidade e se for executa o a condição abaixo senão for encerra a execução do script 
while [ $int -lt $quantidade ]
do
	#Verifica o apontamento do serviço que estiver na posição int do vetor e guarda na variavel nome
	nome=$(checkEndpoint.sh ${pods[$int]} $namespace)
	#Concatena o nome do serviço com o apontamento e envia para o arquivo apontamentos_ambiente
	echo -n ${pods[$int]} >> apontamentos_$namespace && echo -n " " >> apontamentos_$namespace && echo -e $nome >> apontamentos_$namespace
	#Incrementa 1 a int 
	int=$(( $int + 1 ))
done
