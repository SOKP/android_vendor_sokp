PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/sokp/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/sokp/prebuilt/common/bin/50-sokp.sh:system/addon.d/50-sokp.sh \
    vendor/sokp/prebuilt/common/bin/99-backup.sh:system/addon.d/99-backup.sh \
    vendor/sokp/prebuilt/common/etc/backup.conf:system/etc/backup.conf

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# SOKP-specific init file
PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/etc/init.local.rc:root/init.sokp.rc

# Copy latinime for gesture typing
PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/sokp/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/sokp/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/sokp/prebuilt/common/bin/sysinit:system/bin/sysinit

# Embed SuperUser
SUPERUSER_EMBEDDED := true

# Required packages
PRODUCT_PACKAGES += \
    CellBroadcastReceiver \
    Development \
    SpareParts \
    Superuser \
    su

# Screen recorder package and lib
PRODUCT_PACKAGES += \
    ScreenRecorder \
    libscreenrecorder
	
# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker

# Extra Optional packages
PRODUCT_PACKAGES += \
    LatinIME \
    BluetoothExt \
	Eleven \
    LockClock \
	SonicLauncher

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so	

#SOKP Proprietary FIles
PRODUCT_COPY_FILES += \
vendor/sokp/proprietary/fonts/Roboto-Bold.ttf:system/fonts/Roboto-Bold.ttf \
vendor/sokp/proprietary/fonts/Roboto-BoldItalic.ttf:system/fonts/Roboto-BoldItalic.ttf \
vendor/sokp/proprietary/fonts/Roboto-Italic.ttf:system/fonts/Roboto-Italic.ttf \
vendor/sokp/proprietary/fonts/Roboto-Light.ttf:system/fonts/Roboto-Light.ttf \
vendor/sokp/proprietary/fonts/Roboto-LightItalic.ttf:system/fonts/Roboto-LightItalic.ttf \
vendor/sokp/proprietary/fonts/Roboto-Regular.ttf:system/fonts/Roboto-Regular.ttf \
vendor/sokp/proprietary/app/FileManager/MiXplorer_v5.3.8.BETA_B1507071.apk:system/app/FileManager/MiXplorer_v5.3.8.BETA_B1507071.apk \
vendor/sokp/proprietary/app/SOKPStats/SOKPStats.apk:system/app/SOKPStats/SOKPStats.apk \
vendor/sokp/proprietary/priv-app/QuickBoot/QuickBoot.apk:system/priv-app/QuickBoot/QuickBoot.apk \
vendor/sokp/proprietary/app/LayersManager/com.lovejoy777.rroandlayersmanager-12.apk:system/app/LayersManager/com.lovejoy777.rroandlayersmanager-12.apk

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/sokp/overlay/common

# Boot animation include
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/sokp/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
else
PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif
endif

# SOKP Versioning System
PRODUCT_VERSION_MAJOR = L-5.1.1-$(BUILD_ID)
PRODUCT_VERSION_MINOR = R9
PRODUCT_VERSION_MAINTENANCE = 0
ifdef SOKP_BUILD_EXTRA
    SOKP_POSTFIX := -$(SOKP_BUILD_EXTRA)
endif
ifndef SOKP_BUILD_TYPE
    SOKP_BUILD_TYPE := UNOFFICIAL
    PLATFORM_VERSION_CODENAME := UNOFFICIAL
    SOKP_POSTFIX := -$(shell date +"%Y%m%d")
endif


# Set all versions
SOKP_VERSION := SOKP-$(PRODUCT_VERSION_MAJOR)-$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(SOKP_BUILD_TYPE)$(SOKP_POSTFIX)
SOKP_MOD_VERSION := SOKP-$(PRODUCT_VERSION_MAJOR)-$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(SOKP_BUILD_TYPE)$(SOKP_POSTFIX)-$(SOKP_BUILD)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    sokp.ota.version=$(PRODUCT_VERSION_MAJOR)-$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.sokp.version=$(SOKP_VERSION) \
    ro.modversion=$(SOKP_MOD_VERSION) \
    ro.sokp.buildtype=$(SOKP_BUILD_TYPE)

# SOKP Tools
EXTENDED_POST_PROCESS_PROPS := vendor/sokp/tools/sokp_process_props.py
FINISHER_SCRIPT := vendor/sokp/tools/finisher
SQUISHER_SCRIPT := vendor/sokp/tools/squisher

# statistics identity
  PRODUCT_PROPERTY_OVERRIDES += \
  ro.romstats.url=http://statistics.sonic-developers.com/ \
  ro.romstats.name=SOKP \
  ro.romstats.version=-$(PRODUCT_VERSION_MAJOR)-$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
  ro.romstats.askfirst=0 \
  ro.romstats.tframe=1
