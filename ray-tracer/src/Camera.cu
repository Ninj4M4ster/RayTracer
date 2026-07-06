#include <Camera.cuh>
#include <assert.h>

Ray Camera::generateRay(std::uint32_t x, std::uint32_t y) const
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

    return Ray{origin, rayDirection};
}

std::vector<Ray> Camera::generateAllImageRays()
{
    std::vector<Ray> rays(cameraSettings.width * cameraSettings.height);

    for (std::uint32_t y = 0; y < cameraSettings.height; ++y)
    {
        for (std::uint32_t x = 0; x < cameraSettings.width; ++x)
        {
            rays.push_back(generateRay(x, y));
        }
    }

    return rays;
}