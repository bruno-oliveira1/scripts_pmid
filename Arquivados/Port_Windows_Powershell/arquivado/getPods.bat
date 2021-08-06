@ECHO OFF
echo "Uso"
echo "Nome do servico e ambiente"
echo "r-contract-info uat2"
kubectl get pods -A | findstr /R /C:"%2" | findstr /R /C:"%1"
