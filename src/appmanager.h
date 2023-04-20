#ifndef APPMANAGER_H
#define APPMANAGER_H

#include <QObject>
#include <QQmlApplicationEngine>

#include "drawmanager.h"

#define APP_URI "KalmanFilterWorkbench"
#define UNCREATABLE_MESSAGE(NAME) QStringLiteral(NAME" is uncreatable")

class AppManager : public QObject
{
    Q_OBJECT
public:
    explicit AppManager(QObject *parent = nullptr);

    void initialize();
    void loadQml(const QString &urlString);

signals:

private:
    void initializeComponents();

    QQmlApplicationEngine *m_qmlEngine = nullptr;
    DrawManager *m_drawManager;
};

#endif // APPMANAGER_H
