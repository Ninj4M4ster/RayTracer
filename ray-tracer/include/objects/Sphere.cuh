#pragma once

#include <objects/Object.cuh>

class Sphere : public Object
{
public:
    explicit Sphere(ScalarVector3 position, Quaternion orientation, float radius) : Object(position, orientation), radius(radius) {}
    virtual ~Sphere() = default;
    std::optional<float> intersect(const Ray &ray) override;

private:
    float radius;
};
