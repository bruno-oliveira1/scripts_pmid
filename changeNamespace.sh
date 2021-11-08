  
#!/bin/bash
#
# changeNamespace - Muda a namespace atual.
#
# Como usar: ". changeNamespace.sh [NAMESPACE]"
#
# Exemplo:
#             . changeNamespace.sh uat2
#
# Histórico de Versão:
#       Versão: 1.0
#             Autor: Heitor Bellini <heitor.bellini@engdb.com.br>
#             Data: 01/2021
#             Descrição: Primeira versão.

sed -i "1 s/^.*$/$1/" namespace.txt
