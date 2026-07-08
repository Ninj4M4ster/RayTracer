#define STB_IMAGE_WRITE_IMPLEMENTATION

#include <iostream>
#include <Vec3.cuh>
#include <Camera.cuh>
#include <FrameBuffer.cuh>
#include <Scene.cuh>
#include <renderer/CpuRenderer.cuh>
#include <renderer/GpuRenderer.cuh>
#include <imageUtils/stb_image_write.h>
#include <objects/Sphere.cuh>

int main()
{
    ScalarVector3 cameraOrigin{0.0, 0.0, 0.0};
    Quaternion orientation{1.0, {0.0, 0.0, 0.0}};
    CameraSettings settings{1920, 1080, M_PI / 2.0};
    Camera cam{cameraOrigin, orientation, settings};

    FrameBuffer framebuffer{settings.width, settings.height};
    Scene scene{
        {std::make_shared<Sphere>(ScalarVector3{0.0, 0.0, -5.0}, orientation, 1.0),
         std::make_shared<Sphere>(ScalarVector3{2.0, 0.0, -5.0}, orientation, 1.0),
         std::make_shared<Sphere>(ScalarVector3{-2.0, 0.0, -5.0}, orientation, 1.0)}};
    CpuRenderer cpuRenderer;
    cpuRenderer.render(framebuffer, scene, cam);
    stbi_write_png(
        "outputCpu.png",
        settings.width,
        settings.height,
        3, // RGB
        framebuffer.data(),
        settings.width * 3 // stride
    );

    GpuRenderer renderer;

    GpuScene gpuScene{scene};
    renderer.render(framebuffer, gpuScene, cam);

    stbi_write_png(
        "outputGpu.png",
        settings.width,
        settings.height,
        3, // RGB
        framebuffer.data(),
        settings.width * 3 // stride
    );

    return 0;
}