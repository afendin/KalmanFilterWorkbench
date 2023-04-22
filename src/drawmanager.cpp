#include "drawmanager.h"

DrawManager::DrawManager(QObject *parent)
    : QObject{parent}
{

    m_trust_velocity = 0.9;
    m_trust_distance = 0.1;
    m_lastTime = 0;
}

void DrawManager::update(float measured_distance, int time)
{

    // TODO check if logic right
    float t = abs(m_lastTime - time); // delta t time passed
    //calculate new velocity
    float v = abs(m_measured_distance - measured_distance) / t;

    float estimated_distance = m_estimated_distance + m_trust_distance *
                                (measured_distance - m_estimated_distance);
    float estimated_velocity = m_estimated_velocity + m_trust_velocity *
                                ((v - m_estimated_velocity)/t);

    set_estimated_distance(estimated_distance);
    set_estimated_velocity(estimated_velocity);
    set_predicted_distance(measured_distance * v);
    set_predicted_velocity(v);
    set_measured_distance(measured_distance);
}
