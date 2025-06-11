################################################################################
#                                                                              #
#                             V E R S I O N S . M K                            #
#                                                                              #
#  Description:                                                                #
#    This make include file contains version depended variables.               #
#                                                                              #
#    History:                                                                  #
#      17.09.24 ame initial IBM Dispatched Version MQ + OS + GO                #
#      18.09.24 ame rhel 8.10                                                  #
#      19.09.24 ame - MQ 9.4 & RHEL 9.x                                        #
#                   - empty base_os_tag and builder_go´_tag to                 #
#                     enforce usage of IBM default OS Version                  #
#                                                                              #
################################################################################

#------------------------------------------------------------------------------#
# VER : MQ Version in FORM V.M.S.F                                             #
#                                                                              #
#   Used for downloading IBM MQ installation media & naming created imagesa    #
#                                                                              #
#------------------------------------------------------------------------------#
VER := 9.4.2.1

#------------------------------------------------------------------------------#
# RELEASE:                                                                     #
#                                                                              #
#   Changes if new rpms or other tools are added to the same MQ version.       #
#   The release is included in the image tag behinde letter 'r'/'R'.           #
#   Letter 'r'/'R' is case sensitive.                                          #
#     - lower case 'r' is used for IBM / go-lang based deamon                  #
#     - upper case 'R' is reserved for DBAG / C based deamon                   #
#                                                                              #
#------------------------------------------------------------------------------#
RELEASE := 0

#------------------------------------------------------------------------------#
# IMAGE:                                                                       #
#                                                                              #
#   Major RHL Release is defined by:                                           #
#     - UBI:                                                                   #
#         ubi8 for RHL8                                                        #
#         ubi9 for RHL9                                                        #
#                                                                              #
#   Base images are defined by following variables:                            #
#     - BASE_OS_IMG:                                                           #
#         set in artifactory.mk;                                               #
#         defines base image;                                                  #
#         should be as small as possible e.g ubi-minimal;                      #
#         should be change on major OS Release (UBI8->UBI9)                    #
#     - BASE_OS_TAG:                                                           #
#         set in this file;                                                    #
#         defines the tag of the base OS image;                                #
#         should be adjuted on regular basis                                   #
#           - for critical security patches of OS                              #
#           - for critical security patches of MQ                              #
#           - at least once a year (e.g. 1st quarter)                          #
#                                                                              #
#   Build images are defined by following variables:                           #
#     - BUILD_GO_IMG:                                                          #
#         set in artifactory.mk;                                               #
#         defines stage image used for building GO daemon;                     #
#         should be change on major OS Release (UBI8->UBI9)                    #
#         should be in sync with BASE_OS_IMG                                   #
#     - BUILD_GO_TAG:                                                          #
#         should be adjusted on irregular basis.                               #
#         set in this file;                                                    #
#           - on major MQ LTS version (v.M.s.f)                                #
#           - on major MQ CD version (v.m.S.f)                                 #
#           - at least once a year (e.g 1st quarter)                           #
#                                                                              #
#   ATTENTION:                                                                 #
#     reconsider to use different "staging" BUILD_*_IMG varas,                 #
#     BUILD_GO_IMG for building go daemon and                                  #
#     BUILD_DBAG_TAG for building c daemon                                     #
#                                                                              #
#------------------------------------------------------------------------------#

UBI         := ubi9

BASE_OS_IMG := ubi-minimal
BASE_OS_TAG := 9.6-1749489516

BUILDER_GO_IMG := go-toolset
BUILDER_GO_TAG := 1.23.9-1749636489


