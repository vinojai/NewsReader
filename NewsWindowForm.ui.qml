import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.2
import QtQuick.Extras 1.4
import QtWebEngine 1.0
import QtGraphicalEffects 1.0

Page {
    id: newsWindow
    property alias headlinesList: headlinesList
    property alias webengineview: webengineview
    property alias backBtn: backBtn
    property alias fwdBtn: fwdBtn
    width: 1024
    height: 768

    Rectangle {
        id: toolRect
        height: 75
        width: newsWindow.width
        color: newsPalette.shadow
    }

    Rectangle {
        id: newsRect
        anchors.top: toolRect.bottom
        anchors.bottom: newsWindow.bottom
        anchors.right: newsWindow.right
        anchors.left: newsWindow.left
        height: newsWindow.height - toolRect.height
        width: newsWindow.width
        color: newsPalette.window

        ListView {
            id: headlinesList
            height: newsRect.height
            width: newsRect.width
            clip: true
            delegate: ItemDelegate {
                id: delegate
                height: 75
                width: parent.width

                MouseArea {
                    id: newsMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                }

                ToolSeparator {
                    id: delegateSep
                    orientation: "Horizontal"
                    anchors.top: parent.top
                    anchors.topMargin: -7
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
                Image {
                    id: image
                    source: modelData.urlToImage
                    height: parent.height
                    width: 100
                }

                Label {
                    id: title
                    anchors.left: image.right
                    anchors.leftMargin: 10
                    anchors.top: delegateSep.bottom
                    anchors.bottom: parent.bottom
                    font.pointSize: 12
                    color: (delegate.highlighted) ? newsPalette.highlightedText : newsPalette.windowText
                    text: modelData.title
                }
                Label {
                    id: author
                    anchors.left: image.right
                    anchors.leftMargin: 10
                    anchors.top: title.bottom
                    anchors.topMargin: 30
                    anchors.bottom: parent.bottom
                    font.pointSize: 8
                    color: title.color
                    text: "By: " + modelData.author
                }
                Connections {
                    target: newsMouseArea
                    onPressed: {
                        headlinesList.width = 200
                        webRectangle.visible = true
                        webengineview.navigationHistory.clear();
                        webengineview.url =  modelData.url
                    }
                    onEntered: {
                        if(webRectangle.visible) {
                            headlinesList.width = newsWindow.width
                            webRectangle.visible = false
                        }
                        delegate.highlighted = true
                    }
                    onExited: {
                        delegate.highlighted = false
                    }
                }
            }
        }

        ToolSeparator {
            orientation: "Vertical"
            anchors.top: headlinesList.top
            anchors.bottom: headlinesList.bottom
            anchors.left: headlinesList.right
        }

        Rectangle {
            id: webRectangle
            anchors.left: headlinesList.right
            anchors.right: newsWindow.right
            anchors.top: newsWindow.top
            anchors.bottom: newsWindow.bottom
            visible: false

            Rectangle {
                id: webTopBar
                height: 30
                width: parent.width
                border {
                    color: newsPalette.windowText
                    width: 2
                }

                RoundButton {
                    id: backBtn
                    anchors.left: parent.left
                    anchors.leftMargin: 25
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    enabled: webengineview.canGoBack
                    height: 20
                    width: 22
                    radius: 5
                    text: "<"
                }
                RoundButton {
                    id: fwdBtn
                    anchors.left: backBtn.right
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    enabled: webengineview.canGoForward
                    height: 20
                    width: 22
                    radius: 5
                    text: ">"
                }

                Flickable {
                    id: flickField
                    anchors.left: fwdBtn.right
                    anchors.leftMargin: 50
                    anchors.top: parent.top
                    anchors.topMargin: 8
                    height: 20
                    width: 600
                    clip: true
                    flickableDirection: Flickable.HorizontalFlick
                    TextInput {
                        id: urlField
                        font.pointSize: 12
                        color: newsPalette.windowText
                        text: webengineview.url
                        readOnly: true
                    }
                }
            }

            WebEngineView {
                id: webengineview
                anchors.top: webTopBar.bottom
                width: newsWindow.width - headlinesList.width
                height: newsWindow.height - webTopBar.height
            }
        }
    }
}
