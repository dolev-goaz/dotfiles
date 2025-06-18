export AAD_GROUP_GUID=7a12d1d2-d658-460a-9a6e-99950ecd0af4
# Parameters by env
if [ "$1" = "--dev" ] || [ -z "$1" ]; then
    export AWS_DEFAULT_PROFILE=dev-developer-il

    export CLUSTER_NAME=dev-eks
    export ACCOUNT_NUMBER=119268605376
    export CONTEXT_ALIAS=dev-eks-dev
elif [ "$1" = "--prod" ]; then
    export AWS_DEFAULT_PROFILE=hr-developer-il

    export CLUSTER_NAME=hr-eks
    export ACCOUNT_NUMBER=651898668523
    export CONTEXT_ALIAS=hr-il-eks-hr
else
  echo "Usage: $0 [--dev|--prod]"
  exit 1
fi

echo "Running AWS SSO login with profile $AWS_DEFAULT_PROFILE"
aws sso login
echo "SSO login completed, now configuring Kubernetes"
aws eks update-kubeconfig --region il-central-1 --name $CLUSTER_NAME --alias $CONTEXT_ALIAS --role-arn arn:aws:iam::${ACCOUNT_NUMBER}:role/digitalidf-developer-$AAD_GROUP_GUID
