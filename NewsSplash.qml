import QtQuick 2.4

NewsSplashForm {
    property string apikeykey: news.getApiKeyName()
    property bool isKey: news.isApiKeySet()
}
