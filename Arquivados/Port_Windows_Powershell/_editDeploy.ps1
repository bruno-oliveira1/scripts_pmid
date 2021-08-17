param($1, $2)
$namespace=$(Test-Path .\namespace.txt)

function editpods {
    kubectl -n $namespace edit deploy $1
    }

$pod = $1.ToLower();

if ($2) 
{
    $namespace = $2.ToLower(); editpods
    }
elseif (!$2 -and $namespace -eq "True") 
{ 
    $namespace=(Get-Content .\namespace.txt).ToLower(); editpods
    }
else 
{
     Write-Host "Namespace não informado - Ex: uat, uat2, uat3" 
     }