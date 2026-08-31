#include <RenderController.hpp>
#include <MainWindow.hpp>

RenderController::RenderController(MainWindow* parent)
    : QObject(parent), mainWindow(parent)
{
    worker = std::make_unique<RenderWorker>();

    worker->moveToThread(&renderingThread);

    connect(
        &renderingThread,
        &QThread::started,
        worker.get(),
        &RenderWorker::render
    );

    connect(
        worker.get(),
        &RenderWorker::finished,
        mainWindow,
        &MainWindow::display
    );

    renderingThread.start();
}

RenderController::~RenderController() {
    // renderTimer.stop();

    if (renderingThread.isRunning()) {
        renderingThread.quit();
        renderingThread.wait();
    }

    if (worker) {
        worker->deleteLater();
    }
}

void RenderController::startRender() {
    QMetaObject::invokeMethod(
        worker.get(),
        "render",
        Qt::QueuedConnection
    );
}

void RenderController::stopRender() {
    // TODO
}

