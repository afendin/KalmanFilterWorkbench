#ifndef STATEMANAGER_H
#define STATEMANAGER_H

#include <QObject>

#include "QQmlHelpers"

#define DRAW_QMLNAME "StateManager"

class StateManager : public QObject
{
    Q_OBJECT
    QML_WRITABLE_PROPERTY(float, estimated_distance)
    QML_WRITABLE_PROPERTY(float, measured_distance)
    QML_WRITABLE_PROPERTY(float, predicted_distance)
    QML_WRITABLE_PROPERTY(float, estimated_velocity)
    QML_WRITABLE_PROPERTY(float, predicted_velocity)
    QML_WRITABLE_PROPERTY(float, trust_distance);
    QML_WRITABLE_PROPERTY(float, trust_velocity);
    QML_WRITABLE_PROPERTY(float, bias_distance);
public:
    explicit StateManager(QObject *parent = nullptr);

public slots:
    void update(float measured_distance, int time);

private:
    int m_lastTime;
};

#endif // STATEMANAGER_H
