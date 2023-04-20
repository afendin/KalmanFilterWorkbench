#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "appmanager.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    AppManager appManager;
    appManager.initialize();

    return app.exec();
}
