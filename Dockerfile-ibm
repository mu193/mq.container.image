ARG BASE_MQ_IMG
ARG RPMS

FROM $BASE_MQ_IMG

USER 0

RUN  \
     microdnf --disableplugin=subscription-manager install ${RPMS} \
  && microdnf --disableplugin=subscription-manager clean all       \
  && echo "bind -v" > /.editrc 

USER 1001

