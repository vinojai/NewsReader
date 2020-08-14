import QtQuick 2.4
import QtQuick.Controls 2.15

Item {
    id: newsSplash
    width: 1024
    height: 768

    property alias kValidTxt: kValidTxt
    property alias goBtn: goBtn

    Label {
        anchors.verticalCenter: newsSplash.verticalCenter
        anchors.horizontalCenter: newsSplash.horizontalCenter
        anchors.verticalCenterOffset: -50
        font.italic: true
        font.pointSize: 20
        color: newsPalette.windowText
        text: "Powered By:"
    }
    Image {
        id: splashImg
        anchors.verticalCenter: newsSplash.verticalCenter
        anchors.horizontalCenter: newsSplash.horizontalCenter
        source: "newsapi.png"
    }
    Rectangle {
        id: rect
        anchors.top: splashImg.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: newsSplash.horizontalCenter
        height: 80
        width: 420
        visible: !isKeyValid
        Label {
            id: keyNotSet
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
            text: "Looks like your News Api Key has not been set."
        }
        Label {
            id: visit
            anchors.top: keyNotSet.bottom
            anchors.left: rect.left
            text: "Visit "
        }
        Label {
            id: newsapiorg
            anchors.top: keyNotSet.bottom
            anchors.left: visit.right
            color: "blue"
            text: "https://newsapi.org"
        }
        Label {
            id: follow
            anchors.top: keyNotSet.bottom
            anchors.left: newsapiorg.right
            text: " and follow the instructions to obtain your key"
        }

        TextField {
            id: kValidTxt
            anchors.top: follow.bottom
            anchors.topMargin: 5
            width: 300
            placeholderText: qsTr("Enter NewsApi Key")
        }
        Button {
            id: goBtn
            anchors.top: follow.bottom
            anchors.topMargin: 5
            anchors.left: kValidTxt.right
            enabled: false
            text: "GO!"
        }
    }
}
