#!/bin/bash

cd $ANDROID_BUILD_TOP/vendor/google_devices/redfin/proprietary/
if ! grep -q "pixelmod" device-vendor.mk; then
 echo '$(call inherit-product-if-exists, vendor/pixelmod/$(LOCAL_STEM))' >> device-vendor.mk
fi
cd -
