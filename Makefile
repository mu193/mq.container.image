################################################################################
#                                                                              #
#         C U S T O M I Z E   I B M   C O N T A I N E R   I M A G E S          #
#                                                                              #
# ---------------------------------------------------------------------------- #
#                                                                              #
#  Customize Images build by IBM Makefile & Dockerfile.                        #
#  This Image uses IBM golang daemon.                                          #
#                                                                              #
# ---------------------------------------------------------------------------- #
#                                                                              #
#  Prerequisites:                                                              #
#                                                                              #
#    Example for MQ 9.3.5.1                                                    #
#      git clone https://github.com/ibm-messaging/mq-container                 #
#      git switch 9.3.5                                                        #
#                                                                              #
#    For development Image:                                                    #
#      * make downloads development image automatically,                       #
#        no manual download necessary                                          #
#    > make || make default || make build-devserver                            #
#      * make builds localhost/ibm-mqadvanced-server-dev                       #
#                                                                              #
#    For Production Image:                                                     #
#      * download installation media from Fix Central to download directory    #
#        https://www.ibm.com/support/fixcentral                                #
#    > make MQ_ARCHIVE=9.3.5.1-IBM-MQ-Advanced-Non-Install-LinuxX64.tar.gz \   #
#           build-advancedserver                                               #
#      * make builds localhost/ibm-mqadvanced-server                           #
#      * you must use MQ_ARCHIVE since default archive                         #
#        IBM_MQ_9.3.5_LINUX_X86-64_NOINST.tar.gz doesn't exist                 #
#      * make builds  localhost/ibm-mqadvanced-server                          #
#                                                                              #
# ---------------------------------------------------------------------------- #
#                                                                              #
#  Description:                                                                #
#                                                                              #
#    Take images described in the prerequisites section as a base images:      #
#      localhost/ibm-mqadvanced-server-dev:9.3.5.1-amd64                       #
#      localhost/ibm-mqadvanced-server:9.3.5.1-amd64                           #
#    and add  further binaries and configuration files.                        #
#    It builds following images:                                               #
#      empty image:                                                            #
#        localhost/ibmmq-dev:9.3.5.1-r0-empty                                  #
#        localhost/ibmmq-prd:9.3.5.1-r0-empty                                  #
#      no other:                                                               #
#                                                                              #
#    Empty image:                                                              #
#     ibm-mqadvanced-server-dev:V.M.S.F-amd64 or                               #
#     ibm-mqadvanced-server:V.M.S.F-amd64                                      #
#     + openssl rpm                                                            #
#     + less rpm                                                               #
#     + create /.editrc                                                        #
#                                                                              #
# ---------------------------------------------------------------------------- #
#                                                                              #
#  Usage:                                                                      #
#    make <goal>                                                               #
#      images: devel prod                                                      #
#      tag:    tag-dev tag-prd                                                 #
#      deploy: deploy-dev deploy-prd                                           #
#              all deploy goals include podman login                           #
#                                                                              #
#      devel: build development image                                          #
#      prod:  build production image                                           #
#                                                                              #
#      tag-dev: tag dvelopment image for deployment / push                     #
#      tag-prd: tag production image for deployment / push                     #
#                                                                              #
#      deploy-dev: deploy / push development image to artifactory              #
#      deploy-prd: deploy / push production image to artifactory               #
#                                                                              #
# ---------------------------------------------------------------------------- #
#                                                                              #
#  Variables:                                                  #
#    this list includes only variables that will be changed on regular basis   #
#                                                                              #
#    VER : MQ Version in FORM V.M.S.F                        #
#                                                                              #
#    RELEASE: Used for different images with same MQ Version.             #
#             Changes if new rpms or other tools are added to the same MQ      #
#             version.                                         #
#             The release is included in image tag behinde letter 'r'          #
#             It is important to use lower case 'r', upper case is reserved    #
#             for images using C deamon.                    #
#  
#                                                                              #
# ---------------------------------------------------------------------------- #
#  History:                                                                    #
#  28.06.24 ame Initial version                                                #
#                                                                              #
################################################################################

################################################################################
#                              V A R I A B L E S                               #
################################################################################

# ------------------------------------------------------------------------------
# Dynamic variables
# ------------------------------------------------------------------------------
RELEASE := 0

VER := 9.3.5.1

# ------------------------------------------------------------------------------
# Commands
# ------------------------------------------------------------------------------
DOCKER := podman
BUILD := $(DOCKER) build
AWK := awk

# ------------------------------------------------------------------------------
# artifactory
# ------------------------------------------------------------------------------
LOC_REPO := localhost
REM_REPO := ibmmq-docker.artifactory.dbgcloud.io/ibmmq-server/

# -----
# Image name build by IBM Makefile
# -----
IBM_DEV_IMG := ibm-mqadvanced-server-dev
IBM_PRD_IMG := ibm-mqadvanced-server

# -----
# Image name build by this Makefile
# -----
DBAG_DEV_IMG = ibmmq-dev
DBAG_PRD_IMG = ibmmq-prd

BASE_DEV_IMG := $(LOC_REPO)/$(IBM_DEV_IMG)
BASE_DEV_TAG := $(VER)-amd64

EMP_DEV_IMG := "$(LOC_REPO)/$(DBAG_DEV_IMG)"
EMP_DEV_TAG := $(VER)-r${RELEASE}-empty

BASE_PRD_IMG := $(LOC_REPO)/$(IBM_PRD_IMG)
BASE_PRD_TAG := $(VER)-amd64

EMP_PRD_IMG := $(LOC_REPO)/$(DBAG_PRD_IMG)
EMP_PRD_TAG := $(VER)-r${RELEASE}-empty

# ------------------------------------------------------------------------------
# static
# ------------------------------------------------------------------------------
EXTRA_RPMS := "less openssl"

################################################################################
#                                  R U L E S                                   #
################################################################################

# ------------------------------------------------------------------------------
# build images
# ------------------------------------------------------------------------------
images: img-dev img-prd

img-dev : Dockerfile 
	$(call build-mq,$<,$(EMP_DEV_IMG),$(EMP_DEV_TAG),$(BASE_DEV_IMG),$(BASE_DEV_TAG))

img-prd : Dockerfile
	$(call build-mq,$<,$(EMP_PRD_IMG),$(EMP_PRD_TAG),$(BASE_PRD_IMG),$(BASE_PRD_TAG))

# ------------------------------------------------------------------------------
# tag images
# ------------------------------------------------------------------------------
tag: tag-dev tag-prd

tag-dev:
	$(call tag-img,$(BASE_DEV_IMG),$(BASE_DEV_TAG),$(EMP_DEV_IMG):$(EMP_DEV_TAG))

tag-prd:
	$(call tag-img,$(BASE_PRD_IMG),$(BASE_PRD_TAG),$(EMP_PRD_IMG):$(EMP_PRD_TAG))

# ------------------------------------------------------------------------------
# deploy to artifactory
# ------------------------------------------------------------------------------
deploy:

################################################################################
#                                  M A C R O S                                 # 
################################################################################
define build-mq
	$(BUILD)            \
	    --tag $2:$3     \
	    --file $1       \
	    --build-arg BASE_MQ_IMG=$4:$5  \
	    --build-arg RPMS=${EXTRA_RPMS}
endef

define tag-img
	$$( $(DOCKER) images        | \
	    ${AWK}  -v IMG="$1"       \
  	      -v TAG="$2"             \
	      -v GOAL=" $3"           \
  	      -v CMD="${DOCKER} tag " \
	    '$$1~IMG && $$2~TAG {print CMD $$3 GOAL}' )
endef

define show-attr
	echo ">$1< >$2< >$3<"
endef	


#	#$(DOCKER) login -u mu193 $(REPOSITORY) 
#tag-dev:
#	$$( $(DOCKER) images | \
#		${AWK}  -v IMG="${BASE_DEV_IMG}"                 \
#			-v TAG="${BASE_DEV_TAG}"                 \
#			-v GOAL=" ${EMP_DEV_IMG}:${EMP_DEV_TAG}" \
#			-v CMD="${DOCKER} tag "                  \
#	 	'$$1~IMG && $$2~TAG {print CMD $$3 GOAL}' )
