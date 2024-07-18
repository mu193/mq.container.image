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
#                                                                              #
#      ibm-pre-img  : ibm prerequisit images                                   #
#        ibm-pre-dev: ibm prerequisit images for development                   #
#        ibm-pre-prd: ibm prerequisit images for production                    #
#                                                                              #
#      ibm-img:     : build dbag images                                        #
#        ibm-img-dev: build development image                                  #
#        ibm-img-prd: build production image                                   #
#                                                                              #
#      ibm-tag:                                                                #
#        ibm-tag-dev: tag dvelopment image for deployment / push               #
#        ibm-tag-prd: tag production image for deployment / push               #
#                                                                              #
#      ibm-deploy   : ibm-deploy-dev ibm-deploy-prd                            #
#                     all deploy goals include podman login                    #
#                                                                              #
#      ibm-deploy-dev: deploy / push development image to artifactory          #
#      ibm-deploy-prd: deploy / push production image to artifactory           #
#                                                                              #
# ---------------------------------------------------------------------------- #
#                                                                              #
#  Variables:                                                                  #
#    this list includes only variables that will be changed on regular basis   #
#                                                                              #
#    VER : MQ Version in FORM V.M.S.F                                          #
#                                                                              #
#    RELEASE: Used for different images with same MQ Version.                  #
#             Changes if new rpms or other tools are added to the same MQ      #
#             version.                                                         #
#             The release is included in image tag behinde letter 'r'          #
#             It is important to use lower case 'r', upper case is reserved    #
#             for images using C deamon.                                       #
#                                                                              #
# ---------------------------------------------------------------------------- #
#  History:                                                                    #
#  28.06.24 1.0.0 ame Initial version                                          #
#  09.07.24 1.1.0 ame deploy (goal) added                                      #
#  17.07.24 1.2.1 ame download with mqadmin, rename goals to ibm-*             #
#  18.07.24 2.0.0 ame integrate dockmq based images
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
CAT := /usr/bin/cat

JAVA := /usr/bin/java 

HTTP_PRX_IP:=$(subst /,,$(shell echo $(HTTP_PROXY)|$(AWK) -F: '{print $$2}'))
HTTP_PRX_PORT :=        $(shell echo $(HTTP_PROXY)|$(AWK) -F: '{print $$3}')
IBM_USER := mqadmin@deutsche-boerse.com 
#IBM_USER := ales.mertuek@deutsche-boerse.com 

# ------------------------------------------------------------------------------
# artifactory
# ------------------------------------------------------------------------------
LOC_REPO := localhost
REM_REPO := ibmmq-docker.artifactory.dbgcloud.io
MQ_REPO  := $(REM_REPO)/ibmmq-server
OS_REPO  := $(REM_REPO)/ubi8

# -----
# Image name build by IBM Makefile
# -----
IBM_DEV_IMG := ibm-mqadvanced-server-dev
IBM_DEV_TAG := $(VER)-amd64

IBM_PRD_IMG := ibm-mqadvanced-server
IBM_PRD_TAG := $(VER)-amd64

# -----
# Base Image name
# -----
BASE_OS_IMG := ubi-minimal
BASE_OS_TAG := 8.9

# -----
# Image name build by this Makefile
# -----
DBAG_DEV_IMG = ibmmq-dev
DBAG_PRD_IMG = ibmmq-prd

EMP_DEV_IMG := $(LOC_REPO)/$(DBAG_DEV_IMG)
EMP_DEV_TAG := $(VER)-r${RELEASE}-empty

EMP_PRD_IMG := $(LOC_REPO)/$(DBAG_PRD_IMG)
EMP_PRD_TAG := $(VER)-r${RELEASE}-empty

# ------------------------------------------------------------------------------
# static
# ------------------------------------------------------------------------------
EXTRA_RPMS := "less openssl"

################################################################################
#                                  R U L E S                                   #
################################################################################

################################################################################
#   U T I L I T I E S  
################################################################################
help:
	@echo 
	@echo "ibm-pre-img:"
	@echo "    ibm-pre-dev: build ibm provided image development edtion"
	@echo "    ibm-pre-prd: build ibm provided image production"
	@echo 
	@echo "ibm-img:"
	@echo "    ibm-img-dev: build development dbag image based on runmqserver"
	@echo "    ibm-img-prd: build production dbag image based on runmqserver"
	@echo 
	@echo "ibm-tag:"
	@echo "    ibm-tag-dev: tag development dbag image based on runmqserver"
	@echo "    ibm-tag-prd: tag production dbag image based on runmqserver"
	@echo 

vara :
	@echo $(HTTP_PRX_IP)
	@echo $(HTTP_PRX_PORT)

################################################################################
#   R U N M Q S E R V E R   B A S E D   I M A G E S  
################################################################################

# ------------------------------------------------------------------------------
# build ibm images / prerequisits for images
# ------------------------------------------------------------------------------
ibm-pre-img: ibm-pre-dev ibm-pre-prd

ibm-pre-dev:
	@date "+%H:%M:%S start $@" >> .build.time
	make -C mq-container/ build-devserver
	@date "+%H:%M:%S ende  $@" >>  .build.time

ibm-pre-prd: mq-container/downloads/$(VER)-IBM-MQ-Advanced-Non-Install-LinuxX64.tar.gz
	@date "+%H:%M:%S start $@" >> .build.time
	make -C $(dir $(patsubst %/,%,$(dir $^))) MQ_ARCHIVE=$(notdir $(notdir $^)) build-advancedserver
	@date "+%H:%M:%S ende  $@" >> .build.time

mq-container/downloads/$(VER)-IBM-MQ-Advanced-Non-Install-LinuxX64.tar.gz: 
	$(CAT) etc/.passwd |$(JAVA) -Dhttps.proxyHost=$(HTTP_PRX_IP)   \
			-Dhttps.proxyPort=$(HTTP_PRX_PORT)           \
			-jar bin/GetMQFix.jar -u $(IBM_USER) \
			-o $(dir $@) $(basename $(basename $(notdir $@))) 

# ------------------------------------------------------------------------------
# build images
# ------------------------------------------------------------------------------
ibm-img: ibm-img-dev ibm-img-prd

ibm-img-dev : Dockerfile-ibm
	@date "+%H:%M:%S start $@" >> .build.time
	$(call build-mq-ibm,$<,$(EMP_DEV_IMG),$(EMP_DEV_TAG),$(LOC_REPO)/$(IBM_DEV_IMG),$(IBM_DEV_TAG))
	@date "+%H:%M:%S ende  $@" >>  .build.time

ibm-img-prd : Dockerfile-ibm
	@date "+%H:%M:%S start $@" >> .build.time
	$(call build-mq-ibm,$<,$(EMP_PRD_IMG),$(EMP_PRD_TAG),$(LOC_REPO)/$(IBM_PRD_IMG),$(IBM_PRD_TAG))
	@date "+%H:%M:%S ende  $@" >>  .build.time

# ------------------------------------------------------------------------------
# tag images
# ------------------------------------------------------------------------------
ibm-tag: ibm-tag-dev ibm-tag-prd

ibm-tag-dev:
	@date "+%H:%M:%S start $@" >> .build.time
	$(call tag-img,$(LOC_REPO)/$(DBAG_DEV_IMG),$(EMP_DEV_TAG),$(MQ_REPO)/$(DBAG_DEV_IMG):$(EMP_DEV_TAG))
	@date "+%H:%M:%S ende  $@" >> .build.time

ibm-tag-prd:
	@date "+%H:%M:%S start $@" >> .build.time
	$(call tag-img,$(LOC_REPO)/$(DBAG_PRD_IMG),$(EMP_PRD_TAG),$(MQ_REPO)/$(DBAG_PRD_IMG):$(EMP_PRD_TAG))
	@date "+%H:%M:%S ende  $@" >> .build.time

# ------------------------------------------------------------------------------
# deploy to artifactory
# ------------------------------------------------------------------------------
ibm-deploy: ibm-deploy-dev ibm-deploy-prd

ibm-deploy-dev:
	@date "+%H:%M:%S start $@" >> .build.time
	$(DOCKER) login --get-login $(REM_REPO) || $(DOCKER) login $(REM_REPO)
	$(DOCKER) push $(MQ_REPO)/$(DBAG_DEV_IMG):$(EMP_DEV_TAG)
	@date "+%H:%M:%S ende  $@" >> .build.time

ibm-deploy-prd:
	@date "+%H:%M:%S start $@" >> .build.time
	$(DOCKER) login --get-login $(REM_REPO) @@ $(DOCKER) login $(REM_REPO)
	$(DOCKER) push $(MQ_REPO)/$(DBAG_PRD_IMG):$(EMP_PRD_TAG)
	@date "+%H:%M:%S ende  $@" >> .build.time

################################################################################
#   D O C K M Q   B A S E D   I M A G E S  
# involve mq-dock
################################################################################

# ------------------------------------------------------------------------------
# build images
# ------------------------------------------------------------------------------
dbag-img: dbag-img-dev dbag-img-prd

dbag-img-dev:





################################################################################
#                                  M A C R O S                                 #
################################################################################

# ------------------------------------------------------------------------------
# build IBM, runmqserver based image
# ------------------------------------------------------------------------------
define build-mq-ibm
	$(BUILD)            \
	    --file $1       \
	    --tag $2:$3     \
	    --build-arg BASE_MQ_IMG=$4:$5  \
	    --build-arg RPMS=${EXTRA_RPMS}
endef

# ------------------------------------------------------------------------------
# build DBAG, dockmq base image
# ------------------------------------------------------------------------------
define build-mq-dbag
	$(BUILD) build $(OPT)                      \
	    --file $1                              \
	    --tag  $3                              \
	    --build-arg ARCHIVE=$(strip $2)        \
	    --build-arg BASE_RUN_IMG=$(strip $4)   \
	    --build-arg BASE_BUILD_IMG=$(strip $5) \
	    --build-arg MQ_SYS_MOUNT=$(strip $6)   \
	    --build-arg MQ_DATA_MOUNT=$(strip $7)  \
	    --build-arg MQ_LOG_MOUNT=$(strip $8)   \
	    --build-arg MQ_ETC_MOUNT=$(strip $9)   \
	    --build-arg RPMS=$(strip $10)
endef

# ------------------------------------------------------------------------------
# tag any mq image
# ------------------------------------------------------------------------------
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


