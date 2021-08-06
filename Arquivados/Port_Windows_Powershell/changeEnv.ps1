param($1)

function lower {
    $1 = $1.ToLower();
}

function dev {
gcloud config set project tim-pmid-dev
gcloud config set compute/region southamerica-east1
gcloud container clusters get-credentials pmid-dev --region=southamerica-east1
echo "Voce entrou no cluster DEV"
}

function fqa {
gcloud config set project tim-pmid-fqa
gcloud config set compute/region southamerica-east1                                                                                          
gcloud container clusters get-credentials tim-pmid-uat --region southamerica-east1 --project tim-pmid-fqa
echo "Voce entrou no cluster FQA"
}

function prd {
gcloud config set project tim-pmid-prd 
gcloud config set compute/region southamerica-east1                                        
gcloud container clusters get-credentials pmid-prod --region=southamerica-east1
echo "Voce entrou no cluster PRD"
}
    
function invalido {
    echo "Parametro invalido"
}
switch ( $1 )
{
    dev {  dev  }
    fqa { fqa }
    prd { prd }
    default { invalido }
}