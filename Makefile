.PHONY: all patch-kernel enable-docker

default:
	@echo "Nothing to do"

patch-kernel:
	@echo "Patching kernel..."
	patch -Np1 -i $(realpath kernel-patches/termux-kernel-docker.patch) -d $(ANDROID_BUILD_TOP)/kernel/$(ANDROID_VENDOR)/$(KERNEL_DIR)

enable-docker:
	@echo "Enabling docker..."
	patch -Np1 -i $(realpath optional-patches/docker/$(ANDROID_VENDOR)-$(LINEAGE_BUILD).patch) -d $(ANDROID_BUILD_TOP)/kernel/$(ANDROID_VENDOR)/$(KERNEL_DIR)

sign-build:
	@echo "Placeholder"