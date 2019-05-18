PACKAGE_VERSION = 1.0.9

ifeq ($(SIMULATOR),1)
	TARGET = simulator:clang:latest:8.0
	ARCHS = x86_64 i386
else
	TARGET = iphone:clang:latest:5.0
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EmojiResources
EmojiResources_FILES = Tweak.xm
EmojiResources_USE_SUBSTRATE = 1
EmojiResources_EXTRA_FRAMEWORKS = CydiaSubstrate

include $(THEOS_MAKE_PATH)/tweak.mk

ifeq ($(SIMULATOR),1)
setup:: all
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
endif
