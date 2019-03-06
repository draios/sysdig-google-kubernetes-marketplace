SOLUTION_VERSION=$(shell cat chart/sysdig-agent-mp/Chart.yaml | grep version: | sed 's/.*: //g')
APP_DEPLOYER_IMAGE=$(REGISTRY)/deployer:$(SOLUTION_VERSION)

include ./app.Makefile
include ./crd.Makefile
include ./gcloud.Makefile

.PHONY: submodule/init
submodule/init:
	git submodule sync --recursive
	git submodule update --init --recursive

.PHONY: submodule/init-force
submodule/init-force:
	git submodule sync --recursive
	git submodule update --init --recursive --force

app/build:: .build/sysdig-agent \
			.build/sysdig-agent/deployer

.build/sysdig-agent: | .build
	mkdir -p "$@"

.build/sysdig-agent/deployer:	schema.yaml \
								deployer/* \
								chart/sysdig-agent-mp/* \
								chart/sysdig-agent-mp/templates/* \
								.build/var/REGISTRY
	echo $(SOLUTION_VERSION)
	docker build \
	    --build-arg REGISTRY=$(REGISTRY) \
		--build-arg TAG=$(SOLUTION_VERSION) \
	    --build-arg MARKETPLACE_TOOLS_TAG="$(MARKETPLACE_TOOLS_TAG)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	docker push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"
