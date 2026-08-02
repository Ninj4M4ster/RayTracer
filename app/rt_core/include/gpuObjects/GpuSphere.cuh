#pragma once

#include <CudaCompat.cuh>
#include <math/Vec3.cuh>
#include <math/Ray.cuh>

struct GpuSphere
{
    RT_HD bool intersect(const Ray &ray,
                         float &t);

    ScalarVector3 position;
    float radius;
};
