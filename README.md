# sysdig-google-kubernetes-marketplace

This repository contains instructions and files necessary to run Sysdig via
Google's Hosted Marketplace.

If you would like to read setup instructions about how to install this from the
GCP marketplace, or on how to use the application once it's deployed, please
refer to the [user guide](user-guide.md).

## Getting started

### Setting up your cluster and environment

This guide assumes that you already has a GKE cluster up and running and you
can run `kubectl` commands for that cluster.

Do a one time setup for application CRD:

```shell
make crd/install
```

### Retrieve the Agent Access Key

To retrieve the key or use the agent install code snippets:

1. Log in to Sysdig Monitor or Sysdig Secure (maybe as administrator) and
   select **Settings**.

2. Choose Agent Installation.

3. Use the Copy button to copy the access key at the top of the page.

If you need more help, you can read more about this process in the [Agent Installation: Overview and Key](
https://sysdigdocs.atlassian.net/wiki/spaces/Platform/pages/213352719/Agent+Installation+Overview+and+Key)
documentation page.

## Installing Sysdig

Prior to installing the Sysdig Agent, you will need the agent access key.  You
must use that value in the environment variable `$SYSDIG_AGENT_ACCESS_KEY`

```shell
export SYSDIG_AGENT_ACCESS_KEY=XXX
```

Build and install Sysdig Agent onto your cluster:

```shell
make app/install
```

To delete the installation, run:

```shell
make app/uninstall
```

### Verify Metrics in Sysdig Monitor UI

Once you have deployed the Sysdig Agent, it's time to verify that everything is
working as expected. So, we are going to log in Sysdig Monitor to do the check.

1. Access Sysdig Monitor:

   **SaaS**: https://app.sysdigcloud.com

   Log in with your Sysdig user name and password.

2. Select the **Explore** tab to see if metrics are displayed.

3. To verify that kube state metrics and cluster name are working correctly:

   Select the **Explore tab** and create a grouping by `kubernetes.cluster.name` and `kubernetes.pod.name`.

4. Select an individual container or pod to see details.

Don't rush about getting Kubernetes metadata. Pods, deployments ... appear a
minute or two later than the nodes/containers themselves; if pod names do not
appear immediately, wait and retry the Explore view.

You can read more about verification in the [Verify Metrics in Sysdig Monitor UI section](https://sysdigdocs.atlassian.net/wiki/spaces/Platform/pages/256475257/GKE+Installation+Steps#GKEInstallationSteps-VerifyMetricsinSysdigMonitorUI)
in the documentation pages.

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
