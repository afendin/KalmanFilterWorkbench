#ifndef DRAWMANAGER_H
#define DRAWMANAGER_H

#include <QObject>

#include "QQmlHelpers"

#define DRAW_QMLNAME "DrawManager"

class DrawManager : public QObject
{
    Q_OBJECT
    QML_WRITABLE_PROPERTY(float, estimated_distance)
    QML_WRITABLE_PROPERTY(float, measured_distance)
    QML_WRITABLE_PROPERTY(float, predicted_distance)
    QML_WRITABLE_PROPERTY(float, estimated_velocity)
    QML_WRITABLE_PROPERTY(float, predicted_velocity)

    QML_WRITABLE_PROPERTY(float, trust_distance);
    QML_WRITABLE_PROPERTY(float, trust_velocity);
public:
    explicit DrawManager(QObject *parent = nullptr);

public slots:
    void update(float measured_distance, int time);

private:
    int m_lastTime;
};

#endif // DRAWMANAGER_H
