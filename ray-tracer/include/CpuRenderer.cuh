#pragma once

#include <Renderer.cuh>

class CpuRenderer : public Renderer
{
public:
    void render(FrameBuffer &, const Scene &, const Camera &) override;
};