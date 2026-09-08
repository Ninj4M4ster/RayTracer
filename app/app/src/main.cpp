#define STB_IMAGE_WRITE_IMPLEMENTATION

#include <iostream>
#include <math/Vec3.cuh>
#include <Camera.cuh>
#include <FrameBuffer.cuh>
#include <Scene.cuh>
#include <objects/Light.cuh>
#include <renderer/CpuRenderer.cuh>
#include <renderer/GpuRenderer.cuh>
#include <imageUtils/stb_image_write.h>
#include <objects/Sphere.cuh>

#include <QApplication>
#include <QPushButton>
#include <QLabel>
#include <QImage>

#include <MainWindow.hpp>

int main(int argc, char **argv)
{
    // stbi_write_png(
    //     "outputCpu.png",
    //     settings.width,
    //     settings.height,
    //     3, // RGB
    //     framebuffer.data(),
    //     settings.width * 3 // stride
    // );

    // GpuRenderer renderer;

    // GpuScene gpuScene{scene};
    // renderer.render(framebuffer, gpuScene, cam);

    // stbi_write_png(
    //     "outputGpu.png",
    //     settings.width,
    //     settings.height,
    //     3, // RGB
    //     framebuffer.data(),
    //     settings.width * 3 // stride
    // );

    QApplication app(argc, argv);

    MainWindow mainWindow;
    mainWindow.showMaximized();
    mainWindow.show();

    return app.exec();
}