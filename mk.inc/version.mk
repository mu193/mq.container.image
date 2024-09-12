################################################################################
#                                                                              #
#                             V E R S I O N S . M K                            #
#                                                                              #
#  Description:                                                                #
#    This make include file contains version depended variables.               #
#                                                                              #
################################################################################

#------------------------------------------------------------------------------#
# VER : MQ Version in FORM V.M.S.F                                   #
#                                                              #
#   Used for downloading IBM MQ installation media & naming created imagesa    #
#                                                              #
#------------------------------------------------------------------------------#
VER := 9.3.5.1

#------------------------------------------------------------------------------#
# RELEASE:                            #
#                                                          #
#   Changes if new rpms or other tools are added to the same MQ version.       #
#   The release is included in the image tag behinde letter 'r'/'R'.           #
#   Letter 'r'/'R' is case sensitive.                             #
#     - lower case 'r' is used for IBM / go-lang based deamon                #
#     - upper case 'R' is reserved for DBAG / C based deamon            #
#                                      #
#------------------------------------------------------------------------------#
RELEASE := 1

