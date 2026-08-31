#pragma once

#include <QObject>
#include <renderer/IRenderer.cuh>

class RenderWorker : public QObject {
    Q_OBJECT
public:
    RenderWorker() = default;

public slots:
    void render();

signals:
    void finished(QImage image);
    void progress(int percentage);
    void error(QString message);

private:
    std::unique_ptr<IRenderer> renderer;
};
