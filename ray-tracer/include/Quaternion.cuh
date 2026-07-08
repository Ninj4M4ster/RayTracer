#pragma once

#include <CudaCompat.cuh>
#include <Vec3.cuh>

struct Quaternion
{
    RT_HD
    ScalarVector3
    rotate(const ScalarVector3 rotator) const
    {
        const auto uxCross{u.crossProduct(rotator)};
        return rotator + 2.0 * w * uxCross + (2.0 * u).crossProduct(uxCross);
    }

    float w;
    ScalarVector3 u;
};