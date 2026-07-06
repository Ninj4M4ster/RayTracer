#pragma once

#include <vector>
#include <objects/Object.cuh>
#include <memory>

class Scene
{
public:
    Scene() = default;
    explicit Scene(std::vector<std::shared_ptr<Object>> objects) : objects(objects) {}

    void addObject(const std::shared_ptr<Object> &object)
    {
        objects.push_back(object);
    }

    std::vector<std::shared_ptr<Object>> getObjects() const
    {
        return objects;
    }

private:
    std::vector<std::shared_ptr<Object>> objects;
};