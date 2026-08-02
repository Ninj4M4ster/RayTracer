#pragma once

#include <vector>
#include <objects/Object.cuh>
#include <objects/Light.cuh>
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

    void addLight(const std::shared_ptr<Light> light)
    {
        this->light = light;
    }

    std::vector<std::shared_ptr<Object>> getObjects() const
    {
        return objects;
    }

    std::shared_ptr<Light> getLight() const
    {
        return light;
    }

private:
    std::vector<std::shared_ptr<Object>> objects;
    std::shared_ptr<Light> light;
};