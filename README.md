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

   ![Settings](https://api.media.atlassian.com/file/0b0bc245-64a4-40d9-acd2-675d73e6b1d8/image?token=eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIxMDdjMzg0Yy0yOTc1LTQzNTctYWFlNy1jZDNjMTVmMzk2NTYiLCJhY2Nlc3MiOnsidXJuOmZpbGVzdG9yZTpmaWxlOjBiMGJjMjQ1LTY0YTQtNDBkOS1hY2QyLTY3NWQ3M2U2YjFkOCI6WyJyZWFkIl19LCJleHAiOjE1NTI0ODI2NDAsIm5iZiI6MTU1MjQ3OTU4MH0.M8V3jcjfNm39Da-fJzOxa6EeFUNGnUefHYJ4Q2y1HnQ&client=107c384c-2975-4357-aae7-cd3c15f39656&name=Settings%20button.png&max-age=2940&width=347&height=83)

2. Choose Agent Installation.

3. Use the Copy button to copy the access key at the top of the page.

   ![Copy button](https://api.media.atlassian.com/file/17796075-b755-499b-972d-d20ad0d75eeb/image?token=eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIxMDdjMzg0Yy0yOTc1LTQzNTctYWFlNy1jZDNjMTVmMzk2NTYiLCJhY2Nlc3MiOnsidXJuOmZpbGVzdG9yZTpmaWxlOjE3Nzk2MDc1LWI3NTUtNDk5Yi05NzJkLWQyMGFkMGQ3NWVlYiI6WyJyZWFkIl19LCJleHAiOjE1NTI0ODI2NDAsIm5iZiI6MTU1MjQ3OTU4MH0.oNxEaIgveU3yX7WSHjD3u9ik1bFObaOI3OdvVnKRqw4&client=107c384c-2975-4357-aae7-cd3c15f39656&name=agent_installation.jpg&max-age=2940&width=600&height=554)

You can read more about this process in the [Agent Installation: Overview and Key](
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

   ![Explore grouping](https://api.media.atlassian.com/file/75a3010e-3d2e-4135-89fe-b2a1d254d979/image?token=eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIxMDdjMzg0Yy0yOTc1LTQzNTctYWFlNy1jZDNjMTVmMzk2NTYiLCJhY2Nlc3MiOnsidXJuOmZpbGVzdG9yZTpmaWxlOjc1YTMwMTBlLTNkMmUtNDEzNS04OWZlLWIyYTFkMjU0ZDk3OSI6WyJyZWFkIl19LCJleHAiOjE1NTI0ODMwMjYsIm5iZiI6MTU1MjQ3OTk2Nn0.Vt_BBvhOmcguf4bee_CJwEx--06uy6RGG_aV6qj8XcA&client=107c384c-2975-4357-aae7-cd3c15f39656&name=K8s_Grouping.png&max-age=2940&width=2128&height=500)

4. Select an individual container or pod to see details.

   ![Explore individual](https://api.media.atlassian.com/file/169c3613-c4c9-4cbc-8073-f9f0334c1117/image?token=eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIxMDdjMzg0Yy0yOTc1LTQzNTctYWFlNy1jZDNjMTVmMzk2NTYiLCJhY2Nlc3MiOnsidXJuOmZpbGVzdG9yZTpmaWxlOjE2OWMzNjEzLWM0YzktNGNiYy04MDczLWY5ZjAzMzRjMTExNyI6WyJyZWFkIl19LCJleHAiOjE1NTI0ODMwMjYsIm5iZiI6MTU1MjQ3OTk2Nn0.wui_2g59WO9Kr4msKmmrmUflvyIlkF2F2I1UZ-igJ3U&client=107c384c-2975-4357-aae7-cd3c15f39656&name=K8s_Expanded.png&max-age=2940&width=1412&height=500)

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
