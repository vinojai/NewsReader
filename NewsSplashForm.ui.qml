import QtQuick 2.4
import QtQuick.Controls 2.15

Item {
    id: newsSplash
    width: 1024
    height: 768

    Label {
        anchors.verticalCenter: newsSplash.verticalCenter
        anchors.horizontalCenter: newsSplash.horizontalCenter
        anchors.verticalCenterOffset: -50
        font.italic: true
        font.pointSize: 20
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
        height: 70
        width: 420
        visible: !isKey
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
            anchors.top: keyNotSet.bottom
            anchors.left: newsapiorg.right
            text: " and follow the instructions to obtain your key"
        }
        Label {
            id: env
            x: 0
            y: 32
            anchors.top: visit.bottom
            anchors.left: rect.left
            leftPadding: 54
            text: "Then set the Environment variable "
        }
        Label {
            id: key
            anchors.top: env.top
            anchors.left: env.right
            font.italic: true
            text: apikeykey
        }
        Label {
            anchors.top: key.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: "with your Api key value and restart this app."
        }
    }
}
