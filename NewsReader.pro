QT += quick webengine gui core

CONFIG += c++11, app_bundle

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0


SOURCES += \
        main.cpp \
        news.cpp

RESOURCES += qml.qrc \
    documentation.qrc \
    images.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

FORMS +=

HEADERS += \
    news.h

DISTFILES += \
    icofont/demo.html \
    icofont/fonts/icofont.eot \
    icofont/fonts/icofont.svg \
    icofont/fonts/icofont.ttf \
    icofont/fonts/icofont.woff \
    icofont/fonts/icofont.woff2 \
    icofont/icofont.css \
    icofont/icofont.min.css

