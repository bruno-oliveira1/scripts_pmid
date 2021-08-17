param($1, $2, $3)

$1 = $1.ToLower();
$namespace = $(Test-Path .\namespace.txt)

function lesspod {
if ($3) 
{
    kubectl -n $namespace logs -f $1 | Select-String $3 | wsl less
}
elseif (!$3) 
{
    kubectl -n $namespace logs -f $1 | wsl less
}
}

function help {
Write-Host "Uso:
Primeiro argumento eh o pod - Ex: r-client-info
Segundo argumento eh o ambiente - Ex: uat, uat2, uat3, prd
Terceiro argumento eh a tid para filtrar"
}

if ($1 -eq "help") 
{
    help; exit
    }
elseif ($1 -eq "--help") 
{
    help; exit
    }

if ($2) 
{
    $namespace = $2.ToLower(); lesspod
    }
elseif (!$2 -and $namespace -eq "True") 
{ 
    $namespace=(Get-Content .\namespace.txt).ToLower(); lesspod
    }
else { 
    Write-Host "Namespace nao informado - Ex: uat, uat2, uat3" 
    }