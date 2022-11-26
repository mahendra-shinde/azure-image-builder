# Azure VM Image Builder (Linux)

> This image builder is based on template created by [Daniel Sollondon](https://github.com/danielsollondon)

> Please visit the original github repository from [this](https://github.com/danielsollondon/azvmimagebuilder/tree/master/quickquickstarts/1_Creating_a_Custom_Linux_Shared_Image_Gallery_Image) link.

## How to use this repository

1. Use `WSL bash` (Windows Subsystem for Linux) or Azure cloud shell 
1. Kindly download/clone contents of this repository on your local machine (or cloud-shell).
1. Switch to `linux\scripts` directory

	```bash
	cd linux/scripts
	```

1.	Now, verify if all the required providers are registered on your Azure CLI using my script

	```
	sh ./00az_providers.sh
	```

	> The above script will print state of all these services and register the services which are not already registered.

1.	Now, kindly open file `01_setenv.sh` and update the default values. 

	> You should modify this file NOW !

	```bash
	# Resource group name - ibLinuxGalleryRG in this example
	sigResourceGroup=image-gallery-rg
	# Datacenter location 
	location=westus2
	# Additional region to replicate the image to 
	additionalregion=eastus
	# Name of the Azure Compute Gallery 
	sigName=my-gallery
	# Name of the image definition to be created 
	imageDefName=my-image-def
	# Reference name in the image distribution metadata
	runOutputName=image-1
	subscriptionID=$(az account show --query id --output tsv)
	myIbPublisher=MahendraShinde
	myOffer=JenkinsUbuntu
	```

1.	Once file is modified, import all these variables in your current shell / terminal

	```
	source ./01_setenv.sh
	```

	> If you restart or launch a new shell/terminal for any reason; use above command to import all required variables in new shell.

1.	Now, kindly verify the contents of [role definition](./scripts/role-definition.json) and [image template](./scripts/image-template.json) files.

	> For this demo, no need to update anything in these files !

	> Any invalid value in these files will result in an error in next script.

1.	Launch the script to start building image.

	```bash
	sh ./02_build-image.sh
	```