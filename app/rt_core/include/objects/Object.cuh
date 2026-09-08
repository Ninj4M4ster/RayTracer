#pragma once

#include <math/Vec3.cuh>
#include <math/Quaternion.cuh>
#include <math/Ray.cuh>
#include <Color.cuh>
#include <optional>
#include <objects/ObjectType.cuh>

class Object
{
public:
    explicit Object(ScalarVector3 position, Quaternion orientation, Color color)
        : position(position), orientation(orientation), color(color), objectType{ObjectType::OBJECT} {}

    RT_HD bool intersect(const Ray &ray, float &t, ScalarVector3 &normal) { return false; };

    ScalarVector3 position;
    Quaternion orientation;
    Color color;
    ObjectType objectType;
};