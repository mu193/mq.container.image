# Installing packages in a UBI micro-based MQ image

UBI micro does not include `rpm`, `dnf`, or `microdnf`. Instead of running
a package manager inside the target image, use a separate builder stage
with DNF and install packages into a copy of the target filesystem.

The following Dockerfile example extends an existing MQ image based on
RHEL 10. The builder image, repositories, and `--releasever` must match
the target image's RHEL major version and architecture.

```dockerfile
ARG BASE_MQ_IMG=localhost/ibm-mqadvanced-server:10.0.0.5-amd64
FROM ${BASE_MQ_IMG} AS mqbase

# Must match the target's RHEL major version.
FROM registry.access.redhat.com/ubi10/ubi:10.2 AS packages
USER 0

COPY --from=mqbase / /mnt/rootfs/

RUN dnf --installroot=/mnt/rootfs \
        --releasever=10 \
        --disableplugin=subscription-manager \
        --disablerepo='*' \
        --enablerepo='ubi-*' \
        --setopt=install_weak_deps=False \
        --nodocs \
        install -y less openssl net-tools nmap-ncat \
    && dnf --installroot=/mnt/rootfs clean all

FROM mqbase
USER 0
COPY --from=packages /mnt/rootfs/ /

# Your remaining ADD/install steps go here.
USER 1001
```

## How it works

1. `mqbase` identifies the existing MQ image.
2. The `packages` stage provides DNF and copies the MQ filesystem into
   `/mnt/rootfs`.
3. DNF runs in the builder, resolves dependencies, and installs the requested
   packages into `/mnt/rootfs` using `--installroot`. The target filesystem
   does not need its own package manager.
4. The final stage starts from `mqbase`, preserving its entrypoint, environment,
   and other image configuration, then copies back the populated filesystem.
   The builder's own DNF executables are not copied into the final image.
5. Additional customization runs as root before restoring the MQ runtime user,
   `1001`.

## Repository access

This example disables all repositories and enables only the public UBI
repositories (`ubi-*`). Package availability is limited to those repositories.

For subscribed RHEL or internal repositories, configure repository access,
CA certificates, and any required subscription access in the builder stage.
If access relies on the subscription-manager plugin, do not disable that
plugin. Supply credentials through build secrets rather than storing them
in image layers.

Use repositories for the target's RHEL major version and architecture; do not
mix RHEL 9 packages into a RHEL 10 filesystem. Non-UBI RHEL packages may also
have different subscription and redistribution requirements.
