#include <objects/Sphere.cuh>

RT_HD
bool Sphere::intersect(
    const Ray &ray,
    float &t,
    ScalarVector3 &normal) const
{
    const ScalarVector3 oc = ray.origin - position;

    const float b = ray.direction.dot(oc);
    const float c = oc.dot(oc) - radius * radius;

    const float h = b * b - c;

    if (h < 0.0f)
        return false;

    const float sqrtH = sqrtf(h);

    float tHit = -b - sqrtH;

    if (tHit <= 0.0f)
        tHit = -b + sqrtH;

    if (tHit <= 0.0f)
        return false;

    t = tHit;

    const ScalarVector3 hit =
        ray.origin + ray.direction * t;

    normal = (hit - position) / radius;

    return true;
}