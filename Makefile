VERSION := 3.8
DOCKER_NAME := golden-image
DEBUG :=

DOCKER_ENVS = -e AWS_PROFILE='security-prod' -e AWS_REGION='us-east-1' -e AWS_DEFAULT_REGION='us-east-1'
DOCKER_VOLUMES := -v ${PWD}:/source -v ${HOME}/.aws:/packer/.aws -v ${HOME}/.ssh:/packer/.ssh 
DOCKER_RUN = docker run --rm --name ${DOCKER_NAME} -ti ${DOCKER_VOLUMES} ${DOCKER_ENVS} -w /source 289208114389.dkr.ecr.us-east-1.amazonaws.com/golden-image:${VERSION}
PACKER_BUILD_AMI = packer init application.pkr.hcl; packer build application.pkr.hcl


login:
	eval `aws ecr get-login --no-include-email`

run_docker:
	${DOCKER_RUN} bash

golden-image:
	${PACKER_BUILD_AMI}

# execute "make run_docker" para iniciar o docker 
# execute esse comando de dentro do docker para iniciar o packer "make golden-image"