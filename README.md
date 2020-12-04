# pixelmod

Pixelmod is a small AOSP modification for the Pixel 5 (redfin) devices, that excludes some of the default apps and includes some other prebuilts apps like F-Droid.
It's not an official ROM or anything, it's just my personal modification to make the build easier for me.

## Modifications

  - Remove Browser2 (WebViewShell)
  - Remove Camera2
  - Remove QuickSearchBox
  - Add F-Droid Prebuilt APK

## Build AOSP (pixelmod)

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
    repo init -u https://android.googlesource.com/platform/manifest -b android-11.0.0_r14
    repo sync -d -q -c -j8

### Get the Binaries

The latest version of the binaries can be found on the [Driver Binaries](https://developers.google.com/android/drivers) page.
At the time of writing, this is `RD1A.201105.003.B1` for EU according to [this post](https://support.google.com/pixelphone/thread/80591482?hl=en).

    curl https://dl.google.com/dl/android/aosp/google_devices-redfin-rd1a.201105.003.b1-5dbe21dd.tgz | tar xvz
    ./extract-google_devices-redfin.sh

    curl https://dl.google.com/dl/android/aosp/qcom-redfin-rd1a.201105.003.b1-675b4528.tgz | tar xvz
    ./extract-qcom-redfin.sh

    git clone https://github.com/shagu/pixelmod/ vendor/pixelmod


### Configure Environment

    source build/envsetup.sh
    vendor/pixelmod/redfin/enable.sh
    lunch aosp_redfin-userdebug

### Build

    m dist

### Flash

To enable OEM unlocking on the device:
  - In Settings, tap About phone, then tap Build number seven times.
  - When you see the message You are a developer, tap the back button.
  - Tap Developer options and enable OEM unlocking and USB debugging.

Turn off the phone, press and hold Volume Down, then press and hold Power.

    fastboot flashing unlock

Flash all images:

    export ANDROID_PRODUCT_OUT=/home/lxc/aosp/rootfs/home/ubuntu/aosp/out/target/product/redfin
    fastboot flashall -w

### Update/Flash

    fastboot update aosp_redfin-img-eng.bob.zip

### Troubleshooting
You may need to flash the latest Stock ROM first, in order to take care of partitioning if another ROM was in use before.
[Stock ROM Download Page](https://developers.google.com/android/images) ([Direct Download](https://dl.google.com/dl/android/aosp/redfin-rd1a.200810.020-factory-c3ea1715.zip))
