# IBM MQ container images

## Download sources
- [Red Hat](https://catalog.redhat.com/search?gs&q=)
- [IBM MQ](https://www.ibm.com/support/fixcentral)

## List of Images

| Name | MQ |OS | GO | Type | RL | Description |
|:----:|----------|----------|----------|-------------| --:|-----------|
|[9.4.1.1-ri0-base](https://artifactory.dbgcloud.io/ui/repos/tree/Properties/ibmmq-docker-local/ibmmq-server/ibmmq-prd/9.4.1.1-ri0-base)|[9.4.1.1](https://www.ibm.com/support/pages/fix-list-ibm-mq-version-94x-continuous-delivery#9411)|[9.7-1764794109](https://catalog.redhat.com/software/containers/ubi9-minimal/61832888c0d15aff4912fe0d)|[1.25.3-1767788444](https://catalog.redhat.com/software/containers/ubi9/go-toolset/61e5c00b4ec9945c18787690)|IBM|1|RHEL 9.7 <br> GO image 1.25.3 <br> nc and netcat rpms added<br>|
|[9.4.1.1-ri0-base](https://artifactory.dbgcloud.io/ui/repos/tree/Properties/ibmmq-docker-local/ibmmq-server/ibmmq-prd/9.4.1.1-ri0-base)|[9.4.1.1](https://www.ibm.com/support/pages/fix-list-ibm-mq-version-94x-continuous-delivery#9411)|[9.5-1731604394](https://catalog.redhat.com/software/containers/ubi9-minimal/61832888c0d15aff4912fe0d)|[1.22.9-1734626445](https://catalog.redhat.com/software/containers/ubi9/go-toolset/61e5c00b4ec9945c18787690)|IBM|0|RHEL 9.5 <br> GO image 1.22.9 <br> |
|[9.4.1.0-ri0-base](https://artifactory.dbgcloud.io/ui/repos/tree/Properties/ibmmq-docker-local/ibmmq-server/ibmmq-prd/9.4.1.0-ri0-base)|[9.4.1.0](https://www.ibm.com/support/pages/fix-list-ibm-mq-version-94x-continuous-delivery#9410)|[9.5-1731604394](https://catalog.redhat.com/software/containers/ubi9-minimal/61832888c0d15aff4912fe0d)|[1.22.9-1734626445](https://catalog.redhat.com/software/containers/ubi9/go-toolset/61e5c00b4ec9945c18787690)|IBM|0|RHEL 9.5 <br> GO image 1.22.9 <br> |
|[9.4.0.6-ri0-base](https://artifactory.dbgcloud.io/ui/repos/tree/General/ibmmq-docker-local/ibmmq-server/ibmmq-prd/9.4.0.6-ri0-base)|[9.4.0.6](https://www.ibm.com/support/pages/fix-list-ibm-mq-version-94-lts)|default|default|IBM|0|MQ 9.4<br>RHEL 9.4|
|[9.4.0.5-ri0-base](https://artifactory.dbgcloud.io/ui/repos/tree/General/ibmmq-docker-local/ibmmq-server/ibmmq-prd/9.4.0.5-ri0-base)|[9.4.0.5](https://www.ibm.com/support/pages/fix-list-ibm-mq-version-94-lts)|default|default|IBM|0|MQ 9.4<br>RHEL 9.4|
|[9.3.5.1-ri2-base](https://artifactory.dbgcloud.io/ui/repos/tree/Properties/ibmmq-docker-local/ibmmq-server/ibmmq-prd/9.3.5.1-ri2-base)|[9.3.5.1](https://www.ibm.com/support/pages/fix-list-ibm-mq-version-93x-continuous-delivery#9351)|[8.10-1052.1724178568](https://catalog.redhat.com/software/containers/ubi8/ubi-minimal/5c359a62bed8bd75a2c3fba8)|[1.21.11-8.1724662611](https://catalog.redhat.com/software/containers/ubi8/go-toolset/5ce8713aac3db925c03774d1)|IBM|2|RHEL 8.10 <br> GO image 1.21 <br> amqsstopchild added|
|[9.3.5.1-ri1-empty](https://artifactory.dbgcloud.io/ui/repos/tree/General/ibmmq-docker-local/ibmmq-server/ibmmq-prd/9.3.5.1-ri1-empty)|[9.3.5.1](https://www.ibm.com/support/pages/fix-list-ibm-mq-version-93x-continuous-delivery#9351)|[8.9-1161.1715068733](https://catalog.redhat.com/software/containers/ubi8/ubi-minimal/5c359a62bed8bd75a2c3fba8?image=6639e6e904a1a78fa9e8e6c4)|[1.20.12-5.1713833129](https://catalog.redhat.com/software/containers/ubi8/go-toolset/5ce8713aac3db925c03774d1?image=662707fa4e3320ef1e1ce82d&architecture=amd64)|IBM|1|empty /tools directory <br> GO builde image label |
|[9.3.5.1-ri0-empty](https://artifactory.dbgcloud.io/ui/repos/tree/General/ibmmq-docker-local/ibmmq-server/ibmmq-prd/9.3.5.1-ri0-empty)|[9.3.5.1](https://www.ibm.com/support/pages/fix-list-ibm-mq-version-93x-continuous-delivery#9351)|[8.9-1161.1715068733](https://catalog.redhat.com/software/containers/ubi8/ubi-minimal/5c359a62bed8bd75a2c3fba8?image=6639e6e904a1a78fa9e8e6c4)|[1.20.12-5.1713833129](https://catalog.redhat.com/software/containers/ubi8/go-toolset/5ce8713aac3db925c03774d1?image=662707fa4e3320ef1e1ce82d&architecture=amd64)|IBM|0|.editrc |
|[9.3.5.0-ri0-empty](https://artifactory.dbgcloud.io/ui/repos/tree/General/ibmmq-docker-local/ibmmq-server/ibmmq-prd/9.3.5.1-r0-empty)|[9.3.5.0](https://www.ibm.com/support/pages/fix-list-ibm-mq-version-93x-continuous-delivery#9350)|[8.9-1161.1715068733](https://catalog.redhat.com/software/containers/ubi8/ubi-minimal/5c359a62bed8bd75a2c3fba8?image=6639e6e904a1a78fa9e8e6c4)|[1.20.12-5.1713833129](https://catalog.redhat.com/software/containers/ubi8/go-toolset/5ce8713aac3db925c03774d1?image=662707fa4e3320ef1e1ce82d&architecture=amd64)|IBM|0|initial image|

## Tips & Tricks
Debug Image:
podman run -d --user root --env  LICENSE=accept  095876d4f5a0
podman exec -it c53f5b1265c15a5ec7aa3196528dfdaed844b283c3b61f81243c3d28aa25b3ab /bin/bash
