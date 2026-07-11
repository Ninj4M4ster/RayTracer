#pragma once

#include <objects/Object.cuh>

class Light : public Object
{
public:
    explicit Light(ScalarVector3 position) : Object(position, Quaternion{}, Color{0., 0., 0.}) {}

    bool intersect(const Ray &ray, float &t, ScalarVector3 &normal) override { return false; };
};
