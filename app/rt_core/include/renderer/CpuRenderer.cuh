#pragma once

#include <renderer/IRenderer.cuh>

class CpuRenderer : public IRenderer
{
public:
    void render(FrameBuffer &, const Scene &, const Camera &) override;
};