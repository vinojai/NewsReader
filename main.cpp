#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebEngine>
#include <QFontDatabase>
#include <qtwebengineglobal.h>
#include <news.h>

NewsClass* news;

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    QGuiApplication app(argc, argv);

//    int id = QFontDatabase::addApplicationFont(":icofont/fonts/icofont.ttf");
//    QString family = QFontDatabase::applicationFontFamilies(id).at(0);
//    QFont icofont(family);

    // https://stackoverflow.com/questions/15035767/is-the-qt-5-dark-fusion-theme-available-for-windows
    QPalette darkPalette;
    darkPalette.setColor(QPalette::Window,QColor(53,53,53));
    darkPalette.setColor(QPalette::WindowText,Qt::white);
    darkPalette.setColor(QPalette::Disabled,QPalette::WindowText,QColor(127,127,127));
    darkPalette.setColor(QPalette::Base,QColor(42,42,42));
    darkPalette.setColor(QPalette::AlternateBase,QColor(66,66,66));
    darkPalette.setColor(QPalette::ToolTipBase,Qt::white);
    darkPalette.setColor(QPalette::ToolTipText,Qt::white);
    darkPalette.setColor(QPalette::Text,Qt::white);
    darkPalette.setColor(QPalette::Disabled,QPalette::Text,QColor(127,127,127));
    darkPalette.setColor(QPalette::Dark,QColor(35,35,35));
    darkPalette.setColor(QPalette::Shadow,QColor(20,20,20));
    darkPalette.setColor(QPalette::Button,QColor(53,53,53));
    darkPalette.setColor(QPalette::ButtonText,Qt::white);
    darkPalette.setColor(QPalette::Disabled,QPalette::ButtonText,QColor(127,127,127));
    darkPalette.setColor(QPalette::BrightText,Qt::red);
    darkPalette.setColor(QPalette::Link,QColor(42,130,218));
    darkPalette.setColor(QPalette::Highlight,QColor(42,130,218));
    darkPalette.setColor(QPalette::Disabled,QPalette::Highlight,QColor(80,80,80));
    darkPalette.setColor(QPalette::HighlightedText,Qt::black);
    darkPalette.setColor(QPalette::Disabled,QPalette::HighlightedText,QColor(127,127,127));
    app.setPalette(darkPalette);

    QtWebEngine::initialize();

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    NewsClass newsClass;
    news = &newsClass;

    engine.rootContext()->setContextProperty("news", news);
    engine.load(url);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    return app.exec();
}
