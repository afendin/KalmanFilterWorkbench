#include "statemanager.h"
#include <QDebug>

StateManager::StateManager(QObject *parent)
    : QObject{parent}
{
    restart();
    m_trust_distance = 0.1;
    m_trust_velocity = 0.9;
    m_bias_distance = 99;
}

void StateManager::update(float measured_distance, int time)
{
    // time passed(dt)
    float t = time - m_lastTime;

    // get velocity(v) as a derivative of the range(dx / dt);
    float v = measured_distance - m_measured_distance / t;

    // State Update Equation for velocity
    float estimated_velocity = m_estimated_velocity +
                               m_trust_velocity *
                               ((v - m_estimated_velocity)/t);
    set_estimated_velocity(estimated_velocity);

    // State Update Equation for position
    float estimated_distance = m_estimated_distance +
                               m_trust_distance *
                               (measured_distance - m_estimated_distance);
    set_estimated_distance(estimated_distance);

    // State Extrapolation Equation for velocity
    // *here we assume that velocity is constant
    set_predicted_velocity(estimated_velocity);

    // State Extrapolation Equation for position
    float predicted_distance = estimated_distance +
                               t * estimated_velocity;
    set_predicted_distance(predicted_distance);

    // store last measurements
    set_measured_distance(measured_distance);
    m_lastTime = time;
}

void StateManager::restart()
{
    m_lastTime = 0;
    m_estimated_distance = 0;
    m_measured_distance = 0;
    m_predicted_distance = 0;
    m_estimated_velocity = 0;
    m_predicted_velocity = 0;
}
