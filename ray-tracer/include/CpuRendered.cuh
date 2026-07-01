#pragma once

#include <Rendered.cuh>

class CpuRendered : public Rendered
{
public:
    void render(FrameBuffer &, const Scene &, const Camera &) override;
};