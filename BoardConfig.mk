# Copyright (C) 2011 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# config.mk
#
# Product-specific compile-time definitions.
#

ifeq ($(TARGET_ARCH),)
TARGET_ARCH := arm
endif

ifeq ($(TARGET_KERNEL_VERSION), 4.9)
TARGET_KERNEL_CROSS_COMPILE_PREFIX := arm-linux-androidkernel-
else
TARGET_KERNEL_CROSS_COMPILE_PREFIX := $(PWD)/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-
endif

BOARD_USES_GENERIC_AUDIO := true

-include $(QCPATH)/common/msm8937_32/BoardConfigVendor.mk
TARGET_COMPILE_WITH_MSM_KERNEL := true
TARGET_KERNEL_APPEND_DTB := true
#TODO: Fix-me: Setting TARGET_HAVE_HDMI_OUT to false
# to get rid of compilation error.
TARGET_HAVE_HDMI_OUT := false
TARGET_USES_OVERLAY := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_NO_BOOTLOADER := false
TARGET_NO_KERNEL := false
TARGET_NO_RADIOIMAGE := true
TARGET_NO_RPC := true
BOOTLOADER_GCC_VERSION := arm-eabi-4.8
BOOTLOADER_PLATFORM := msm8952# use 8952 LK configuration

TARGET_KERNEL_ARCH := arm

# Enables CSVT
TARGET_USES_CSVT := true

#TARGET_GLOBAL_CFLAGS += -mfpu=neon -mfloat-abi=softfp
#TARGET_GLOBAL_CPPFLAGS += -mfpu=neon -mfloat-abi=softfp
TARGET_CPU_ABI  := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a53
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_SMP := true
ARCH_ARM_HAVE_TLS_REGISTER := true

TARGET_HARDWARE_3D := false
TARGET_BOARD_PLATFORM := msm8937
# This value will be shown on fastboot menu
TARGET_BOOTLOADER_BOARD_NAME := QC_Reference_Phone

BOARD_KERNEL_BASE        := 0x80000000
BOARD_KERNEL_PAGESIZE    := 2048
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000
TARGET_USES_UNCOMPRESSED_KERNEL := false
#USE_CLANG_PLATFORM_BUILD := true
# Enables Adreno RS driver
#OVERRIDE_RS_DRIVER := libRSDriver_adreno.so

# Shader cache config options
# Maximum size of the  GLES Shaders that can be cached for reuse.
# Increase the size if shaders of size greater than 12KB are used.
MAX_EGL_CACHE_KEY_SIZE := 12*1024

# Maximum GLES shader cache size for each app to store the compiled shader
# binaries. Decrease the size if RAM or Flash Storage size is a limitation
# of the device.
MAX_EGL_CACHE_SIZE := 2048*1024

# Use signed boot and recovery image
#TARGET_BOOTIMG_SIGNED := true

ifeq ($(ENABLE_AB), true)
# A/B related defines
AB_OTA_UPDATER := true
# Full A/B partiton update set
# AB_OTA_PARTITIONS := xbl rpm tz hyp pmic modem abl boot keymaster cmnlib cmnlib64 system bluetooth
# Subset A/B partitions for Android-only image update
AB_OTA_PARTITIONS ?= boot system
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
TARGET_NO_RECOVERY := true
BOARD_USES_RECOVERY_AS_BOOT := true
else
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
TARGET_RECOVERY_UPDATER_LIBS += librecovery_updater_msm
# Enable System As Root even for non-A/B from P onwards
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
endif

ifeq ($(strip $(TARGET_KERNEL_VERSION)), 4.9)
BOARD_USES_METADATA_PARTITION := true
endif

ifneq ($(wildcard kernel/msm-3.18),)
    ifeq ($(ENABLE_AB),true)
      ifeq ($(ENABLE_VENDOR_IMAGE), true)
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_32/fstabs-3.18/recovery_AB_split_variant.fstab
      else
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_32/fstabs-3.18/recovery_AB_non-split_variant.fstab
      endif
    else
      ifeq ($(ENABLE_VENDOR_IMAGE), true)
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_32/fstabs-3.18/recovery_non-AB_split_variant.fstab
      else
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_32/fstabs-3.18/recovery_non-AB_non-split_variant.fstab
      endif
    endif
else ifneq ($(wildcard kernel/msm-4.9),)
    ifeq ($(ENABLE_AB),true)
      ifeq ($(ENABLE_VENDOR_IMAGE), true)
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_32/fstabs-4.9/recovery_AB_split_variant.fstab
      else
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_32/fstabs-4.9/recovery_AB_non-split_variant.fstab
      endif
    else
      ifeq ($(ENABLE_VENDOR_IMAGE), true)
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_32/fstabs-4.9/recovery_non-AB_split_variant.fstab
      else
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_32/fstabs-4.9/recovery_non-AB_non-split_variant.fstab
      endif
    endif
else
    $(warning "Unknown kernel")
endif

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x02000000
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_USERDATAIMAGE_PARTITION_SIZE := 1971322880
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_OEMIMAGE_PARTITION_SIZE := 268435456
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

ifeq ($(TARGET_KERNEL_VERSION), 4.9)
BOARD_METADATAIMAGE_PARTITION_SIZE := 16777216
BOARD_DTBOIMG_PARTITION_SIZE := 0x0800000
endif

ifeq ($(ENABLE_VENDOR_IMAGE), true)
BOARD_VENDORIMAGE_PARTITION_SIZE := 1073741824
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
endif

ifeq ($(TARGET_KERNEL_VERSION), 4.9)
KASLRSEED_SUPPORT := true
endif

#TARGET_USES_AOSP := true

ifeq ($(TARGET_KERNEL_VERSION), 4.9)

BOARD_VENDOR_KERNEL_MODULES := \
    $(KERNEL_MODULES_OUT)/audio_apr.ko \
    $(KERNEL_MODULES_OUT)/pronto_wlan.ko \
    $(KERNEL_MODULES_OUT)/audio_q6_notifier.ko \
    $(KERNEL_MODULES_OUT)/audio_adsp_loader.ko \
    $(KERNEL_MODULES_OUT)/audio_q6.ko \
    $(KERNEL_MODULES_OUT)/audio_usf.ko \
    $(KERNEL_MODULES_OUT)/audio_pinctrl_wcd.ko \
    $(KERNEL_MODULES_OUT)/audio_swr.ko \
    $(KERNEL_MODULES_OUT)/audio_wcd_core.ko \
    $(KERNEL_MODULES_OUT)/audio_swr_ctrl.ko \
    $(KERNEL_MODULES_OUT)/audio_wsa881x.ko \
    $(KERNEL_MODULES_OUT)/audio_wsa881x_analog.ko \
    $(KERNEL_MODULES_OUT)/audio_platform.ko \
    $(KERNEL_MODULES_OUT)/audio_cpe_lsm.ko \
    $(KERNEL_MODULES_OUT)/audio_hdmi.ko \
    $(KERNEL_MODULES_OUT)/audio_stub.ko \
    $(KERNEL_MODULES_OUT)/audio_wcd9xxx.ko \
    $(KERNEL_MODULES_OUT)/audio_mbhc.ko \
    $(KERNEL_MODULES_OUT)/audio_wcd9335.ko \
    $(KERNEL_MODULES_OUT)/audio_wcd_cpe.ko \
    $(KERNEL_MODULES_OUT)/audio_digital_cdc.ko \
    $(KERNEL_MODULES_OUT)/audio_analog_cdc.ko \
    $(KERNEL_MODULES_OUT)/audio_native.ko \
    $(KERNEL_MODULES_OUT)/audio_machine_sdm450.ko \
    $(KERNEL_MODULES_OUT)/audio_machine_ext_sdm450.ko
endif

ifeq ($(strip $(TARGET_KERNEL_VERSION)), 4.9)
     BOARD_KERNEL_CMDLINE := console=ttyMSM0,115200,n8 androidboot.console=ttyMSM0 androidboot.hardware=qcom user_debug=30 msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlycon=msm_hsl_uart,0x78B0000 vmalloc=300M firmware_class.path=/vendor/firmware_mnt/image androidboot.usbconfigfs=true loop.max_part=7
else ifeq ($(strip $(TARGET_KERNEL_VERSION)), 3.18)
     BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom androidboot.memcg=false user_debug=30 msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlycon=msm_hsl_uart,0x78B0000 firmware_class.path=/vendor/firmware_mnt/image loop.max_part=7 androidboot.usbconfigfs=false
endif

BOARD_SECCOMP_POLICY := device/qcom/msm8937_32/seccomp

BOARD_EGL_CFG := device/qcom/msm8937_32/egl.cfg


# Enable suspend during charger mode
BOARD_CHARGER_ENABLE_SUSPEND := true
BOARD_CHARGER_DISABLE_INIT_BLANK := true

# Add NON-HLOS files for ota upgrade
ADD_RADIO_FILES ?= true

# Added to indicate that protobuf-c is supported in this build
PROTOBUF_SUPPORTED := false
TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
TARGET_USES_QCOM_DISPLAY_BSP := true
TARGET_USES_HWC2 := true
TARGET_USES_GRALLOC1 := true
TARGET_USES_COLOR_METADATA := true

#TARGET_RECOVERY_UPDATER_LIBS := librecovery_updater_msm
TARGET_INIT_VENDOR_LIB := libinit_msm
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/

#Add support for firmare upgrade on msm8937
HAVE_SYNAPTICS_I2C_RMI4_FW_UPGRADE := true

#add suffix variable to uniquely identify the board
TARGET_BOARD_SUFFIX := _32

#Use dlmalloc instead of jemalloc for mallocs
#MALLOC_IMPL := dlmalloc
MALLOC_SVELTE := true

#Enable HW based full disk encryption
TARGET_HW_DISK_ENCRYPTION := true

TARGET_CRYPTFS_HW_PATH := device/qcom/common/cryptfs_hw

#Enable SSC Feature
TARGET_USES_SSC := true

#PCI RCS
TARGET_USES_PCI_RCS := false

# Enable sensor multi HAL
USE_SENSOR_MULTI_HAL := true

#Enable peripheral manager
TARGET_PER_MGR_ENABLED := true

TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true

DEX_PREOPT_DEFAULT := nostripping

# Enable dex pre-opt to speed up initial boot
ifneq ($(TARGET_USES_AOSP),true)
  ifeq ($(HOST_OS),linux)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
      WITH_DEXPREOPT_PIC := true
      ifneq ($(TARGET_BUILD_VARIANT),user)
        # Retain classes.dex in APK's for non-user builds
        DEX_PREOPT_DEFAULT := nostripping
      endif
    endif
  endif
endif

FEATURE_QCRIL_UIM_SAP_SERVER_MODE := true

BOARD_HAL_STATIC_LIBRARIES := libhealthd.msm

ifeq ($(strip $(TARGET_KERNEL_VERSION)), 4.9)
PMIC_QG_SUPPORT := true
endif

#Generate DTBO image
ifeq ($(TARGET_KERNEL_VERSION), 4.9)
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_SYSTEMSDK_VERSIONS :=28
BOARD_VNDK_VERSION := current
TARGET_USES_64_BIT_BINDER := true
endif

# Set Header version for bootimage
BOARD_BOOTIMG_HEADER_VERSION := 1
BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOTIMG_HEADER_VERSION)

ifneq ($(ENABLE_AB),true)
  ifeq ($(BOARD_KERNEL_SEPARATED_DTBO),true)
    # Enable DTBO for recovery image
    BOARD_INCLUDE_RECOVERY_DTBO := true
  endif
endif

ifeq ($(TARGET_KERNEL_VERSION), 4.9)
TARGET_USES_LM := true
endif
