#pragma once

#include <gpuObjects/GpuSphere.cuh>
#include <Scene.cuh>

struct GpuScene
{
    explicit GpuScene(const Scene &scene);
    void free();

    GpuSphere *spheres;
    int sphereCount{0};
};