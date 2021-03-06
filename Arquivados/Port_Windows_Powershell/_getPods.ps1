param($1, $2)
$namespace=$(Test-Path .\namespace.txt)

function getpods {
    kubectl get pods -A | Select-String $namespace | Select-String $pod
}

$pod = $1.ToLower();

if ($2) 
{
    $namespace = $2.ToLower(); getpods
    }
elseif (!$2 -and $namespace -eq "True") 
{ 
    $namespace=(Get-Content .\namespace.txt).ToLower(); getpods
    }
else 
{
     Write-Host "Namespace não informado - Ex: uat, uat2, uat3" 
     }