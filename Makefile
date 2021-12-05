TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = SpringBoard

export ARCHS = arm64 arm64e
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = hyperbolictime

hyperbolictime_FILES = Tweak.xm
hyperbolictime_LIBRARIES = gcuniversal

hyperbolictime_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += timeprefbundle
include $(THEOS_MAKE_PATH)/aggregate.mk
