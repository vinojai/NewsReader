import QtQuick 2.4

NewsSplashForm {
    SystemPalette {id: newsPalette; colorGroup: SystemPalette.Active }
    property string apikeykey: news.getApiKeyName()
    property bool isKey: news.isApiKeyExists()
    property bool isKeyValid : true;
    property bool launched: false
    property bool starting: true

    Timer {
        id: isValid
        interval: 1
        repeat: false
        running: true
        onTriggered: {
            /// ???
//            news.setApiKey("");  // Debug only
            /// ???
            news.getTopHeadlines()
        }
    }

    Connections {
        target: news
        onDataReady: {
            isKeyValid = true
            print("KEY SET")
            if(isKeyValid && !launched) {
                launched = true
                stack.push("NewsWindow.qml")
            }
        }
        onDataNotReady: {
           isKeyValid = false
            print("KEY NOT SET")
            if(!starting) {
                kValidTxt.text = ""
                kValidTxt.placeholderText = "Bad Api Key, Try again"
            }
            starting = false
        }
    }

    Connections {
        target: kValidTxt
         onReleased: {
            goBtn.enabled = true
        }
    }

    Connections {
        target: goBtn
        onPressed: {
            news.setApiKey(kValidTxt.text)
            if(news.isApiKeyExists()) {
                news.getHeadlines()
            }
        }
    }
}

