#include <renderer/CpuRenderer.cuh>
#include <limits>

void CpuRenderer::render(FrameBuffer &frameBuffer, const Scene &scene, const Camera &camera)
{
    for (std::uint32_t y{0}; y < frameBuffer.height; ++y)
    {
        for (std::uint32_t x{0}; x < frameBuffer.width; ++x)
        {
            auto ray{camera.generateRay(x, y)};
            float min_t{std::numeric_limits<float>::max()};
            ScalarVector3 minNormal;
            std::shared_ptr<Object> minObject;
            bool hit_flag{false};
            for (const auto &obj : scene.getObjects())
            {
                float t;
                ScalarVector3 normal;
                if (obj->intersect(ray, t, normal))
                {
                    hit_flag = true;
                    if (t > 0 && t < min_t)
                    {
                        minNormal = normal;
                        min_t = t;
                        minObject = obj;
                    }
                }
            }

            if (hit_flag)
            {
                const auto light = scene.getLight();
                const auto hitPose = ray.pointOfIntersection(min_t);
                const auto dirToLight = ((light->position - hitPose) / (light->position - hitPose).length()).normalized();
                const auto intensity = std::max(0.0f, minNormal.dot(dirToLight));
                frameBuffer.pixels[y * frameBuffer.width + x] = intensity * minObject->color;
            }
            else
            {
                frameBuffer.pixels[y * frameBuffer.width + x] = Color(192.0 / 255.0, 210.0 / 255.0, 240.0 / 255.0);
            }
        }
    }
}