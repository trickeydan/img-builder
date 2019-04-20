BASE_IMG_URL=https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2019-04-09/2019-04-08-raspbian-stretch-lite.zip
BASE_IMG_FILE=2019-04-08-raspbian-stretch-lite.zip
BASE_IMG_HASH=03ec326d45c6eb6cef848cf9a1d6c7315a9410b49a276a6b28e67a40b11fdfcf
BASE_IMG_NAME=2019-04-08-raspbian-stretch-lite.img
DEVROOT=/dev/sda2
DEVTREE=versatile-pb.dtb
KERNEL=kernel.bin


all: run

$(BASE_IMG_FILE):
	rm -f $(BASE_IMG_FILE)
	wget $(BASE_IMG_URL)
	echo "$(BASE_IMG_HASH) $(BASE_IMG_FILE)" | sha256sum --check

$(BASE_IMG_NAME): $(BASE_IMG_FILE)
	unzip -fj $(BASE_IMG_FILE)

.PHONY: clean

run: $(BASE_IMG_NAME) $(KERNEL)
	qemu-system-arm -M versatilepb -cpu arm1176 -m 256 -hda $(BASE_IMG_NAME) -net nic -net user -dtb $(DEVTREE) -kernel $(KERNEL) -append 'root=$(DEVROOT) panic=1' -no-reboot

clean:
	rm -f $(BASE_IMG_FILE) $(BASE_IMG_NAME)