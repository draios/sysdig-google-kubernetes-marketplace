TAG=$(shell cat chart/sysdig-agent-mp/Chart.yaml | grep version: | sed 's/.*: //g')
APP_DEPLOYER_IMAGE=$(REGISTRY)/agent/deployer:$(TAG)

MINOR_TAG=$(shell echo $(TAG) | cut -d. -f1-2)
APP_DEPLOYER_IMAGE_MINOR=$(REGISTRY)/agent/deployer:$(MINOR_TAG)

SYSDIG_AGENT_TAG=11.3.0

include ./app.Makefile
include ./crd.Makefile
include ./gcloud.Makefile

$(info ---- TAG = $(TAG))
$(info ---- MINOR_TAG = $(MINOR_TAG))
$(info ---- SYSDIG_AGENT_TAG = $(SYSDIG_AGENT_TAG))

APP_NAME ?= sysdig-agent-testrun

APP_PARAMETERS ?= { \
	"name": "$(APP_NAME)", \
	"namespace": "$(NAMESPACE)", \
	"image": "docker.io/sysdig/agent:$(SYSDIG_AGENT_TAG)", \
	"sysdig.sysdig.accessKey": "${SYSDIG_AGENT_ACCESS_KEY}" \
}

app/build:: .build/sysdig-agent \
			.build/sysdig-agent/deployer  \
			.build/sysdig-agent/agent

.build/sysdig-agent: | .build
	mkdir -p "$@"

.build/sysdig-agent/deployer:	schema.yaml \
								deployer/* \
								chart/sysdig-agent-mp/* \
								chart/sysdig-agent-mp/charts/sysdig-$(TAG).tgz \
								chart/sysdig-agent-mp/templates/* \
								.build/var/REGISTRY
	docker build \
		--build-arg REGISTRY=$(REGISTRY) \
		--build-arg TAG=$(TAG) \
		--build-arg MARKETPLACE_TOOLS_TAG="$(MARKETPLACE_TOOLS_TAG)" \
		--tag "$(APP_DEPLOYER_IMAGE)" \
		-f deployer/Dockerfile \
		.
	docker tag "$(APP_DEPLOYER_IMAGE)" "$(APP_DEPLOYER_IMAGE_MINOR)"
	docker push "$(APP_DEPLOYER_IMAGE)"
	docker push "$(APP_DEPLOYER_IMAGE_MINOR)"
	@touch "$@"

.build/sysdig-agent/agent:	.build/var/REGISTRY \
							.build/var/TAG \
							| .build/sysdig-agent
	docker pull docker.io/sysdig/agent:$(SYSDIG_AGENT_TAG)
	docker tag docker.io/sysdig/agent:$(SYSDIG_AGENT_TAG) \
	    "$(REGISTRY)/agent:$(TAG)"
	docker tag docker.io/sysdig/agent:$(SYSDIG_AGENT_TAG) \
	    "$(REGISTRY)/agent:$(MINOR_TAG)"
	docker push "$(REGISTRY)/agent:$(TAG)"
	docker push "$(REGISTRY)/agent:$(MINOR_TAG)"
	@touch "$@"

chart/sysdig-agent-mp/charts/sysdig-$(TAG).tgz:
	helm dependency build chart/sysdig-agent-mp
