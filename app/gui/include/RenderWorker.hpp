#pragma once

#include <QObject>
#include <QSize>
#include <renderer/IRenderer.cuh>
#include <renderer/GpuRenderer.cuh>
#include <GpuScene.cuh>

class RenderWorker : public QObject {
    Q_OBJECT
public:
    explicit RenderWorker(const QSize parentWindowSize);

public slots:
    void initialize();
    void render();
    void resizeWindow(const QSize);

private:
    void scheduleNextRender();

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
    Scene scene;
    GpuScene gpuScene;
    FrameBuffer frameBuffer;
    bool renderQueued = false;
    bool rendering = false;
    bool shuttingDown = false;
};
