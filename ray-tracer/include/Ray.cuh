#pragma once

#include <Vec3.cuh>
#include <ostream>

template <typename T>
struct Ray
{
    explicit Ray(Vec3<T> origin, Vec3<T> direction) : origin(origin), direction(direction) {}

    Vec3<T> origin;
    Vec3<T> direction;
};

template <typename T>
std::ostream &operator<<(std::ostream &os, const Ray<T> &ray)
{
    os << "(" << ray.origin << ", " << ray.direction << ")";
    return os;
}