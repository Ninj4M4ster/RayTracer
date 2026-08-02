#include <GpuScene.cuh>

GpuScene::GpuScene(const Scene &scene)
{
    std::vector<GpuSphere> gpuSpheres;

    for (const auto &obj : scene.getObjects())
    {
        if (auto sphere = dynamic_cast<Sphere *>(obj.get()))
        {
            gpuSpheres.push_back({sphere->position,
                                  sphere->radius});
            sphereCount++;
        }
    }

    cudaMalloc(&spheres,
               gpuSpheres.size() * sizeof(GpuSphere));

    cudaMemcpy(spheres,
               gpuSpheres.data(),
               gpuSpheres.size() * sizeof(GpuSphere),
               cudaMemcpyHostToDevice);
}

RT_HD GpuScene::~GpuScene()
{
    cudaFree(spheres);
}