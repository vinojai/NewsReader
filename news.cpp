#include <QNetworkReply>
#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include "news.h"

NewsClass::NewsClass(QObject *parent) : QObject(parent)
{
    m_networkManager = new QNetworkAccessManager(this);
    connect(m_networkManager, &QNetworkAccessManager::finished, this, &NewsClass::onManagerFinished);
    apiKey = qEnvironmentVariable(API_KEY_KEY);
}

bool NewsClass::isApiKeySet()
{
    return qEnvironmentVariableIsSet(API_KEY_KEY);
}

QString NewsClass::getApiKeyName()
{
    return API_KEY_KEY;
}

void NewsClass::getHeadlines()
{
    QTextStream(stdout) << "Getting News Headlines";

    QString categoryString = QString("&category=%1").arg(m_category);

    QUrl headlinesUrl(QString("http://%1/%2/%3?country=%4%5&apiKey=%6").arg(API_BASE, API_VERSION, HOME, COUNTRY, categoryString, apiKey));
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
        for(int i=0; i<=m_articles.size(); i++) {
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
    }
}

