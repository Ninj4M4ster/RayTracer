#include <renderer/GpuRenderer.cuh>
#include <GpuScene.cuh>
#include <cuda_runtime_api.h>
#include <cuda/cmath>
#include <limits>

GpuRenderer::~GpuRenderer()
{
    if (deviceFrameBuffer)
    {
        cudaFree(deviceFrameBuffer);
    }
    capacity = 0;
}

void GpuRenderer::resize(int width, int height)
{
    const std::size_t required =
        static_cast<std::size_t>(width) *
        static_cast<std::size_t>(height) *
        sizeof(Color);

    if (required <= capacity)
        return;

    if (deviceFrameBuffer)
    {
        cudaError_t err = cudaFree(deviceFrameBuffer);

        if (err != cudaSuccess)
        {
            throw std::runtime_error(
                std::string("cudaFree failed: ") +
                cudaGetErrorString(err));
        }

        deviceFrameBuffer = nullptr;
        capacity = 0;
    }

    cudaError_t err = cudaMalloc(
        reinterpret_cast<void **>(&deviceFrameBuffer),
        required);

    if (err != cudaSuccess)
    {
        throw std::runtime_error(
            std::string("cudaMalloc framebuffer failed: ") +
            cudaGetErrorString(err));
    }

    capacity = required;
}

RT_G void renderPixel(
    Color *__restrict__ frameBuff,
    int width,
    int height,
    const GpuSceneView scene,
    const Camera camera)
{
    const int x = threadIdx.x + blockIdx.x * blockDim.x;
    const int y = threadIdx.y + blockIdx.y * blockDim.y;

    if (x >= width || y >= height)
        return;

    const int workIndex = y * width + x;

    auto ray = camera.generateRay(x, y);

    float min_t = 100000000.0f;
    ScalarVector3 minNormal;
    Sphere *minObject = nullptr;
    bool hit = false;

    if (scene.spheres)
    {
        for (int i = 0; i < scene.sphereCount; ++i)
        {
            float t;
            ScalarVector3 normal;
            if (scene.spheres[i].intersect(ray, t, normal) && t > 0.f && t < min_t)
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
            const auto dirToLight = (light->position - hitPose).normalized();
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
    resize(frameBuffer.width, frameBuffer.height);

    const int pixels =
        frameBuffer.width * frameBuffer.height;

    if (pixels <= 0)
        return;

    constexpr int threadsX = 16;
    constexpr int threadsY = 16;
    const dim3 threads(threadsX, threadsY);
    const dim3 blocks(
        (frameBuffer.width + threadsX - 1) / threadsX,
        (frameBuffer.height + threadsY - 1) / threadsY);

    renderPixel<<<blocks, threads>>>(
        deviceFrameBuffer,
        frameBuffer.width,
        frameBuffer.height,
        scene.view(),
        camera);

    cudaError_t err = cudaGetLastError();

    if (err != cudaSuccess)
    {
        throw std::runtime_error(
            std::string("Kernel launch failed: ") +
            cudaGetErrorString(err));
    }

    err = cudaMemcpyAsync(
        frameBuffer.pixels.data(),
        deviceFrameBuffer,
        static_cast<std::size_t>(pixels) * sizeof(Color),
        cudaMemcpyDeviceToHost);

    if (err != cudaSuccess)
    {
        throw std::runtime_error(
            std::string("cudaMemcpyAsync failed: ") +
            cudaGetErrorString(err));
    }

    err = cudaStreamSynchronize(0);

    if (err != cudaSuccess)
    {
        throw std::runtime_error(
            std::string("Kernel execution failed: ") +
            cudaGetErrorString(err));
    }
}