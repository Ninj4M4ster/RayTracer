#include <RenderWorker.hpp>
#include <renderer/CpuRenderer.cuh>

#include <QImage>

#include <math/Vec3.cuh>
#include <Camera.cuh>
#include <FrameBuffer.cuh>
#include <Scene.cuh>
#include <objects/Light.cuh>
#include <renderer/CpuRenderer.cuh>
#include <renderer/GpuRenderer.cuh>
#include <imageUtils/stb_image_write.h>
#include <objects/Sphere.cuh>

void RenderWorker::render()
{
    ScalarVector3 cameraOrigin{0.0, 0.0, 0.0};
    Quaternion orientation{1.0, {0.0, 0.0, 0.0}};
    CameraSettings settings{1920, 1080, M_PI / 2.0};
    Camera cam{cameraOrigin, orientation, settings};

    FrameBuffer framebuffer{settings.width, settings.height};
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

    renderer = std::make_unique<CpuRenderer>();
    try
    {
        renderer->render(framebuffer, scene, cam);

        // QImage image(
        //     framebuffer.data(),
        //     framebuffer.width(),
        //     framebuffer.height(),
        //     framebuffer.width() * 3,
        //     QImage::Format_RGB888
        // );

        QImage image(
            framebuffer.data(),
            settings.width,
            settings.height,
            settings.width * 3,
            QImage::Format_RGB888);


        emit finished(image.copy());
    }
    catch (...)
    {
        emit error("Rendering failed");
    }
}