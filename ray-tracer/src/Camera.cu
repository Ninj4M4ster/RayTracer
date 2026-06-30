#include <Camera.cuh>
#include <assert.h>

Ray<float> Camera::generateRay(std::uint32_t x, std::uint32_t y)
{
    assert(x < cameraSettings.width);
    assert(y < cameraSettings.height);
    auto u = (static_cast<double>(x) + 0.5) / static_cast<double>(cameraSettings.width);
    auto v = (static_cast<double>(y) + 0.5) / static_cast<double>(cameraSettings.height);
    auto px = (2.0 * u - 1.0) * viewportWidth / 2.0;
    auto py = (1.0 - 2.0 * v) * viewportHeight / 2.0;

    ScalarVector3 imagePoint =
        origin +
        forwardVec +
        px * rightVec +
        py * upVec;

    ScalarVector3 rayDirection =
        (imagePoint - origin).normalized();

    return Ray<float>{origin, rayDirection};
}