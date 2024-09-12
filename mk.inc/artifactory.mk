################################################################################
#                                                                              #
#                          A R T I F A C T O R Y . M K                         #
#                                                                              #
#  Description:                                                                #
#    This make include file contains artifactory and repository                #
#    relevant variables.                                                       #
#                                                                              #
################################################################################

#------------------------------------------------------------------------------#
#  OS_ARTFCT: Operating System Artifactory                                     #
#                                                                              #
#  Artifactory / Repository for base image e.g Red Hat.                        #
#                                                                              #
#------------------------------------------------------------------------------#
OS_ARTFCT := registry.access.redhat.com

#------------------------------------------------------------------------------#
#  MQADM_ARTFCT: STORE Artifacotry                                             #
#                                                                              #
#  Artifactory / Repository for storing images.                                #
#                                                                              #
#------------------------------------------------------------------------------#
MQADM_ARTFCT := ibmmq-docker.artifactory.dbgcloud.io

#------------------------------------------------------------------------------#
#  LOC_ARTFCT: Local (Buffer) Artifactory                                      #
#                                                                              #
#  Working (local) Artifactory / Repository for buffering                      #
#                                                                              #
#------------------------------------------------------------------------------#
LOC_ARTFCT := localhost

