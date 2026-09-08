SHELL := pwsh
ENV ?= dev
TF_DIR := iac/terraform/environments/$(ENV)

.PHONY: fmt init validate plan apply destroy lint test build up down

fmt:
	terraform fmt -recursive iac/terraform

init:
	terraform -chdir=$(TF_DIR) init

validate: init
	terraform -chdir=$(TF_DIR) validate

plan: validate
	terraform -chdir=$(TF_DIR) plan -var-file=terraform.tfvars -out=tfplan

apply: validate
	terraform -chdir=$(TF_DIR) apply tfplan

destroy: validate
	terraform -chdir=$(TF_DIR) destroy -var-file=terraform.tfvars

lint:
	terraform fmt -check -recursive iac/terraform

test: validate

build:
	@Write-Output 'No service image is defined yet; infrastructure validation is the build gate.'

up: apply

down: destroy
