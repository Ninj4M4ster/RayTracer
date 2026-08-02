#include <renderer/GpuRenderer.cuh>
#include <GpuScene.cuh>
#include <cuda_runtime_api.h>
#include <cuda/cmath>
#include <limits>

RT_G void renderPixel(
    Color *frameBuff,
    int width,
    int height,
    GpuScene scene,
    Camera camera)
{
    int workIndex = threadIdx.x + blockIdx.x * blockDim.x;

    if (workIndex >= width * height)
        return;

    int x = workIndex % width;
    int y = workIndex / width;

    auto ray = camera.generateRay(x, y);

    float min_t = 100000000.0f;
    bool hit = false;

    for (int i = 0; i < scene.sphereCount; ++i)
    {
        float t;

        if (scene.spheres[i].intersect(ray, t) && t < min_t)
        {
            min_t = t;
            hit = true;
        }
    }

    if (hit)
    {
        frameBuff[workIndex] =
            Color(50.0f / 255.0f,
                  50.0f / 255.0f,
                  50.0f / 255.0f);
    }
    else
    {
        frameBuff[workIndex] =
            Color(192.0f / 255.0f,
                  210.0f / 255.0f,
                  240.0f / 255.0f);
    }
}

void GpuRenderer::render(FrameBuffer &frameBuffer, const GpuScene &scene, const Camera &camera)
{
    Color *deviceFrameBuffer;
    const std::size_t frameBufferSize{frameBuffer.height * frameBuffer.width * sizeof(Color)};
    cudaMalloc(&deviceFrameBuffer, frameBufferSize);

    constexpr int threads = 256;
    const int pixels = frameBuffer.width * frameBuffer.height;
    const int blocks = (pixels + threads - 1) / threads;
    renderPixel<<<blocks, threads>>>(
        deviceFrameBuffer,
        frameBuffer.width,
        frameBuffer.height,
        scene,
        camera);
    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess)
    {
        std::cerr << cudaGetErrorString(err) << '\n';
    }

    cudaDeviceSynchronize();

    err = cudaGetLastError();
    if (err != cudaSuccess)
    {
        std::cerr << cudaGetErrorString(err) << '\n';
    }
    cudaMemcpy(frameBuffer.pixels.data(), deviceFrameBuffer, frameBufferSize, cudaMemcpyDefault);

    cudaFree(deviceFrameBuffer);
}