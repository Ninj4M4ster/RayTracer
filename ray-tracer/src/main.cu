#define STB_IMAGE_WRITE_IMPLEMENTATION

#include <iostream>
#include <Vec3.cuh>
#include <Camera.cuh>
#include <FrameBuffer.cuh>
#include <Scene.cuh>
#include <CpuRenderer.cuh>
#include <imageUtils/stb_image_write.h>

int main()
{
    ScalarVector3 origin{0.0, 0.0, 0.0};
    Quaternion orientation{1.0, {0.0, 0.0, 0.0}};
    CameraSettings settings{1920, 1080, M_PI / 2.0};
    Camera cam{origin, orientation, settings};

    FrameBuffer framebuffer{settings.width, settings.height};
    Scene scene;
    CpuRenderer renderer;

    renderer.render(framebuffer, scene, cam);

    stbi_write_png(
        "output.png",
        settings.width,
        settings.height,
        3, // RGB
        framebuffer.data(),
        settings.width * 3 // stride
    );

    return 0;
}