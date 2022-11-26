vmimage_provider=$(az provider show -n Microsoft.VirtualMachineImages --query "registrationState" -o tsv)
keyvault_provider=$(az provider show -n Microsoft.KeyVault --query "registrationState" -o tsv)
compute_provider=$(az provider show -n Microsoft.Compute --query "registrationState" -o tsv)
storage_provider=$(az provider show -n Microsoft.Storage --query "registrationState" -o tsv)
network_provider=$(az provider show -n Microsoft.Network --query "registrationState" -o tsv)
echo  "Verification completed ...."
echo  "The results are : "
echo  ""
echo "+------------------+-----------------------+"
echo "| Provider Name    |  Registration State   |"
echo "+------------------+-----------------------+"
echo "| VMImage Provider | $vmimage_provider            |"
echo "| KeyVault Provider| $keyvault_provider            |"
echo "| Compute Provider | $compute_provider            |"
echo "| Storage Provider | $storage_provider            |"
echo "| Network Provider | $network_provider            |"
echo "+------------------+-----------------------+"

echo "\n\r Registering missing providers ..."
count=0

if [ "$vmimage_provider" = "Not Registered" ];
then
	az provider register -n Microsoft.VirtualMachineImages
	count=$count+1
fi
if [ "$compute_provider" = "Not Registered" ];
then
	az provider register -n Microsoft.Compute
	count=$count+1
fi
if [ "$keyvault_provider" = "Not Registered" ];
then
	az provider register -n Microsoft.KeyVault
	count=$count+1
fi
if [ "$storage_provider" = "Not Registered" ];
then
	az provider register -n Microsoft.Storage
	count=$count+1
fi
if [ "$network_provider" = "Not Registered" ];
then
	az provider register -n Microsoft.Network
	count=$count+1
fi

if  [ $count -eq 0 ];
then
	echo "All the providers were already registered !"
else
	echo "$count providers are now registered !"
fi