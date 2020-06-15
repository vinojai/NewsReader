import QtQuick 2.4
import QtQml 2.15
import QtWebView 1.15

NewsWindowForm {
    Component.onCompleted: {
        print("Calling for News Headlines")
        news.getHeadlines()
    }

    ListModel {
        id: headlineModel
    }

    Connections {
        target: news
        onDataReady: {
            headlinesList.model = JSON.parse(news.readHeadlines())

        }
    }

    Connections {
        target: backBtn

        onClicked: {
            webengineview.goBack()
        }
    }
    Connections {
        target: fwdBtn

        onClicked: {
            webengineview.goForward()
        }
    }
}
