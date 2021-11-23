#
# Copyright 2021 The Android Open-Source Project
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

$(call inherit-product, device/google/gs101/factory_common.mk)
$(call inherit-product, device/google/bluejay/device-bluejay.mk)
include device/google/bluejay/audio/bluejay/factory-audio-tables.mk

PRODUCT_NAME := factory_bluejay
PRODUCT_DEVICE := bluejay
PRODUCT_MODEL := Factory build on Bluejay
PRODUCT_BRAND := Android
PRODUCT_MANUFACTURER := Google

DEVICE_PACKAGE_OVERLAYS += device/google/bluejay/factory_bluejay/overlay

# default BDADDR for EVB only
PRODUCT_PROPERTY_OVERRIDES += \
	ro.vendor.bluetooth.evb_bdaddr="22:22:22:33:44:55"

# Factory binary of camera
PRODUCT_PACKAGES += fatp_imx363_hat_tool
