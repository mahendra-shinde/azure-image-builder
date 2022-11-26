# BEWARE : This is DELETING the Image created for you, be sure this is what you want!!!
source 01_setenv.sh
read -p "Everything will be deleted !! \r\n Are you sure [y/n] : " yourChoice

if [ "$yourChoice" != "y" ];
then
	echo "Thanks for cancelling deleting at last moment !"
	return
fi

echo  "delete permissions asssignments, roles and identity"
az role assignment delete -g $sigResourceGroup

az role definition delete --name "$imageRoleDefName"

az identity delete --ids $imgBuilderId

echo "deleting an  AIB Template"
az resource delete --resource-group $sigResourceGroup --resource-type Microsoft.VirtualMachineImages/imageTemplates -n image-template-01

echo "Get image version created by AIB, this always starts with 0.*"
sigDefImgVersion=$(az sig image-version list -g $sigResourceGroup --gallery-name $sigName --gallery-image-definition $imageDefName --subscription $subscriptionID --query "[].name" -o json | grep 0. | tr -d '"')

echo  "Deleting an image version"
az sig image-version delete -g $sigResourceGroup --gallery-image-version $sigDefImgVersion --gallery-name $sigName --gallery-image-definition $imageDefName --subscription $subscriptionID

echo "Deleting an image definition"

az sig image-definition delete -g $sigResourceGroup --gallery-name $sigName --gallery-image-definition $imageDefName --subscription $subscriptionID

echo "Deleting a VM Image"
az sig delete -r $sigName -g $sigResourceGroup

echo "Deleting entire resource group"
az group delete -n $sigResourceGroup -y

echo "Clean up completed !"