#include <RenderWorker.hpp>
#include <renderer/CpuRenderer.cuh>

#include <QImage>
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
      camera{ScalarVector3{0.0, 0.0, (double)std::rand() / (RAND_MAX + 1.0)},
             Quaternion{1.0, {0.0, 0.0, 0.0}},
             cameraSettings} {
}

void RenderWorker::initialize()
{
    gpuRenderer = std::make_unique<GpuRenderer>();
    renderer = std::make_unique<CpuRenderer>();

    emit initialized();
}

void RenderWorker::render() {
    FrameBuffer framebuffer{cameraSettings.width, cameraSettings.height};
    Quaternion orientation{1.0, {0.0, 0.0, 0.0}};
    Scene scene{
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

    GpuScene gpuScene{scene};

    try
    {
        gpuRenderer->render(framebuffer, gpuScene, camera);
        // renderer->render(framebuffer, scene, cam);

        // QImage image(
        //     framebuffer.data(),
        //     framebuffer.width(),
        //     framebuffer.height(),
        //     framebuffer.width() * 3,
        //     QImage::Format_RGB888
        // );

        QImage image(
            framebuffer.data(),
            cameraSettings.width,
            cameraSettings.height,
            cameraSettings.width * 3,
            QImage::Format_RGB888);


        emit finished(image.copy());
    }
    catch (...)
    {
        emit error("Rendering failed");
    }
    gpuScene.free();
}

void RenderWorker::resizeWindow(const QSize newSize) {
    cameraSettings.width = newSize.width();
    cameraSettings.height = newSize.height();
    camera.updateCameraSettings(cameraSettings);
}