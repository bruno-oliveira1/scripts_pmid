#!/bin/bash
#
# Traz uma lista de todos os serviços (arquivo pods_ambiente) instalados no ambiente e os apontamentos.
#

todospods (){
	> pods_$namespace
		kubectl -n $namespace describe deploy | grep Name: | awk '{print $2}' | grep -v ^g- | grep -v orch^ >> pods_$namespace
	}
todosapontamentos (){
#Pega o conteúdo do arquivo pods_ambiente (uat, uat2, etc) e mapeia para dentro do vetor pods 
pods=( $(cat pods_$namespace) )

#Calcula a quantidade de pods
quantidade=$(cat pods_$namespace | wc -l)

#Apaga o conteúdo dos arquivo apontamentos_pmid_*_ambiente.txt (uat, uat2, etc) se eles existirem senão existirem cria os arquivos
> apontamentos_pmid_$namespace.txt
> apontamentos_pmid_sem_provider_$namespace.txt
> apontamentos_pmid_nome_$namespace.txt
> apontamentos_pmid_ip_$namespace.txt 

#Variável de contador
int=0

#Compara se o valor de int é menor que o de quantidade e se for executa o a condição abaixo senão for encerra a execução do script 
while [ $int -lt $quantidade ]
do
	#Verifica o apontamento do serviço que estiver na posição int do vetor e guarda na variavel nome
	nome=$(checkEndpoint.sh ${pods[$int]} $namespace 2> /dev/null ) 
	#Concatena o nome do serviço com o apontamento e envia para o arquivo apontamentos_ambiente
	echo -n ${pods[$int]} >> apontamentos_pmid_$namespace.txt && echo -n " " >> apontamentos_pmid_$namespace.txt && echo -e $nome >> apontamentos_pmid_$namespace.txt 
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
		echo "Valores esperados uat, uat2, uat3, prd, dev"
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
                uat|uat2|uat3|prd|dev|s-uat|m-uat|f-uat|e-uat|s-uat2|m-uat2|f-uat2|e-uat2|s-uat3|m-uat3|f-uat3|e-uat3)
                        todospods
			todosapontamentos
                        ;;
                *)
                        echo "Ambiente informado diferente do esperado - Ex: uat, uat2, prd etc ..."
        esac
fi
#Remove serviços começados com g- e orch-
sed -e 's/PROVIDER\_ADDRESS/Apontamento/g' -i apontamentos_pmid_$namespace.txt
grep  -vi ^g- apontamentos_pmid_$namespace.txt > arqaux
grep -vi ^orch- arqaux > apontamentos_pmid_$namespace.txt

#Separa serviços que não tenham provider_
grep -v Apontamento apontamentos_pmid_$namespace.txt > arqaux2

#Filtrar para linhas que tenham provider_ 
grep Apontamento apontamentos_pmid_$namespace.txt > arqaux

#Converte de formato unix para windows, e remove arquivos auxiliares
awk 'sub("$", "\r")' < arqaux > apontamentos_pmid_$namespace.txt 
awk 'sub("$", "\r")' < arqaux2 > apontamentos_pmid_sem_provider_$namespace.txt

#Separando apontamentos por nome e por ip
grep -E '\@[0-9]{2}' apontamentos_pmid_$namespace.txt >> apontamentos_pmid_ip_$namespace.txt
grep -Ei '\@[a-z]{2}' apontamentos_pmid_$namespace.txt >> apontamentos_pmid_nome_$namespace.txt
grep -E 'http*\:\/\/[0-9]{2}' apontamentos_pmid_$namespace.txt >> apontamentos_pmid_ip_$namespace.txt
grep -Ei 'http*\:\/\/[a-z]{2}' apontamentos_pmid_$namespace.txt >> apontamentos_pmid_nome_$namespace.txt

#Essa parte só funciona se vc estiver usando WSL pois invoca comandos windows 
u=$( cmd.exe /c echo %HOMEPATH% 2> /dev/null | cut -d\\ -f3)
usuario=$(awk '{ sub("\r$", ""); print }' <<< $u) 

cp apontamentos_pmid_$namespace.txt /mnt/c/Users/$usuario/Downloads/
cp apontamentos_pmid_sem_provider_$namespace.txt /mnt/c/Users/$usuario/Downloads/
cp apontamentos_pmid_nome_$namespace.txt /mnt/c/Users/$usuario/Downloads/
cp apontamentos_pmid_ip_$namespace.txt /mnt/c/Users/$usuario/Downloads/

cat arqaux > apontamentos_pmid_$namespace.txt 
cat arqaux2 > apontamentos_pmid_sem_provider_$namespace.txt

#Pegando por nome e por ip
rm -rf arqaux*


