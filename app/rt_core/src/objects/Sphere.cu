#include <objects/Sphere.cuh>

bool Sphere::intersect(const Ray &ray, float &t, ScalarVector3 &normal)
{
    ScalarVector3 L = ray.origin - position;
    float a = ray.direction.dot(ray.direction);
    float b = 2 * ray.direction.dot(L);
    float c = L.dot(L) - (radius * radius);

    if (float delta = (b * b) - 4.0 * a * c; delta > 0.0)
    {
        delta = sqrt(delta);
        float t1 = (-b - delta) / (2.0 * a);
        float t2 = (-b + delta) / (2.0 * a);
        t = std::min(t1, t2);
        normal = (ray.pointOfIntersection(t) - position) / radius;
        return true;
    }
    return false;
}