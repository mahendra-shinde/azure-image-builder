# Resource group name - ibLinuxGalleryRG in this example
sigResourceGroup=image-gallery-rg
# Datacenter location 
location=westus2
# Additional region to replicate the image to 
additionalregion=eastus
# Name of the Azure Compute Gallery 
sigName=my_gallery
# Name of the image definition to be created 
imageDefName=my_image_def
# Reference name in the image distribution metadata
runOutputName=image-1
subscriptionID=$(az account show --query id --output tsv)
myIbPublisher=MahendraShinde
myOffer=JenkinsUbuntu