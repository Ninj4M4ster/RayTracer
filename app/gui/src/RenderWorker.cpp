#include <RenderWorker.hpp>
#include <renderer/CpuRenderer.cuh>

#include <QImage>
#include <cstring>
#include <random>

#include <math/Vec3.cuh>
#include <Camera.cuh>
#include <FrameBuffer.cuh>
#include <Scene.cuh>
#include <objects/Light.cuh>
#include <renderer/CpuRenderer.cuh>
#include <renderer/GpuRenderer.cuh>
#include <imageUtils/stb_image_write.h>
#include <objects/Sphere.cuh>

RenderWorker::RenderWorker(const QSize parentWindowSize)
    : cameraSettings{parentWindowSize.width(), parentWindowSize.height(), M_PI / 2.0},
      camera{ScalarVector3{0.0, 0.0, (float)std::rand() / (RAND_MAX + 1.0f)},
             Quaternion{1.0, {0.0, 0.0, 0.0}},
             cameraSettings},
        frameBuffer{cameraSettings.width, cameraSettings.height} {

    Quaternion orientation{1.0, {0.0, 0.0, 0.0}};
    scene = Scene{
        {std::make_shared<Sphere>(ScalarVector3{0.0, 0.0, -5.0},
                                  orientation,
                                  Color(252.0 / 255., 186. / 255., 3. / 255.),
                                  1.0),
         std::make_shared<Sphere>(ScalarVector3{2.0, 0.0, -5.0},
                                  orientation,
                                  Color(48. / 255., 0., 161. / 255.),
                                  1.0),
         std::make_shared<Sphere>(ScalarVector3{-2.0, 0.0, -5.0},
                                  orientation,
                                  Color(250. / 255., 0., 121. / 255.),
                                  1.0)}};
    ScalarVector3 lightOrigin{20.0, 20.0, 20.0};
    scene.addLight(std::make_shared<Light>(lightOrigin));
}

void RenderWorker::initialize()
{
    gpuRenderer = std::make_unique<GpuRenderer>();
    renderer = std::make_unique<CpuRenderer>();
    gpuRenderer->resize(cameraSettings.width, cameraSettings.height);

    gpuScene = GpuScene(scene);

    emit initialized();
}

void RenderWorker::scheduleNextRender()
{
    if (renderQueued || shuttingDown)
        return;

    renderQueued = true;

    QMetaObject::invokeMethod(
        this,
        [this]()
        {
            renderQueued = false;

            if (!shuttingDown)
                render();
        },
        Qt::QueuedConnection);
}

void RenderWorker::render()
{
    if (shuttingDown ||
        !gpuRenderer ||
        cameraSettings.width == 0 ||
        cameraSettings.height == 0)
    {
        return;
    }

    try
    {
        gpuRenderer->render(
            frameBuffer,
            gpuScene,
            camera);

        QImage image(
            cameraSettings.width,
            cameraSettings.height,
            QImage::Format_RGB888);

        const auto *src = frameBuffer.data();

        const std::size_t rowBytes =
            static_cast<std::size_t>(cameraSettings.width) * 3u;

        for (std::uint32_t y = 0;
             y < cameraSettings.height;
             ++y)
        {
            std::memcpy(
                image.scanLine(y),
                src + static_cast<std::size_t>(y) * rowBytes,
                rowBytes);
        }

        emit finished(std::move(image));
    }
    catch (...)
    {
        emit error("Rendering failed");
        return;
    }

    scheduleNextRender();
}

void RenderWorker::resizeWindow(const QSize newSize)
{

    const auto width = newSize.width();
    const auto height = newSize.height();

    if (width <= 0 || height <= 0)
        return;

    const auto nextWidth = static_cast<std::uint32_t>(width);
    const auto nextHeight = static_cast<std::uint32_t>(height);

    if (nextWidth == cameraSettings.width &&
        nextHeight == cameraSettings.height)
    {
        return;
    }

    cameraSettings.width = nextWidth;
    cameraSettings.height = nextHeight;

    camera.updateCameraSettings(cameraSettings);

    frameBuffer.resize(
        cameraSettings.width,
        cameraSettings.height);

    if (gpuRenderer)
    {
        gpuRenderer->resize(
            cameraSettings.width,
            cameraSettings.height);
    }
}