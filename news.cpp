#include <QNetworkReply>
#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QFile>
#include <QTextCodec>
#include <QCoreApplication>
#include <QScreen>
#include <QGuiApplication>
#include "news.h"

NewsClass::NewsClass(QObject *parent) : QObject(parent)
{
    m_networkManager = new QNetworkAccessManager(this);
    connect(m_networkManager, &QNetworkAccessManager::finished, this, &NewsClass::onManagerFinished);
    QCoreApplication::setOrganizationName("QIIP");
    QCoreApplication::setOrganizationDomain("qiip.com");
    QCoreApplication::setApplicationName("NewsReader");
    setBreakingNews(true);
    QScreen *screen = QGuiApplication::primaryScreen();
    m_screenGeometry = screen->geometry();
}

QByteArray NewsClass::displayGeometery()
{
    QJsonObject obj;
    obj["height"] = m_screenGeometry.height();
    obj["width"] = m_screenGeometry.width();
    QJsonDocument jdoc(obj);
    return jdoc.toJson();
}

bool NewsClass::isApiKeyExists()
{
    QSettings settings("QIIP", "NewsReader");
    return settings.contains("apikey");
}

QString NewsClass::getApiKey()
{
    QSettings settings("QIIP", "NewsReader");
    QString apikey = settings.value("apikey").toString();
    return apikey;
}

void NewsClass::setApiKey(QString key)
{
    QSettings settings("QIIP", "NewsReader");
    settings.setValue("apikey", key);
}

//void NewsClass::getHeadlines()
//{
//    isBreakingnews() ? getTopHeadlines() : getAllHeadlines();
//}

void NewsClass::getTopHeadlines()
{
    QTextStream(stdout) << "Getting News Headlines";

    QString categoryString = QString("&category=%1").arg(m_category);

    QString apiKey = getApiKey();

    QUrl headlinesUrl(QString("http://%1/%2/%3?country=%4%5&apiKey=%6").arg(API_BASE, API_VERSION, HOME, COUNTRY, categoryString, apiKey));
    QNetworkRequest request;
    request.setUrl(headlinesUrl);
    request.setRawHeader("User-Agent", "MyOwnBrowser 1.0");
    m_networkManager->get(request);
}

//void NewsClass::getAllHeadlines()
//{
//    QTextStream(stdout) << "Getting News All Headlines";

//    QString categoryString = QString("&category=%1").arg(m_category);

//    QString apiKey = getApiKey();

//    QUrl headlinesUrl(QString("http://%1/%2/%3?&apiKey=%4").arg(API_BASE, API_VERSION, getNewsType(), apiKey));
//    QNetworkRequest request;
//    request.setUrl(headlinesUrl);
//    request.setRawHeader("User-Agent", "MyOwnBrowser 1.0");
//    m_networkManager->get(request);
//}

void NewsClass::search(QString searchQuery) {
    QTextStream(stdout) << "Search News Headlines";

    QString apiKey = getApiKey();
    QString neusUrl = isBreakingnews() ?
        QString("http://%1/%2/%3?q=%4&apiKey=%5").arg(API_BASE, API_VERSION, getNewsType(), searchQuery, apiKey) :
        QString("http://%1/%2/%3?q=%4&apiKey=%4").arg(API_BASE, API_VERSION, getNewsType(), searchQuery, apiKey);

    //QUrl headlinesUrl;

    QUrl headlinesUrl(QString("http://%1/%2/%3?q=%4&apiKey=%5").arg(API_BASE, API_VERSION, getNewsType(), searchQuery, apiKey));
    QNetworkRequest request;
    request.setUrl(headlinesUrl);
    request.setRawHeader("User-Agent", "MyOwnBrowser 1.0");
    m_networkManager->get(request);
}

void NewsClass::onManagerFinished(QNetworkReply *reply)
{
    if (reply->error() == QNetworkReply::NoError) {
        QString replyStr = (QString) reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson((replyStr.toUtf8()));
        QJsonObject replyObj = doc.object();
        m_status =  replyObj["status"].toString();
        m_totalResults = replyObj["totalResults"].toInt();
        m_articles = replyObj["articles"].toArray();

        QJsonArray headlines;
        QJsonObject headline;
        for(int i=0; i<=m_articles.size() - 1; i++) {
            qDebug() << m_articles[i];
            QJsonObject article = m_articles[i].toObject();
            qDebug() << article["author"].toString();
            headline["author"] = article["author"].toString();
            headline["title"] = article["title"].toString();
            headline["url"] = article["url"].toString();
            headline["urlToImage"] = article["urlToImage"].toString();
            headline["publishedAt"] = article["publishedAt"].toString();
            headlines.append(headline);
        }
        QJsonDocument articlesDoc(headlines);
        articles = articlesDoc.toJson();

        emit dataReady(articles);
    } else {
        emit dataNotReady();
    }
}
