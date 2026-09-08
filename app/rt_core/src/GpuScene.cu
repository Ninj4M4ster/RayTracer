#include <GpuScene.cuh>
#include <objects/Sphere.cuh>
#include <iostream>

GpuScene::GpuScene(const Scene &scene)
{
    std::vector<Sphere> gpuSpheres;

    for (const auto &obj : scene.getObjects())
    {
        if (!obj)
            continue;

        if (obj->objectType == ObjectType::SPHERE)
        {
            gpuSpheres.push_back(*static_cast<Sphere *>(obj.get()));
        }
    }

    sphereCount = static_cast<int>(gpuSpheres.size());

    if (sphereCount > 0)
    {
        size_t bytes = gpuSpheres.size() * sizeof(Sphere);
        cudaError_t err = cudaMalloc(&spheres, bytes);
        if (err != cudaSuccess)
        {
            std::cerr << "cudaMalloc spheres: " << cudaGetErrorString(err) << '\n';
            spheres = nullptr;
            sphereCount = 0;
        }
        else
        {
            err = cudaMemcpy(spheres, gpuSpheres.data(), bytes, cudaMemcpyHostToDevice);
            if (err != cudaSuccess)
            {
                std::cerr << "cudaMemcpy spheres: " << cudaGetErrorString(err) << '\n';
                cudaFree(spheres);
                spheres = nullptr;
                sphereCount = 0;
            }
        }
    }
    else
    {
        spheres = nullptr;
    }

    if (const auto lightInScene = scene.getLight())
    {
        cudaError_t err = cudaMalloc(&light, sizeof(Light));
        if (err != cudaSuccess)
        {
            std::cerr << "cudaMalloc light: " << cudaGetErrorString(err) << '\n';
            light = nullptr;
        }
        else
        {
            // copy the underlying Light object, not the smart pointer
            err = cudaMemcpy(light, lightInScene.get(), sizeof(Light), cudaMemcpyHostToDevice);
            if (err != cudaSuccess)
            {
                std::cerr << "cudaMemcpy light: " << cudaGetErrorString(err) << '\n';
                cudaFree(light);
                light = nullptr;
            }
        }
    }
}

void GpuScene::free()
{
    if (spheres)
    {
        cudaFree(spheres);
        spheres = nullptr;
    }
    if (light)
    {
        cudaFree(light);
        light = nullptr;
    }

    sphereCount = 0;
}
