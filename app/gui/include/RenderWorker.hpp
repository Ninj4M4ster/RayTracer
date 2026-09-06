#pragma once

#include <QObject>
#include <renderer/IRenderer.cuh>
#include <renderer/GpuRenderer.cuh>

class RenderWorker : public QObject {
    Q_OBJECT
public:
    RenderWorker() = default;

public slots:
    void initialize();
    void render();

signals:
    void initialized();
    void finished(QImage image);
    void progress(int percentage);
    void error(QString message);

private:
    std::unique_ptr<IRenderer> renderer;
    std::unique_ptr<GpuRenderer> gpuRenderer;
};
