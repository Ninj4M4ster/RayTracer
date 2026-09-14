#pragma once

#include <objects/Sphere.cuh>
#include <objects/Light.cuh>
#include <Scene.cuh>

struct GpuSceneView
{
    Sphere *spheres = nullptr;
    Light *light = nullptr;
    int sphereCount = 0;

    RT_HD Light *getLight() const
    {
        return light;
    }
};

struct GpuScene
{
    explicit GpuScene(const Scene &scene);
    GpuScene() = default;
    GpuScene(const GpuScene &) = delete;
    GpuScene &operator=(const GpuScene &) = delete;

    GpuScene(GpuScene &&other) noexcept;
    GpuScene &operator=(GpuScene &&other) noexcept;

    ~GpuScene();
    void free();

    GpuSceneView view() const
    {
        return GpuSceneView{
            spheres,
            light,
            sphereCount};
    }

    RT_HD Light *getLight() const
    {
        return light;
    }

    Sphere *spheres{nullptr};
    Light *light{nullptr};
    int sphereCount{0};
};