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
    ScalarVector3 minNormal;
    Sphere *minObject;
    bool hit = false;

    if (scene.spheres)
    {
        for (int i = 0; i < scene.sphereCount; ++i)
        {
            float t;
            ScalarVector3 normal;
            if (scene.spheres[i].intersect(ray, t, normal) && t > 0 && t < min_t)
            {
                hit = true;
                minNormal = normal;
                min_t = t;
                minObject = &scene.spheres[i];
            }
        }
    }

    if (hit)
    {
        const auto light = scene.getLight();
        if (light)
        {
            const auto hitPose = ray.pointOfIntersection(min_t);
            const auto dirToLight = ((light->position - hitPose) / (light->position - hitPose).length()).normalized();
            const auto intensity = std::max(0.0f, minNormal.dot(dirToLight));
            frameBuff[workIndex] = intensity * minObject->color;
        }
        else
        {
            frameBuff[workIndex] =
                Color(50.0f / 255.0f,
                      50.0f / 255.0f,
                      50.0f / 255.0f);
        }
    }
    else
    {
        frameBuff[workIndex] =
            Color(192.0f / 255.0f,
                  210.0f / 255.0f,
                  240.0f / 255.0f);
    }
}

void GpuRenderer::render(
    FrameBuffer &frameBuffer,
    const GpuScene &scene,
    const Camera &camera)
{
    Color *deviceFrameBuffer = nullptr;

    const std::size_t frameBufferSize =
        static_cast<std::size_t>(frameBuffer.width) *
        frameBuffer.height *
        sizeof(Color);

    cudaError_t err;

    err = cudaMalloc(
        reinterpret_cast<void **>(&deviceFrameBuffer),
        frameBufferSize);

    if (err != cudaSuccess)
    {
        std::cerr << "cudaMalloc: "
                  << cudaGetErrorString(err) << '\n';
        return;
    }

    constexpr int threads = 256;

    const int pixels =
        frameBuffer.width * frameBuffer.height;

    const int blocks =
        (pixels + threads - 1) / threads;

    std::cout
        << "Launching kernel: "
        << blocks << " blocks, "
        << threads << " threads, "
        << pixels << " pixels\n";

    renderPixel<<<blocks, threads>>>(
        deviceFrameBuffer,
        frameBuffer.width,
        frameBuffer.height,
        scene,
        camera);

    // Check launch itself.
    err = cudaGetLastError();

    if (err != cudaSuccess)
    {
        std::cerr << "Kernel launch: "
                  << cudaGetErrorString(err) << '\n';

        cudaFree(deviceFrameBuffer);
        return;
    }

    // Check execution.
    err = cudaDeviceSynchronize();

    if (err != cudaSuccess)
    {
        std::cerr << "Kernel execution: "
                  << cudaGetErrorString(err) << '\n';

        cudaFree(deviceFrameBuffer);
        return;
    }

    err = cudaMemcpy(
        frameBuffer.pixels.data(),
        deviceFrameBuffer,
        frameBufferSize,
        cudaMemcpyDeviceToHost);

    if (err != cudaSuccess)
    {
        std::cerr << "cudaMemcpy: "
                  << cudaGetErrorString(err) << '\n';

        cudaFree(deviceFrameBuffer);
        return;
    }

    err = cudaFree(deviceFrameBuffer);

    if (err != cudaSuccess)
    {
        std::cerr << "cudaFree: "
                  << cudaGetErrorString(err) << '\n';
    }
}