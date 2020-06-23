import QtQuick 2.4
import QtQml 2.15
import QtWebView 1.15

NewsWindowForm {
    SystemPalette {id: newsPalette; colorGroup: SystemPalette.Active }
    Component.onCompleted: {
        print("Calling for News Headlines")
        news.getHeadlines()
        newsSelection.currentIndex = 0
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

    ListModel {
        id: newsSelectionModel

        ListElement {
            name: "Home"
            key: "BREAKING"
        }
        ListElement {
            name: "Business"
            key: "BUSINESS"
        }
        ListElement {
            name: "Technology"
            key: "TECHNOLOGY"
        }
        ListElement {
            name: "Sports"
            key: "SPORTS"
        }
    }
}
