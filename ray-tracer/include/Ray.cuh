#pragma once

#include <CudaCompat.cuh>
#include <Vec3.cuh>
#include <ostream>

struct Ray
{
    Ray() = default;
    RT_HD
    Ray(ScalarVector3 origin, ScalarVector3 direction) : origin(origin), direction(direction) {}

    RT_HD
    ScalarVector3
    pointOfIntersection(float t) const
    {
        return origin + t * direction;
    }

    ScalarVector3 origin;
    ScalarVector3 direction;
};

inline std::ostream &operator<<(std::ostream &os, const Ray &ray)
{
    os << "(" << ray.origin << ", " << ray.direction << ")";
    return os;
}