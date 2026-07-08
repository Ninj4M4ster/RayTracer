#pragma once

#include <renderer/IRenderer.cuh>
#include <GpuScene.cuh>

class GpuRenderer
{
public:
    void render(FrameBuffer &, const GpuScene &, const Camera &);
};