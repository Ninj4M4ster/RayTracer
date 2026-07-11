#pragma once

#include <objects/Object.cuh>

class Sphere : public Object
{
public:
    explicit Sphere(ScalarVector3 position, Quaternion orientation, Color color, float radius)
        : Object(position, orientation, color), radius(radius) {}
    virtual ~Sphere() = default;
    bool intersect(const Ray &ray, float &t, ScalarVector3 &normal) override;

    float radius;
};
