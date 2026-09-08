#pragma once

#include <objects/Object.cuh>

class Light : public Object
{
public:
    explicit Light(ScalarVector3 position) : Object(position, Quaternion{}, Color{0., 0., 0.})
    {
        objectType = ObjectType::LIGHT;
    }
};
