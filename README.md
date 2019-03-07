# sysdig-google-kubernetes-marketplace

This repository contains instructions and files necessary to run Sysdig via
Google's Hosted Marketplace.

If you would like to read setup instructions about how to install this from the
GCP marketplace, or on how to use the application once it's deployed, please
refer to the user guide.

## Getting started

###  Updating git submodules

This repo contains git submodules corresponding to dependent Google code repos.
You can run the following commands to make sure submodules are populated with
proper code.

```shell
git submodule sync --recursive
git submodule update --recursive --init --force
```

Or using the Makefile

```shell
make submodule/init-force
```

### Setting up your cluster and environment

This guide assumes that you already has a GKE cluster up and running and you
can run `kubectl` commands for that cluster.

Do a one time setup for application CRD:

```shell
make crd/install
```

## Installing Sysdig

Prior to installing the Sysdig Agent, you will need an access key.  You must to
use that value in the environment variable `$SYSDIG_AGENT_ACCESS_KEY`

Build and install Sysdig Agent onto your cluster:

```shell
make app/install
```

To delete the installation, run:

```shell
make app/uninstall
```

## Building the deployment container

Apps must supply a deployment container image ("deployer") which is used in
UI-based deployment. This image should extend from one of the base images
provided in the marketplace-k8s-app-tools repository.

The deployment container uses [Helm Chart for Sysdig](https://hub.helm.sh/charts/stable/sysdig)
but it downloads the dependency in build time, so that, you need
[Helm](https://helm.sh/) installed in the machine where the deployment container
is built.

Once you have the Helm dependency resolved, you can build and push the
deployment container just running:

```shell
make app/build
```
