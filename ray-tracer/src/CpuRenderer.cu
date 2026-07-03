#include <CpuRenderer.cuh>

void CpuRenderer::render(FrameBuffer &frameBuffer, const Scene &scene, const Camera &camera)
{
    for (std::uint32_t y = 0; y < frameBuffer.height; ++y)
    {
        for (std::uint32_t x = 0; x < frameBuffer.width; ++x)
        {
            // Uncomment after implementing collisions
            // camera.generateRay(x, y);

            float r = static_cast<float>(x) / frameBuffer.width;
            float g = static_cast<float>(y) / frameBuffer.height;
            float b = 0.5f;

            frameBuffer.pixels[y * frameBuffer.width + x] = Color(r, g, b);
        }
    }
}