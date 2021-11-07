#!/bin/bash
#
# Traz uma lista de todos os serviços (arquivo pods_ambiente) instalados no ambiente e os apontamentos.
#

todospods (){
	> pods_$namespace
	> temp_pods_$namespace
		kubectl -n $namespace describe deploy | grep Name: | awk '{print $2}' | grep -v ^g- | grep -v orch^ >> pods_$namespace
		#kubectl get pods -A | grep -w $namespace | awk '{print $2}' >> pods_$namespace
		#cat pods_$namespace | grep -E '\-v1-' | awk -F '\\-v1' '{print $1"-v1"}' >> temp_pods_$namespace 
		#cat pods_$namespace | grep -E '\-v2-' | awk -F '\\-v2' '{print $1"-v2"}' >> temp_pods_$namespace
		#cat pods_$namespace | grep -E '\-v3-' | awk -F '\\-v3' '{print $1"-v3"}' >> temp_pods_$namespace
		#cat temp_pods_$namespace | sort > pods_$namespace
		#rm -rf temp_pods_$namespace
	}
todosapontamentos (){
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
	echo -n ${pods[$int]} >> apontamentos_$namespace.txt && echo -n " " >> apontamentos_$namespace.txt && echo -e $nome >> apontamentos_$namespace.txt
	#Incrementa 1 a int 
	int=$(( $int + 1 ))
done

}

#Converte os caracteres de caixa alta para caixa baixa os valores esperados são uat, uat2, uat3, prd, dev, etc.
namespace=$(echo "$1" | awk '{print tolower($0)}')

#Verifica se a variavel $namespace existe e/ou se é nula 
if [ -z $namespace ]; then
	#Se for verdadeira a condição verifica se o arquivo namespace.txt existe 
	if [ -f namespace.txt ]; then
		#Se existir mapeia o valor de namespace.txt para a variavel namespace
		read -r namespace<namespace.txt
	else
		#Se o arquivo namespace.txt não existir e logo a variavel namespace também é nula aborta o script e retorna código de erro 1 
		echo "Ambiente nao informado e arquivo namespace.txt nao existe"
		exit 1
	fi
else
	case $namespace in
		#Converte os valores digitados errados para o correto
		#E chama a função todospods e todos os apontamentos
		uta|uta2|uta3)
                        namespace=$(sed 's/uta/uat/g' <<< $namespace)
                        todospods
			todosapontamentos
                        ;;
                tua|tua2|tua3)
                        namespace=$(sed 's/tua/uat/g' <<< $namespace)
                        todospods
			todosapontamentos
                        ;;
                aut|aut2|aut3)
                        namespace=$(sed 's/aut/uat/g' <<< $namespace)
                        todospods
			todosapontamentos
                        ;;
                uat1|uta1|tua1|aut1)
                        namespace=$(sed -e 's/uat1/uat/' -e 's/uta1/uat/g' -e 's/aut1/uat/g' -e 's/tua1/uat/g' <<< $namespace)
                        todospods
			todosapontamentos
                        ;;
                uat|uat2|uat3|prd|dev)
                        todospods
			todosapontamentos
                        ;;
                *)
                        echo "Ambiente informado diferente do esperado - Ex: uat, uat2, prd etc ..."
        esac
fi
#Remove serviços começados com g- e orch-
grep  -vi ^g- apontamentos_$namespace.txt > arqaux
grep -vi ^orch- arqaux > apontamentos_$namespace.txt

#Separa serviços que não tenham provider_
grep -vi provider_ apontamentos_$namespace.txt > arqaux2

#Filtrar para linhas que tenham provider_ 
grep -i provider_ apontamentos_$namespace.txt > arqaux

#Converte de formato unix para windows.
awk 'sub("$", "\r")' arqaux > apontamentos_$namespace.txt 
awk 'sub("$", "\r")' arqaux2 > apontamentos_sem_provider_$namespace.txt

