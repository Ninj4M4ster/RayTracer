#pragma once

#include <renderer/IRenderer.cuh>
#include <GpuScene.cuh>

class GpuRenderer
{
public:
    GpuRenderer() = default;
    ~GpuRenderer();

    void resize(int width, int height);
    void render(FrameBuffer &, const GpuScene &, const Camera &);

private:
    Color *deviceFrameBuffer = nullptr;
    std::size_t capacity = 0;
};