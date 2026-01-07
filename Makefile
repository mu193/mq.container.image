################################################################################
#                                                                              #
#         C U S T O M I Z E   I B M   C O N T A I N E R   I M A G E S          #
#                                                                              #
#                                       &                                      #
#                                                                              #
#            B U I L D   D B A G   C O N T A I N E R   I M A G E S             #
#                                                                              #
# ---------------------------------------------------------------------------- #
#                                                                              #
#  This make file builds two different kind of images                          #
#    - IBM images                                                              #
#        daemon based on golang runmqserver                                    #
#        defined by Dockerfile-ibm                                             #
#    - DBAG images                                                             #
#        daemon based on c dockmq                                              #
#        defined by Dockerfile-dbag-dev & Dockecfile-dbag-prd                  #
#                                                                              #
# ---------------------------------------------------------------------------- #
#                                                                              #
# ---------------------------------------------------------------------------- #
#                                                                              #
#                                I   B   M                                     #
#                                                                              #
# ---------------------------------------------------------------------------- #
#                                                                              #
#  IBM image Prerequisites:                                                    #
#                                                                              #
#    Example for MQ 9.3.5.1                                                    #
#      git submoudle add https://github.com/ibm-messaging/mq-container         #
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
#  IBM image description:                                                      #
#                                                                              #
#    Take image(s) described in the prerequisites section as a base image:     #
#      localhost/ibm-mqadvanced-server-dev:9.3.5.1-amd64                       #
#      localhost/ibm-mqadvanced-server:9.3.5.1-amd64                           #
#    and add  further binaries and configuration files.                        #
#    It builds following images:                                               #
#      base image:                                                             #
#        localhost/ibmmq-dev:9.3.5.1-r0-base                                   #
#        localhost/ibmmq-prd:9.3.5.1-r0-base                                   #
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
# ---------------------------------------------------------------------------- #
#                                                                              #
#                                D   B   A   G                                 #
#                                                                              #
# ---------------------------------------------------------------------------- #
#                                                                              #
#  DBAG image Prerequisites:                                                   #
#                                                                              #
#    Development Non-Install Image                                             #
#      Development Edition Image must be put manualy to the download           #
#      directory, the easiest way is by taking the image from IBM branch       #
#                                                                              #
#    Set Submodule for dockmq                                                  #
#      git submoudle add git@github.deutsche-boerse.de:dev/mq.dockmq           #
#                                                                              #
# ---------------------------------------------------------------------------- #
#                                                                              #
#  DBAG image description:                                                     #
#    Base Image defined by                                                     #
#      recommeded is some ubi-minimal image                                    #
#      $(OS_REPO)/$(BASE_OS_IMG):$(BASE_OS_TAG)                                #
#    Image is build in STAGES.                                                 #
#      The tools and mq-install stages base on some ubi8 image                 #
#                                                                              #
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
#      dbag-img-dev: build development image 
#                                                                              #
# ---------------------------------------------------------------------------- #
#                                                                              #
#  Variables:                                                                  #
#    this list includes only variables that will be changed on regular basis   #
#    they are stored in mk.inc/versions.mk
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
#  18.07.24 2.0.0 ame integrate dockmq based images                            #
#  11.09.24 3.0.0 ame - make -C mq-container replace by                        #
#                       mq-container/Dockerfile in build-mq-ibm-raw            #
#                     - move definition of variables to mk.inc/*.mk
#                                                                              #
################################################################################

################################################################################
#                               I N C L U D E S                                #
################################################################################
include mk.inc/version.mk
include mk.inc/artifactory.mk

################################################################################
#                              V A R I A B L E S                               #
################################################################################

# ------------------------------------------------------------------------------
# gmake tricks
# ------------------------------------------------------------------------------
space:=$(subts ,, )
comma:=","

# ------------------------------------------------------------------------------
# Dynamic variables
# ------------------------------------------------------------------------------
ARCH := amd64
PROD_MEDIA := IBM-MQ-Advanced-Non-Install-LinuxX64.tar.gz

# ------------------------------------------------------------------------------
# Long Time Static 
# ------------------------------------------------------------------------------
MQ_DATA_MOUNT := /mq/data
MQ_LOG_MOUNT  := /mq/log
MQ_SYS_MOUNT  := /var/mqm
MQ_ETC_MOUNT  := /mq/etc

# ------------------------------------------------------------------------------
# IBM BASE REPOSITORY
# ------------------------------------------------------------------------------
IBM_BASE_REPO=mq-container

# ------------------------------------------------------------------------------
# Commands
# ------------------------------------------------------------------------------
DOCKER := podman
BUILD := $(DOCKER) build
AWK := awk
CAT := /usr/bin/cat
CP  := /usr/bin/cp
ZIP := /usr/bin/tar cfz
MKDIR := /usr/bin/mkdir -p
JAVA := /usr/bin/java 

HTTP_PRX_IP:=$(subst /,,$(shell echo $(http_proxy)|$(AWK) -F: '{print $$2}'))
HTTP_PRX_PORT :=        $(shell echo $(http_proxy)|$(AWK) -F: '{print $$3}')
IBM_USER := mqadmin@deutsche-boerse.com 

# ------------------------------------------------------------------------------
# artifactory
# ARG BASE_IMAGE=registry.access.redhat.com/ubi8/ubi-minimal
# ARG BASE_TAG=8.9-1161.1715068733
# ARG BUILDER_IMAGE=registry.access.redhat.com/ubi8/go-toolset
# ARG BUILDER_TAG=1.20.12-5.1713833129
# ------------------------------------------------------------------------------
MQ_REPO  := $(MQADM_ARTFCT)/ibmmq-server
OS_REPO  := $(OS_ARTFCT)/$(UBI)

# -----
# Image name build by IBM Makefile (mq-container/Dockerfile-*)
# -----
IBM_DEV_IMG := ibm-mqadvanced-server-dev
IBM_DEV_TAG := $(VER)-$(ARCH)

IBM_PRD_IMG := ibm-mqadvanced-server
IBM_PRD_TAG := $(VER)-$(ARCH)

# -----
# Base Image 
# -----
# BASE_OS_IMG  : base image name; set in versions.mk
# BASE_OS_TAG  : base image tag ; set in versions.mk
# BUILD_GO_IMG : GO builder image name; set in versions.mk
# BUILD_GO_TAG : GO builder image name; set in versions.mk

# -----
# Image name build by this Makefile
# -----
DBAG_DEV_IMG = ibmmq-dev
DBAG_PRD_IMG = ibmmq-prd

EMP_DEV_IMG      := $(LOC_ARTFCT)/$(DBAG_DEV_IMG)
EMP_DEV_IBM_TAG  := $(VER)-ri${RELEASE}-base
EMP_DEV_DBAG_TAG := $(VER)-RD${RELEASE}-base

EMP_PRD_IMG      := $(LOC_ARTFCT)/$(DBAG_PRD_IMG)
EMP_PRD_IBM_TAG  := $(VER)-ri${RELEASE}-base
EMP_PRD_DBAG_TAG := $(VER)-RD${RELEASE}-base

# ------------------------------------------------------------------------------
# static
# ------------------------------------------------------------------------------
EXTRA_RPMS := "less openssl net-tools nmap-ncat"
BUILD_RPMS := "git make gcc"
MQM_USER_ID := 1001
DOCKMQ_DIR := mq.dockmq

################################################################################
#                                  R U L E S                                   #
################################################################################

################################################################################
#   U T I L I T I E S  
################################################################################
help:
	@echo 
	@echo "| ------------------------------------------------------------ |"
	@echo "| runmqserver based images maintaned by IBM                    |"
	@echo "| ------------------------------------------------------------ |"
	@echo 
	@echo "ibm-pre:"
	@echo "    ibm-pre-dev: build development edtion image"
	@echo "    ibm-pre-prd: build production image"
	@echo 
	@echo "ibm-img:"
	@echo "    ibm-img-dev: build dbag customized development image"
	@echo "    ibm-img-prd: build dbag customized prodution image"
	@echo 
	@echo "ibm-tag:"
	@echo "    ibm-tag-dev: tag development dbag image based on runmqserver"
	@echo "    ibm-tag-prd: tag production dbag image based on runmqserver"
	@echo 
	@echo "ibm-deploy:"
	@echo "    ibm-deploy-dev: deploy development image to artifactory"
	@echo "    ibm-deploy-prd: deploy development image to artifactory"
	@echo 
	@echo "| ------------------------------------------------------------ |"
	@echo "| dockmq based images maintaned by DBAG                        |"
	@echo "| ------------------------------------------------------------ |"
	@echo "dbag-img-dev: build development image "
	@echo 
	@echo "dbag-img-dev-force: force build development image "
	@echo 
	@echo "| ------------------------------------------------------------ |"
	@echo "| force commands ignore existing cache,                        |"
	@echo "|       it rebuilds all layers of an image                     |"
	@echo "| ------------------------------------------------------------ |"
	@echo 

################################################################################
#                               I N C L U D E S                                #
################################################################################
include mk.inc/vara.mk

################################################################################
#   R U N M Q S E R V E R   B A S E D   I M A G E S  
################################################################################

# ------------------------------------------------------------------------------
# build ibm images / prerequisits for images
# ------------------------------------------------------------------------------
ibm-pre: ibm-pre-dev ibm-pre-prd

ibm-pre-dev:
	@date "+%H:%M:%S start $@" >> .build.time
	make -C $(IBM_BASE_REPO)/ build-devserver
	@date "+%H:%M:%S ende  $@" >>  .build.time

ibm-pre-prd: $(addprefix $(IBM_BASE_REPO)/,downloads/$(VER)-$(PROD_MEDIA) Dockerfile-server)
	@date "+%H:%M:%S start $@" >> .build.time
	$(call build-mq-ibm-raw,                \
		mq-container/Dockerfile-server, \
		$<,                             \
		$(OS_REPO)/$(BASE_OS_IMG),      \
		$(BASE_OS_TAG),                 \
		$(OS_REPO)/$(BUILDER_GO_IMG),   \
		$(BUILDER_GO_TAG),              \
		$(IBM_PRD_IMG):$(IBM_PRD_TAG),  \
		$(shell git --git-dir=$(IBM_BASE_REPO)/.git config remote.origin.url), \
		$(shell git --git-dir=$(IBM_BASE_REPO)/.git rev-parse HEAD), \
		$(VER),                         \
		$(ARCH)                         )
	@date "+%H:%M:%S ende  $@" >> .build.time

mq-container/downloads/$(VER)-$(PROD_MEDIA): downloads/$(VER)-$(PROD_MEDIA)
	ln $< $@

ifdef http_proxy
downloads/$(VER)-$(PROD_MEDIA):
	[ -d $(dirname $@) ] && mkdir -p $@ 
	$(CAT) etc/.passwd |$(JAVA) -Dhttps.proxyHost=$(HTTP_PRX_IP) \
			-Dhttps.proxyPort=$(HTTP_PRX_PORT)           \
			-jar bin/GetMQFix.jar -u $(IBM_USER)         \
			-x                                           \
			-o $(dir $@) $(basename $(basename $(notdir $@))) 
else
downloads/$(VER)-$(PROD_MEDIA):
	$(error HTTP_PROXY not set )
endif

# ------------------------------------------------------------------------------
# build images
# ------------------------------------------------------------------------------
ibm-img: ibm-img-dev ibm-img-prd

ibm-img-dev : Dockerfile-ibm files/ibm-img.tar.gz
	@date "+%H:%M:%S start $@" >> .build.time
	$(call build-mq-ibm,$<,$(EMP_DEV_IMG),$(EMP_DEV_IBM_TAG),$(LOC_ARTFCT)/$(IBM_DEV_IMG),$(IBM_DEV_TAG),files/ibm-img.tar.gz)
	@date "+%H:%M:%S ende  $@" >>  .build.time

ibm-img-prd : Dockerfile-ibm files/ibm-img.tar.gz
	@date "+%H:%M:%S start $@" >> .build.time
	$(call build-mq-ibm,$<,$(EMP_PRD_IMG),$(EMP_PRD_IBM_TAG),$(LOC_ARTFCT)/$(IBM_PRD_IMG),$(IBM_PRD_TAG),files/ibm-img.tar.gz)
	@date "+%H:%M:%S ende  $@" >>  .build.time

# ------------------------------------------------------------------------------
# tag images
# ------------------------------------------------------------------------------
ibm-tag: ibm-tag-dev ibm-tag-prd

ibm-tag-dev:
	@date "+%H:%M:%S start $@" >> .build.time
	$(call tag-img,$(LOC_ARTFCT)/$(DBAG_DEV_IMG),$(EMP_DEV_IBM_TAG),$(MQ_REPO)/$(DBAG_DEV_IMG):$(EMP_DEV_IBM_TAG))
	@date "+%H:%M:%S ende  $@" >> .build.time

ibm-tag-prd:
	@date "+%H:%M:%S start $@" >> .build.time
	$(call tag-img,$(LOC_ARTFCT)/$(DBAG_PRD_IMG),$(EMP_PRD_IBM_TAG),$(MQ_REPO)/$(DBAG_PRD_IMG):$(EMP_PRD_IBM_TAG))
	@date "+%H:%M:%S ende  $@" >> .build.time

# ------------------------------------------------------------------------------
# deploy to artifactory
# ------------------------------------------------------------------------------
ibm-deploy: ibm-deploy-dev ibm-deploy-prd

ibm-deploy-dev:
	@date "+%H:%M:%S start $@" >> .build.time
	$(DOCKER) login --get-login $(MQADM_ARTFCT) || $(DOCKER) login $(MQADM_ARTFCT)
	$(DOCKER) push $(MQ_REPO)/$(DBAG_DEV_IMG):$(EMP_DEV_IBM_TAG)
	@date "+%H:%M:%S ende  $@" >> .build.time

ibm-deploy-prd:
	@date "+%H:%M:%S start $@" >> .build.time
	$(DOCKER) login --get-login $(MQADM_ARTFCT) || $(DOCKER) login $(MQADM_ARTFCT)
	$(DOCKER) push $(MQ_REPO)/$(DBAG_PRD_IMG):$(EMP_PRD_IBM_TAG)
	@date "+%H:%M:%S ende  $@" >> .build.time

################################################################################
#   D O C K M Q   B A S E D   I M A G E S  
################################################################################

# ------------------------------------------------------------------------------
# build rules
# ------------------------------------------------------------------------------

dbag-img: dbag-img-dev dbag-img-prd

# ------------------------------------------------------------------------------
# force build rules
# ------------------------------------------------------------------------------
OPT   = 
FORCE = --no-cache

dbag-img-force:     OPT += $(FORCE)

dbag-img-prd-force: OPT += $(FORCE)

dbag-img-dev-force: OPT += $(FORCE)


dbag-img-force:     dbag-img

dbag-img-dev-force: dbag-img-dev 

dbag-img-prd-force: dbag-img-prd

# ------------------------------------------------------------------------------
# build images
# MQ_ARCHIVE_DEV is a zip file containing the devel edtion non-install image
# ------------------------------------------------------------------------------
MQ_ARCHIVE_DEV := downloads/9.3.5.1-IBM-MQ-Advanced-for-Developers-Non-Install-LinuxX64.tar.gz

$(MQ_ARCHIVE_DEV): mq-container/$(MQ_ARCHIVE_DEV)
	$(CP) $< $@

files/ibm-img.tar.gz: $(addprefix deploy/,editrc amqsstopchild)
	[[ -d $(dir $@) ]] || $(MKDIR) $(dir $@)
	$(ZIP) $@ $^


dbag-img-dev: Dockerfile-dbag-dev $(MQ_ARCHIVE_DEV)
	$(call build-mq-dbag,$<, $(MQ_ARCHIVE_DEV)                   ,\
			$(EMP_DEV_IMG):$(EMP_DEV_DBAG_TAG)           ,\
			$(OS_REPO)/$(BASE_OS_IMG):$(BASE_OS_TAG)     ,\
			$(OS_REPO)/$(BASE_TOOL_IMG):$(BASE_TOOL_TAG) ,\
			$(MQ_SYS_MOUNT)                              ,\
			$(MQ_DATA_MOUNT)                             ,\
			$(MQ_LOG_MOUNT)                              ,\
			$(MQ_ETC_MOUNT)                              ,\
			$(EXTRA_RPMS)                                ,\
			$(BUILD_RPMS)                                ,\
			$(MQM_USER_ID)                               ,\
			$(DOCKMQ_DIR)  )

################################################################################
#                                  M A C R O S                                 #
################################################################################

# ------------------------------------------------------------------------------
# build IBM, runmqserver based RAW image
#   take base image(s), add runmqserver & MQ
# attributes:
#   01 Dockerfile name
#   02 Archive with IBM MQ Install Media in zip form
#   03 Base OS Image 
#   04 Base OS Tag 
#   05 Base GO Image
#   06 Base GO Tag
#   07 Goal Image Name : Image Tag
#   08 IBM Dockerfile Source e.g. https://github.com/ibm-messaging/mq-container
#   09 IBM Dockerfile Revision
#   10 IBM MQ Version
#   11 Architecture e.g amd64
# ------------------------------------------------------------------------------
define build-mq-ibm-raw
	$(BUILD)                                         \
	  --file $(1)                                    \
	  --tag  $(7)                                    \
          --build-arg IMAGE_TAG=$(subst $(empty) ,,$(7)) \
	  --build-arg MQ_ARCHIVE="$(notdir $(patsubst %/,%,$(dir $2)))/$(notdir $2)" \
	$(if $(strip $(4)),--build-arg BASE_IMAGE=$(subst $(empty) ,,$(3))    \
			   --build-arg BASE_TAG=$(subst $(empty) ,,$(4)),)    \
	$(if $(strip $(6)),--build-arg BUILDER_IMAGE=$(subst $(empty) ,,$(5)) \
	  		   --build-arg BUILDER_TAG=$(subst $(empty) ,,$(6)),) \
	  --build-arg IMAGE_SOURCE=$(subst $(empty) ,,$(8))       \
	  --build-arg IMAGE_REVISION=$(subst $(empty) ,,$(9))     \
	  --label version=$(subst $(empty) ,,$(10))               \
	  --label name=$(word 1,$(subst :, ,$(7)))                \
	  --label build-date=$(shell date +%Y-%m-%dT%H:%M:%S%z)   \
	  --label architecture=$(subst $(empty) ,,$(11))          \
	  --label run="podman run -d -e LICENSE=accept $(7)"      \
	  --label go-builder-image=$(subst $(empty) ,,$(5))       \
	  --label go-builder-release=$(subst $(empty) ,,$(6))     \
	  --label vcs-type=git                                    \
	  --label vcs-url=IMAGE_SOURCE=$(subst $(empty) ,,$(8))   \
	  --label vcs-ref=IMAGE_REVISION=$(subst $(empty) ,,$(9)) \
	  --target mq-server \
	  mq-container/
endef

# ------------------------------------------------------------------------------
# build IBM, runmqserver based image
#   take ibmmq raw image, raname it and add dbag tools
# ------------------------------------------------------------------------------
define build-mq-ibm
	$(BUILD)            \
	    --file $1       \
	    --tag $2:$3     \
	    --build-arg BASE_MQ_IMG=$4:$5  \
	    --build-arg RPMS=$(EXTRA_RPMS) \
	    --build-arg FILES=${6}
endef

# ------------------------------------------------------------------------------
# build DBAG, dockmq base image
# ------------------------------------------------------------------------------
define build-mq-dbag
	$(BUILD) $(OPT)                              \
	    --file $(1)                              \
	    --tag  $(3)                              \
	    --build-arg ARCHIVE=$(strip $(2))        \
	    --build-arg BASE_RUN_IMG=$(strip $(4))   \
	    --build-arg BASE_BUILD_IMG=$(strip $(5)) \
	    --build-arg MQ_SYS_MOUNT=$(strip $(6))   \
	    --build-arg MQ_DATA_MOUNT=$(strip $(7))  \
	    --build-arg MQ_LOG_MOUNT=$(strip $(8))   \
	    --build-arg MQ_ETC_MOUNT=$(strip $(9))   \
	    --build-arg RPMS=$(strip $(10))          \
	    --build-arg BUILD_RPMS=$(strip $(11))    \
            --build-arg MQM_USER_ID=$(strip $(12))   \
	    --build-arg DOCKMQ_DIR=$(strip $(13))
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


