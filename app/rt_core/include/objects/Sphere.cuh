#pragma once

#include <objects/Object.cuh>

class Sphere : public Object
{
public:
    explicit Sphere(ScalarVector3 position, Quaternion orientation, Color color, float radius)
        : Object(position, orientation, color), radius(radius)
    {
        objectType = ObjectType::SPHERE;
    }
    RT_HD bool intersect(const Ray &ray, float &t, ScalarVector3 &normal);

    float radius;
};
