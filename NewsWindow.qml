import QtQuick 2.4
import QtQml 2.15
import QtWebView 1.15

NewsWindowForm {

    property bool breaking: true
    property int displayHeight
    property int displayWidth

    SystemPalette {id: newsPalette; colorGroup: SystemPalette.Active }
    Component.onCompleted: {
        print("Calling for News Headlines")
        news.setCategory("general")
        news.getHeadlines()
        newsSelection.currentIndex = 0
        print ("--> " + news.displayGeometery())
        var geometry =  JSON.parse(news.displayGeometery())
        displayHeight = geometry.height
        displayWidth = geometry.width
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

    // NewsApi list of categories
    ListModel {
        id: newsSelectionModel

        ListElement {
            name: "Home"
            category: "general"
        }
        ListElement {
            name: "Business"
            category: "business"
        }
        ListElement {
            name: "Technology"
            category: "technology"
        }
        ListElement {
            name: "Sports"
            category: "sports"
        }
        ListElement {
            name: "Health"
            category: "health"
        }
        ListElement {
            name: "Science"
            category: "science"
        }
        ListElement {
            name: "Entertainment"
            category: "entertainment"
        }
    }

    Connections {
        target: searchBtn
        onClicked: {
            news.search(searchInput.text)
        }
    }

    Connections {
        target: breakingNewsTypeBtn
        onPressed: {
            breaking = true
            news.setBreakingNews(breaking)
            news.getHeadlines()
        }
    }

    Connections {
        target: allNewsTypeBtn
        onPressed: {
            breaking = false
            news.setBreakingNews(breaking)
            news.getHeadlines()
        }
    }
}
