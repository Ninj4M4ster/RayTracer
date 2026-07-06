#pragma once

#include <Vec3.cuh>
#include <Quaternion.cuh>
#include <Ray.cuh>
#include <optional>

class Object
{
public:
    explicit Object(ScalarVector3 position, Quaternion orientation) : position(position), orientation(orientation) {}
    virtual ~Object() = default;

    virtual std::optional<float> intersect(const Ray &ray) = 0;

protected:
    ScalarVector3 position;
    Quaternion orientation;
};