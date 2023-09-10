.PHONY: all patch-kernel enable-docker allow-sysvipc default revert

# Usage: make ANDROID_VENDOR=... KERNEL_DIR=...

default: revert patch-kernel allow-sysvipc enable-docker

patch-kernel:
	@echo "Patching kernel..."
	patch -Np1 -i $(realpath kernel-patches/termux-kernel-docker.patch) -d $(ANDROID_BUILD_TOP)/kernel/$(ANDROID_VENDOR)/$(KERNEL_DIR)

allow-sysvipc:
	@echo "Allow SYSVIPC"
	patch -Np1 -i $(realpath optional-patches/allow-sysvipc.patch) -d $(ANDROID_BUILD_TOP)/kernel/configs

enable-docker:
	@echo "Enabling docker..."
	patch -Np1 -i $(realpath optional-patches/docker/$(ANDROID_VENDOR)-$(LINEAGE_BUILD).patch) -d $(ANDROID_BUILD_TOP)/kernel/$(ANDROID_VENDOR)/$(KERNEL_DIR)

sign-build:
	@echo "Placeholder"

revert:
	@echo "Reverting upstream commits..."
	git -C $(ANDROID_BUILD_TOP)/system/netd revert -n \
		dbf5d67951a0cd6e9b76ca2c08cf2b39ae6d708d \
		2a59b3923f0c55a4dc0fdd1c13bd34fd97287d91 \
		5c89ab94a797fce13bf858be0f96541bf9f3bfe7 </dev/null
	git -C $(ANDROID_BUILD_TOP)/frameworks/base revert -n \
		714095c893a93dd60086b935977727672ac02ddc \
		64cef56e1c6890e7b205411ef49a58bf6fbc6d93 \
		b83a568fa1d54926fcc8a5d555cf1645d5ee127a \
		c05f2daa164c10b7ba47fbb5e88db92ec384a342 \
		5a0dc91a17ee20678eaf5fcb92df25b895d839c5 \
		e91d98e3327a805d1914e7fb1617f3ac081c0689 \
		cfd9c1e4c8ea855409db5a1ed8f84f4287a37d75 </dev/null
	git -C $(ANDROID_BUILD_TOP)/packages/modules/Connectivity revert -n \
		386950b4ea592f2a8e4937444955c9b91ff1f277 \
		117a9914771e6ed5ac61facd5cc825c336b387ff \
		1fa42c03891ba203a321b597fb5709e3a9131f0e \
		07c465641ad78e1afa20665bb23f2ae26a0ff6a4 </dev/null
		

