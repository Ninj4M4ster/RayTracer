#pragma once

#include <Vec3.cuh>
#include <ostream>

struct Ray
{
    Ray() = default;
    Ray(ScalarVector3 origin, ScalarVector3 direction) : origin(origin), direction(direction) {}

    ScalarVector3 origin;
    ScalarVector3 direction;
};

inline std::ostream &operator<<(std::ostream &os, const Ray &ray)
{
    os << "(" << ray.origin << ", " << ray.direction << ")";
    return os;
}