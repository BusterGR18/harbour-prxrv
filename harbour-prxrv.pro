# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-prxrv

CONFIG += c++11

TEMPLATE=app
#load Ubuntu specific features
load(ubuntu-click)

# specify the manifest file, this file is required for click
# packaging and for the IDE to create runconfigurations
UBUNTU_MANIFEST_FILE=manifest.json.in


QT += gui qml quick

# specifies all translations files and makes sure they are
# compiled and installed into the right place in the click package
UBUNTU_PO_FILES+=$$files(po/*.po)

QT += gui qml quick quickcontrols2

HEADERS += \
    src/pxvrequest.h \
    src/requestmgr.h \
    src/cachemgr.h \
    src/utils.h \
    src/pxvimageprovider.h \
    src/pxvnamfactory.h \
    src/pxvnetworkaccessmanager.h

SOURCES += src/harbour-prxrv.cpp \
    src/pxvrequest.cpp \
    src/requestmgr.cpp \
    src/cachemgr.cpp \
    src/utils.cpp \
    src/pxvimageprovider.cpp \
    src/pxvnamfactory.cpp \
    src/pxvnetworkaccessmanager.cpp

RESOURCES += harbour-prxrv.qrc

RESOURCES += qml/components


OTHER_FILES += rpm/harbour-prxrv.yaml \
    rpm/harbour-prxrv.changes \
    translations/*.ts \
    harbour-prxrv.apparmor \
    harbour-prxrv.desktop \
    harbour-prxrv.png

config_files.path = /
config_files.files = $${OTHER_FILES}

INSTALLS += config_files

# Default rules for deployment.
target.path = /
INSTALLS+=target

# to disable building translations every time, comment out the
# following CONFIG line
#CONFIG += sailfishapp_i18n
#
#TRANSLATIONS += translations/harbour-prxrv-zh_CN.ts
