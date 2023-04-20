cmake_minimum_required(VERSION 3.16)

project(KalmanFilterWorkbench VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

qt_add_executable(appKalmanFilterWorkbench
    main.cpp
    src/appmanager.h src/appmanager.cpp
    src/drawmanager.h src/drawmanager.cpp
    3rdparty/lib-qt-qml-tricks/src/qqmlobjectlistmodel.h
    3rdparty/lib-qt-qml-tricks/src/qqmlobjectlistmodel.cpp

)

qt_add_qml_module(appKalmanFilterWorkbench
    URI KalmanFilterWorkbench
    VERSION 1.0
    QML_FILES main.qml
              KFDelimiter.qml
)

target_include_directories(appKalmanFilterWorkbench PRIVATE
                            src
                            3rdparty/lib-qt-qml-tricks/include
                            )

set_target_properties(appKalmanFilterWorkbench PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appKalmanFilterWorkbench
    PRIVATE Qt6::Quick)

install(TARGETS appKalmanFilterWorkbench
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
