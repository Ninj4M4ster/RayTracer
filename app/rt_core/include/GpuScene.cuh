#pragma once

#include <objects/Sphere.cuh>
#include <objects/Light.cuh>
#include <Scene.cuh>

struct GpuScene
{
    explicit GpuScene(const Scene &scene);
    void free();

    RT_HD Light *getLight() const
    {
        return light;
    }

    Sphere *spheres;
    Light *light;
    int sphereCount{0};
};