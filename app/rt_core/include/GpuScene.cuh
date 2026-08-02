#pragma once

#include <CudaCompat.cuh>
#include <objects/Sphere.cuh>
#include <gpuObjects/GpuSphere.cuh>
#include <Scene.cuh>

struct GpuScene
{
    explicit GpuScene(const Scene &scene);
    RT_HD ~GpuScene();

    GpuSphere *spheres;
    int sphereCount{0};
};