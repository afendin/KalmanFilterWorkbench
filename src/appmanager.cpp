#include "appmanager.h"

#include <QGuiApplication>

AppManager::AppManager(QObject *parent)
    : QObject{parent}
{

}

void AppManager::initialize()
{
    initializeComponents();

    loadQml(u"qrc:/KalmanFilterWorkbench/main.qml"_qs);
}

void AppManager::loadQml(const QString &urlString)
{
    m_qmlEngine = new QQmlApplicationEngine(this);
    const QUrl url(urlString);
    QObject::connect(m_qmlEngine, &QQmlApplicationEngine::objectCreated,
                     qApp, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    m_qmlEngine->load(url);
}

void AppManager::initializeComponents()
{
    m_drawManager = new StateManager(this);
    qmlRegisterSingletonInstance(APP_URI, 1, 0, DRAW_QMLNAME, m_drawManager);
}
