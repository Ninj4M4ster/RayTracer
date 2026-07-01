#pragma once

#include <FrameBuffer.cuh>
#include <Scene.cuh>
#include <Camera.cuh>

class Renderer
{
public:
    virtual void render(FrameBuffer &, const Scene &, const Camera &) = 0;
};