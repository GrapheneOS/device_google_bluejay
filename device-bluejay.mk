#
# Copyright (C) 2021 The Android Open-Source Project
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

TARGET_KERNEL_DIR ?= device/google/bluejay-kernel
TARGET_BOARD_KERNEL_HEADERS := device/google/bluejay-kernel/kernel-headers

$(call inherit-product-if-exists, vendor/google_devices/bluejay/prebuilts/device-vendor-bluejay.mk)
$(call inherit-product-if-exists, vendor/google_devices/gs101/prebuilts/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/gs101/proprietary/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/bluejay/proprietary/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/bluejay/proprietary/bluejay/device-vendor-bluejay.mk)

GOODIX_CONFIG_BUILD_VERSION := g7_trusty
DEVICE_PACKAGE_OVERLAYS += device/google/bluejay/bluejay/overlay

include device/google/bluejay-sepolicy/bluejay-sepolicy.mk
include device/google/bluejay/audio/bluejay/audio-tables.mk
include device/google/gs101/device-shipping-common.mk
include device/google/gs101/fingerprint/udfps_common.mk
include device/google/gs101/telephony/pktrouter.mk
include hardware/google/pixel/vibrator/cs40l26/device.mk
include device/google/gs101/bluetooth/bluetooth.mk

ifeq ($(filter factory_bluejay, $(TARGET_PRODUCT)),)
include device/google/gs101/fingerprint/udfps_shipping.mk
else
include device/google/gs101/fingerprint/udfps_factory.mk
endif

SOONG_CONFIG_lyric_tuning_product := bluejay
SOONG_CONFIG_google3a_config_target_device := bluejay

# Init files
PRODUCT_COPY_FILES += \
	device/google/bluejay/conf/init.blueport.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.blueport.rc \
	device/google/bluejay/conf/init.bluejay.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.bluejay.rc

# Recovery files
PRODUCT_COPY_FILES += \
	device/google/gs101/conf/init.recovery.device.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.bluejay.rc

# insmod files
PRODUCT_COPY_FILES += \
	device/google/bluejay/init.insmod.bluejay.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/init.insmod.bluejay.cfg

# Thermal Config
PRODUCT_COPY_FILES += \
	device/google/bluejay/thermal_info_config_bluejay.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json

# Camera
PRODUCT_COPY_FILES += \
	device/google/bluejay/media_profiles_bluejay.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.camera.extended_launch_boost=1

# Display Config
PRODUCT_COPY_FILES += \
	device/google/bluejay/display_colordata_dev_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/display_colordata_dev_cal0.pb \
	device/google/bluejay/display_golden_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/display_golden_cal0.pb

# NFC
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
	frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
	frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
	frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml \
	frameworks/native/data/etc/android.hardware.nfc.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.uicc.xml \
	frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.ese.xml \
	device/google/bluejay/nfc/libnfc-hal-st.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-hal-st.conf \
	device/google/bluejay/nfc/libnfc-hal-st-GB17L.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-hal-st-GB17L.conf \
	device/google/bluejay/nfc/libnfc-nci.conf:$(TARGET_COPY_OUT_PRODUCT)/etc/libnfc-nci.conf

PRODUCT_PACKAGES += \
	NfcNci \
	Tag \
	android.hardware.nfc@1.2-service.st

# SecureElement
PRODUCT_PACKAGES += \
	android.hardware.secure_element@1.2-service-gto

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.ese.xml \
	frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
        device/google/bluejay/nfc/libse-gto-hal.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libse-gto-hal.conf

DEVICE_MANIFEST_FILE += \
	device/google/bluejay/nfc/manifest_nfc.xml \
	device/google/bluejay/nfc/manifest_se_bluejay.xml

# PowerStats HAL
PRODUCT_SOONG_NAMESPACES += \
    device/google/bluejay/powerstats/bluejay \
    device/google/bluejay

# Increment the SVN for any official public releases
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.build.svn=1

# DCK properties based on target
PRODUCT_PROPERTY_OVERRIDES += \
    ro.gms.dck.eligible_wcc=2

# Trusty liboemcrypto.so
PRODUCT_SOONG_NAMESPACES += vendor/google_devices/bluejay/prebuilts

# Display LBE
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.display.lbe.supported=1

# Bluetooth SAR test tool
PRODUCT_PACKAGES_DEBUG += \
    sar_test

# Bluetooth Tx power caps for bluejay
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bluetooth_power_limits_bluejay_ROW.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits.csv \
    $(LOCAL_PATH)/bluetooth_power_limits_bluejay_US.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_US.csv \
    $(LOCAL_PATH)/bluetooth_power_limits_bluejay_ROW.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_EU.csv \
    $(LOCAL_PATH)/bluetooth_power_limits_bluejay_JP.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_JP.csv

# Bluetooth
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.a2dp_aac.vbr_supported=true

# Bluetooth HAL
PRODUCT_PACKAGES += \
	bt_vendor.conf

# Power HAL ADPF
PRODUCT_PRODUCT_PROPERTIES += \
    vendor.powerhal.adpf.rate=16666666

# Set zram size
PRODUCT_VENDOR_PROPERTIES += \
    vendor.zram.size=2g

# Fingerprint antispoof property
PRODUCT_PRODUCT_PROPERTIES +=\
    persist.vendor.fingerprint.disable.fake.override=none

# Hide cutout overlays
PRODUCT_PACKAGES += \
    NoCutoutOverlay \
    AvoidAppsInCutoutOverlay

# SKU specific RROs
PRODUCT_PACKAGES += \
    SettingsOverlayGB17L

# Set support hide display cutout feature
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_hide_display_cutout=true

# GPS xml
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
	PRODUCT_COPY_FILES += \
		device/google/bluejay/gps.xml.b3:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/gps.xml
else
	PRODUCT_COPY_FILES += \
		device/google/bluejay/gps_user.xml.b3:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/gps.xml
endif
