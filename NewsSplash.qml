import QtQuick 2.4

NewsSplashForm {
    SystemPalette {id: newsPalette; colorGroup: SystemPalette.Active }
    property string apikeykey: news.getApiKeyName()
    property bool isKey: news.isApiKeySet()
}
