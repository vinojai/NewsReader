import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15

Window {
    SystemPalette { id: newsPalette; colorGroup: SystemPalette.Active }
    id: newsSplash
    visible: true
    width: 1024
    height: 768
    color: newsPalette.dark
    title: qsTr("And now the News")

    Component.onCompleted: {
        newsHeadlines.running = news.isApiKeySet()
    }

    StackView {
        id: stack
        initialItem: "NewsSplash.qml"
        anchors.fill: parent

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 500
            }
        }
    }

    Timer {
        id: newsHeadlines
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            stack.push("NewsWindow.qml")
        }
    }
}
