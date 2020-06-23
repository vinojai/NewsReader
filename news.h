#ifndef NEWS_H
#define NEWS_H

#include <QObject>
#include <QQmlContext>
#include <QJsonArray>
#include <QJsonObject>
#include "QNetworkAccessManager"

#define API_BASE "newsapi.org"
#define API_VERSION "v2"
#define COUNTRY "us"
#define HOME "top-headlines"
#define API_KEY_KEY "NEWS_API_KEY"



extern QQmlContext* rootContext;


class NewsClass : public QObject
{
    Q_OBJECT
public:
    explicit NewsClass(QObject *parent = nullptr);
    Q_INVOKABLE void getHeadlines();
    Q_INVOKABLE QByteArray readHeadlines() {
        return articles;
    }
    Q_INVOKABLE bool isApiKeySet();
    Q_INVOKABLE QString getApiKeyName();
    Q_INVOKABLE void setCategory(QString category) {
        m_category = category;
    }
public slots:
    void onManagerFinished(QNetworkReply *reply);

public: signals:
    void finished(QNetworkReply *reply);
    void dataReady(QByteArray &data);

private:
    QNetworkAccessManager* m_networkManager;
    QString m_status;
    qint64 m_totalResults;
    QJsonArray m_articles;
    QString m_category;

public:
    QByteArray articles;
    QString apiKey;
};

#endif // NEWS_H
