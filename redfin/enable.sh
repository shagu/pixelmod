#!/bin/bash

# Add pixelmod to vendor product inclusion
cd $ANDROID_BUILD_TOP/vendor/google_devices/redfin/proprietary/
if ! grep -q "pixelmod" device-vendor.mk; then
 echo '$(call inherit-product-if-exists, vendor/pixelmod/$(LOCAL_STEM))' >> device-vendor.mk
fi
cd -

# Remove ugly default apps
cd $ANDROID_BUILD_TOP/build
patch -N -p 1 < $ANDROID_BUILD_TOP/vendor/pixelmod/redfin/patches/remove-apps.patch
cd -

# Remove Launcher3 quicksearch box
cd $ANDROID_BUILD_TOP/packages/apps/Launcher3
patch -N -p 1 < $ANDROID_BUILD_TOP/vendor/pixelmod/redfin/patches/remove-launcher-quicksearch.patch
cd -
