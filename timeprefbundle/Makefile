TARGET := iphone:clang:latest:13.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = timePrefBundle

timePrefBundle_FILES = HTCRootListController.m
timePrefBundle_FRAMEWORKS = UIKit
timePrefBundle_PRIVATE_FRAMEWORKS = Preferences
timePrefBundle_INSTALL_PATH = /Library/PreferenceBundles

#timePrefBundle_LIBRARIES = gcuniversal
timePrefBundle_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
