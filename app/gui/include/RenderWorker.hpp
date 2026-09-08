#pragma once

#include <QObject>
#include <renderer/IRenderer.cuh>
#include <renderer/GpuRenderer.cuh>
#include <QSize>

class RenderWorker : public QObject {
    Q_OBJECT
public:
    explicit RenderWorker(const QSize parentWindowSize);

public slots:
    void initialize();
    void render();
    void resizeWindow(const QSize);

signals:
    void initialized();
    void finished(QImage image);
    void progress(int percentage);
    void error(QString message);

private:
    std::unique_ptr<IRenderer> renderer;
    std::unique_ptr<GpuRenderer> gpuRenderer;
    CameraSettings cameraSettings;
    Camera camera;
};
