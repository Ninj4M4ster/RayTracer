#pragma once

#include <vector>
#include <Object.cuh>

class Scene
{
public:
    Scene() = default;
    explicit Scene(std::vector<Object> objects) : objects(objects) {}

    void addObject(const Object &object)
    {
        objects.push_back(object);
    }

    std::vector<Object> getObjects() const
    {
        return objects;
    }

private:
    std::vector<Object> objects;
};