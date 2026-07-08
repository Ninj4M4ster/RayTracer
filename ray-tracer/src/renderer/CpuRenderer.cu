#include <renderer/CpuRenderer.cuh>
#include <limits>

void CpuRenderer::render(FrameBuffer &frameBuffer, const Scene &scene, const Camera &camera)
{
    for (std::uint32_t y = 0; y < frameBuffer.height; ++y)
    {
        for (std::uint32_t x = 0; x < frameBuffer.width; ++x)
        {
            auto ray = camera.generateRay(x, y);
            std::optional<float> min_t = std::nullopt;
            for (const auto &obj : scene.getObjects())
            {
                auto t_opt = obj->intersect(ray);
                if (!min_t.has_value())
                {
                    min_t = t_opt;
                }
                else if (t_opt && *t_opt < *min_t)
                {
                    min_t = t_opt;
                }
            }

            if (min_t)
            {
                frameBuffer.pixels[y * frameBuffer.width + x] = Color(50.0 / 255.0, 50.0 / 255.0, 50.0 / 255.0);
            }
            else
            {
                frameBuffer.pixels[y * frameBuffer.width + x] = Color(192.0 / 255.0, 210.0 / 255.0, 240.0 / 255.0);
            }
        }
    }
}