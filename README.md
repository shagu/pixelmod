![logo](logo.png)

Pixelmod is a custom ROM for the [Pixel 5 (redfin)](https://store.google.com/product/pixel_5) devices, based on [AOSP (Android Open Source Project)](https://source.android.com/) with small modification to make it usable.
By this, it excludes some of the default apps and includes some other prebuilts apps like [F-Droid](https://f-droid.org/).
It's a personal project to make AOSP usable for my needs and to make the compilation of AOSP with custom changes easier.

**Use at your own risk.**

## Modifications

  - Remove Browser2 (WebViewShell)
  - Remove Camera2
  - Remove QuickSearchBox
  - Add F-Droid Prebuilt APK
  - Remove Quick Search from Home Screen
  - Fix broken QCOM vendor binaries

## Install

You can always obtain the latest pre-built ROM at the [Release Page](https://github.com/shagu/pixelmod/releases/).

### Unlock Phone

To enable OEM unlocking on the device:
  - In Settings, tap About phone, then tap Build number seven times.
  - When you see the message You are a developer, tap the back button.
  - Tap Developer options and enable OEM unlocking and USB debugging.

Turn off the phone, press and hold Volume Down, then press and hold Power.

    fastboot flashing unlock

### Install

    fastboot update aosp_redfin-img-eng.bob.zip

## Troubleshooting
You may need to flash the latest Stock ROM first, in order to take care of partitioning if another ROM was in use before.
[Stock ROM Download Page](https://developers.google.com/android/images) ([Direct Download](https://dl.google.com/dl/android/aosp/redfin-rd1a.200810.020-factory-c3ea1715.zip))

## Compile pixelmod (AOSP)

### Setup LXC Build Container (Ubuntu 18.04)

    lxc-create aosp -t download -- -d ubuntu -r bionic -a amd64
    sed -i "s/lxc.net.0.type = empty/lxc.net.0.type = none/g" /var/lib/lxc/aosp/config

    lxc-start aosp
    lxc-attach aosp

    echo 'echo "nameserver 8.8.8.8" > /etc/resolv.conf' >> /root/.bashrc && exit
    lxc-attach aosp

### Install Dependencies

    sudo apt-get update
    sudo apt-get install rsync git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libncurses5 libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig python2.7 repo android-sdk-platform-tools-common vim

### Prepare User

    git config --global user.name "Bob Builder"
    git config --global user.email "build@example.org"

### Fetch AOSP Sources

Check google's build numbers to identify the best tag for pixel 5: [Codenames, Tags, and Build Numbers](https://source.android.com/setup/start/build-numbers)

    mkdir aosp; cd aosp
    repo init -u https://android.googlesource.com/platform/manifest -b android-11.0.0_r22
    repo sync -d -q -c -j8

### Get the Binaries

The latest version of the binaries can be found on the [Driver Binaries](https://developers.google.com/android/drivers) page.
At the time of writing, this is `RQ1A.201205.011` for EU according to [this post](https://support.google.com/pixelphone/thread/87385737?hl=en).

    curl https://dl.google.com/dl/android/aosp/google_devices-redfin-rq1a.201205.011-66234c78.tgz | tar xvz
    ./extract-google_devices-redfin.sh

    curl https://dl.google.com/dl/android/aosp/qcom-redfin-rq1a.201205.011-89247957.tgz | tar xvz
    ./extract-qcom-redfin.sh

    git clone https://github.com/shagu/pixelmod/ vendor/pixelmod


### Configure Environment

    source build/envsetup.sh
    lunch aosp_redfin-userdebug
    vendor/pixelmod/redfin/enable.sh

### Build

    m dist

### Flash via `flashall`
Flash all images:

    export ANDROID_PRODUCT_OUT=/home/lxc/aosp/rootfs/home/ubuntu/aosp/out/target/product/redfin
    fastboot flashall -w
