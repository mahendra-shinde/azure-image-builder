echo "Import all environment variables ... "
source 01_setenv.sh
echo "Creating the resource group ..."
az group create -n $sigResourceGroup -l $location

echo "Creating a User identity ..."
identityName=aibuserid$(date +'%s')
az identity create -g $sigResourceGroup -n $identityName

echo "Extract the identity name to be used later ..."
imgBuilderCliId=$(az identity show -g $sigResourceGroup -n $identityName --query clientId -o tsv)
imgBuilderId=/subscriptions/$subscriptionID/resourcegroups/$sigResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$identityName
echo "Updating the role-definition.json template with values from env-vars"
if ! [ -s ./role-definition.json ];
then
	echo "Did you forget to clone entire git repository ? you missed role-definition.json file !!"
	return;
fi
imageRoleDefName="azimagedef"$(date +'%s')
cp -f templates/role-definition.json role-definition.json
sed -i -e "s/<subscriptionID>/$subscriptionID/g" role-definition.json
sed -i -e "s/<rgName>/$sigResourceGroup/g" role-definition.json
sed -i -e "s/<imgDefRole>/$imageRoleDefName/g" role-definition.json

echo "Role-definition updated,  now creating the role !"
az role definition create --role-definition ./role-definition.json

echo "Grant permissions to identity created earlier"
az role assignment create --assignee $imgBuilderCliId --role "$imageRoleDefName" --scope /subscriptions/$subscriptionID/resourceGroups/$sigResourceGroup

echo "Creating image definition and gallery..."

az sig create -g $sigResourceGroup --gallery-name $sigName
az sig image-definition create -g $sigResourceGroup --gallery-name $sigName --gallery-image-definition $imageDefName --publisher $myIbPublisher --offer $myOffer --sku 22.04-LTS --os-type Linux

echo "Working on Image template"

cp -f templates/image-template.json image-template.json

sed -i -e "s/<subscriptionID>/$subscriptionID/g" image-template.json
sed -i -e "s/<rgName>/$sigResourceGroup/g" image-template.json
sed -i -e "s/<imageDefName>/$imageDefName/g" image-template.json
sed -i -e "s/<sharedImageGalName>/$sigName/g" image-template.json
sed -i -e "s/<region1>/$location/g" image-template.json
sed -i -e "s/<region2>/$additionalregion/g" image-template.json
sed -i -e "s/<runOutputName>/$runOutputName/g" image-template.json
sed -i -e "s/<imgBuilderId>/$imgBuilderId/g" image-template.json

echo "Submit the configuration to image builder service, please wait ..."
az resource create --resource-group $sigResourceGroup --properties @image-template.json --is-full-object --resource-type Microsoft.VirtualMachineImages/imageTemplates -n image-template-01 -l $location

echo "Launching the builder (Job) and prepare the image"
az resource invoke-action --resource-group $sigResourceGroup --resource-type  Microsoft.VirtualMachineImages/imageTemplates -n image-template-01 --action Run

