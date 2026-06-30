#pragma once

#include <cstdint>
#include <Vec3.cuh>
#include <Quaternion.cuh>
#include <CameraSettings.cuh>
#include <Ray.cuh>
#include <vector>
#include <cmath>

#include <iostream>

using ScalarVector3 = Vec3<float>;

class Camera
{
public:
    template <typename T>
    explicit Camera(const Vec3<T> origin, const Quaternion orientation, const CameraSettings settings)
        : origin{origin},
          orientation{orientation},
          forwardVec{this->orientation.rotate({0., 0., -1.})},
          rightVec{this->orientation.rotate({1., 0., 0.})},
          upVec{this->orientation.rotate({0., 1., 0.})},
          cameraSettings{settings}
    {
        aspectRatio = static_cast<double>(cameraSettings.width) / static_cast<double>(cameraSettings.height);
        viewportHeight = 2.0 * std::tan(cameraSettings.fov / 2.0);
        viewportWidth = aspectRatio * viewportHeight;
    }

    Ray<float> generateRay(std::uint32_t x, std::uint32_t y);

private:
    ScalarVector3 origin;

    Quaternion orientation;
    ScalarVector3 forwardVec;
    ScalarVector3 rightVec;
    ScalarVector3 upVec;

    CameraSettings cameraSettings;
    double aspectRatio;
    double viewportHeight;
    double viewportWidth;
};