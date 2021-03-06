import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.2
import QtQuick.Extras 1.4
import QtWebEngine 1.0
import QtGraphicalEffects 1.0
import QtWebView 1.14
import QtQuick.Controls.Styles 1.4

Page {
    id: newsWindow
    property alias headlinesList: headlinesList
    property alias webengineview: webengineview
    property alias backBtn: backBtn
    property alias fwdBtn: fwdBtn
    property alias newsSelection:newsSelection
    property alias searchBtn: searchBtn
    property alias searchInput: searchInput
    property alias breakingNewsTypeBtn: breakingNewsTypeBtn
    property alias allNewsTypeBtn: allNewsTypeBtn

    Rectangle {
        id: topBarRect
        height: 40
        width: newsWindow.width
        color: newsPalette.shadow

        ///
        /// ICOFONT test
        ///
        Text {
            text: "test"
        }

        ButtonGroup {
            buttons: newsType.children
        }

        ListView {
            id: newsSelection
            model: newsSelectionModel
            orientation: ListView.Horizontal
            width: 425
            height: parent.height - 10
            anchors.left: topBarRect.left
            anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 5
            interactive: false
            delegate: ItemDelegate {
                width: metrics.width + 20
                Text {
                    id: nameText
                    text: name
                    color: index == newsSelection.currentIndex ? "orange" : newsPalette.highlight
                }
                TextMetrics {
                    id: metrics
                    text: name
                }
                Rectangle {
                    id: sep
                    width: metrics.width
                    height: 1
                    anchors.top: nameText.bottom
                    anchors.topMargin: 5
                    border.color: nameText.color
                    color: border.color
                    visible: index == newsSelection.currentIndex
                }
                MouseArea {
                    id: topMouse
                    anchors.fill: nameText
                }
                Connections {
                    target: topMouse
                    onPressed: {
                        newsSelection.currentIndex = index
                        searchInput.text = ""
                        news.setCategory(category)
                        news.getTopHeadlines()
                    }
                }
            }
        }

        TextField {
            id: searchInput
            anchors.left: newsSelection.right
            anchors.leftMargin:  125
            color: "orange"
            placeholderText: "Search"
            placeholderTextColor: newsPalette.highlight
            visible: true
            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 40
                color: "black"
                border.color: newsPalette.highlight
            }
        }

        Row {
            id: newsType
            anchors.verticalCenter: topBarRect.verticalCenter
            anchors.verticalCenterOffset: 5
            anchors.left: searchBtn.right
            anchors.leftMargin: 10
            height: searchInput.height
            visible: searchInput.text.length > 0
            Button {
                id: breakingNewsTypeBtn
                background: Rectangle {
                    implicitWidth: 80
                    implicitHeight: 20
                    color: breaking ? "orange" : "black"
                    border.color: newsPalette.highlight
                }
                contentItem: Text {
                    text: "Breaking News"
                    font: searchBtn.font
                    opacity: enabled ? 1.0 : 0.3
                    color: breaking ? "black" : "orange"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
            }
            Button {
                id: allNewsTypeBtn
                background: Rectangle {
                    implicitWidth: 80
                    implicitHeight: 20
                    color: !breaking ? "orange" : "black"
                    border.color: newsPalette.highlight
                }
                contentItem: Text {
                    text: "All News"
                    font: searchBtn.font
                    opacity: enabled ? 1.0 : 0.3
                    color: !breaking ? "black" : "orange"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
            }
        }

        Button {
            id: searchBtn
            anchors.left: searchInput.right
            anchors.leftMargin: 10
            anchors.top: newsType.top
            text: "Go!"
            visible: searchInput.text.length
            background: Rectangle {
                implicitWidth: 40
                implicitHeight: 20
                color: !searchActive ? "black" : "orange"
                border.color: newsPalette.highlight
            }
            contentItem: Text {
                text: searchBtn.text
                font: searchBtn.font
                opacity: enabled ? 1.0 : 0.3
                color: searchActive ? "black" : "orange"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }


        }
    }

    Rectangle {
        id: newsRect
        anchors.top: topBarRect.bottom
        anchors.bottom: newsWindow.bottom
        anchors.right: newsWindow.right
        anchors.left: newsWindow.left
        height: newsWindow.height - topBarRect.height
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
                    width: 150
                    fillMode: Image.PreserveAspectCrop
                }
                BusyIndicator {
                    id: busy
                    width: 50
                    height: 50
                    anchors.centerIn: image
                    palette.dark: newsPalette.highlight
                    running: image.status === Image.Loading
                }
                Label {
                    id: title
                    anchors.left: image.right
                    anchors.leftMargin: 10
                    anchors.top: delegateSep.bottom
//                    anchors.bottom: parent.bottom
                    font.pointSize: 12
                    color: (delegate.highlighted) ? newsPalette.highlightedText : newsPalette.windowText
                    text: modelData.title
                }
                Label {
                    id: date
                    anchors.left: image.right
                    anchors.top: title.bottom
                    anchors.leftMargin: 10
                    font.pointSize: 12
                    font.italic: true
                    opacity: .50
                    color: (delegate.highlighted) ? newsPalette.highlightedText : newsPalette.windowText
                    text: modelData.date
                }
                Label {
                    id: time
                    anchors.left: date.right
                    anchors.top: title.bottom
                    anchors.leftMargin: 10
                    font.pointSize: 12
                    font.italic: true
                    opacity: .50
                    color: (delegate.highlighted) ? newsPalette.highlightedText : newsPalette.windowText
                    text: modelData.time
                }
                Label {
                    id: author
                    anchors.left: image.right
                    anchors.leftMargin: 10
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
                    font.pointSize: 12
                    font.italic: true
                    opacity: .50
                    color: (delegate.highlighted) ? newsPalette.highlightedText : newsPalette.windowText
                    visible: modelData.title !== "No Results Found" ? true : false
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
