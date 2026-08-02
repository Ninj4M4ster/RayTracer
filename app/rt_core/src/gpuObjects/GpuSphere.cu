#include <gpuObjects/GpuSphere.cuh>

RT_HD bool GpuSphere::intersect(const Ray &ray,
                                float &t)
{
    ScalarVector3 L = ray.origin - position;

    float a = ray.direction.dot(ray.direction);
    float b = 2.0f * ray.direction.dot(L);
    float c = L.dot(L) - radius * radius;

    float delta = b * b - 4.0f * a * c;

    if (delta < 0.0f)
        return false;

    delta = sqrtf(delta);

    float t1 = (-b - delta) / (2.0f * a);
    float t2 = (-b + delta) / (2.0f * a);

    t = min(t1, t2);
    return true;
}
