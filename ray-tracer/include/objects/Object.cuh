#pragma once

#include <Vec3.cuh>
#include <Quaternion.cuh>
#include <Ray.cuh>
#include <Color.cuh>
#include <optional>

class Object
{
public:
    explicit Object(ScalarVector3 position, Quaternion orientation, Color color)
        : position(position), orientation(orientation), color(color) {}
    virtual ~Object() = default;

    virtual bool intersect(const Ray &ray, float &t, ScalarVector3 &normal) = 0;

    ScalarVector3 position;
    Quaternion orientation;
    Color color;
};