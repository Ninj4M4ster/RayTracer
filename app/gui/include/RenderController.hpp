#pragma once

#include <QObject>
#include <QThread>
#include <QImage>
#include <RenderWorker.hpp>

class MainWindow;

class RenderController : public QObject {
    Q_OBJECT
public:
    RenderController(MainWindow* window);
    ~RenderController();

public slots:
    void startRender();
    void stopRender();

private:
    QThread renderingThread;
    std::unique_ptr<RenderWorker> worker;
    MainWindow *mainWindow;
};
