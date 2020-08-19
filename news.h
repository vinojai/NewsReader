#ifndef NEWS_H
#define NEWS_H

#include <QObject>
#include <QQmlContext>
#include <QJsonArray>
#include <QJsonObject>
#include <QSettings>
#include <QScreen>
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
    Q_INVOKABLE void getTopHeadlines();
    Q_INVOKABLE void getAllHeadlines();
    Q_INVOKABLE QByteArray readHeadlines() {
        return articles;
    }
    Q_INVOKABLE bool isApiKeyExists();
    Q_INVOKABLE QString getApiKey();
    Q_INVOKABLE void setApiKey(QString key);
    Q_INVOKABLE void setCategory(QString category) {
        m_category = category;
    }
    Q_INVOKABLE void search(QString searchQuery);
    Q_INVOKABLE void setBreakingNews (bool breaking) {
        m_breakingNews = breaking;
        isBreakingnews() ? setNewsType("top-headlines") : setNewsType("everything");
    }
    Q_INVOKABLE bool isBreakingnews() {
        return m_breakingNews;
    }
    Q_INVOKABLE void setNewsType(QString type) {
        m_newsType = type;
    }
    Q_INVOKABLE QString getNewsType() {
        return m_newsType;
    }
    Q_INVOKABLE QByteArray displayGeometery();

public slots:
    void onManagerFinished(QNetworkReply *reply);

public: signals:
    void finished(QNetworkReply *reply);
    void dataReady(QByteArray &data);
    void dataNotReady();

private:
    QNetworkAccessManager* m_networkManager;
    QString m_status;
    qint64 m_totalResults;
    QJsonArray m_articles;
    QString m_category;
    QSettings m_settings;
    bool m_breakingNews;
    QString m_newsType;
    QRect  m_screenGeometry;

public:
    QByteArray articles;
    QString apiKey;
};

#endif // NEWS_H
