#pragma once

#include <Vec3.cuh>

using ScalarVector3 = Vec3<float>;

struct Quaternion
{
    ScalarVector3 rotate(const ScalarVector3 rotator)
    {
        const auto uxCross{u.crossProduct(rotator)};
        return rotator + 2.0 * w * uxCross + (2.0 * u).crossProduct(uxCross);
    }

    float w;
    ScalarVector3 u;
};