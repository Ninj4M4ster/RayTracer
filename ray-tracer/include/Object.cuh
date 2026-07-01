#pragma once

#include <Vec3.cuh>
#include <Quaternion.cuh>

class Object
{
public:
    explicit Object(ScalarVector3 position, Quaternion orientation) : position(position), orientation(orientation) {}

private:
    ScalarVector3 position;
    Quaternion orientation;
};