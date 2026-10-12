ARCHS = arm64
TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AstralCheat

AstralCheat_FILES = src/Tweak.xm src/OverlayView.m src/AstralWindow.m src/Memory.m
AstralCheat_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore
AstralCheat_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
AstralCheat_LDFLAGS = -ObjC

include $(THEOS_MAKE_PATH)/tweak.mk
