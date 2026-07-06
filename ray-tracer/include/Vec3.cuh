#pragma once

#include <cstdint>
#include <cmath>
#include <ostream>

template <typename T>
class Vec3
{
public:
    Vec3() = default;
    Vec3(const T &x, const T &y, const T &z) : x{x}, y{y}, z{z} {}

    float length() const
    {
        return std::sqrt(x * x + y * y + z * z);
    }

    Vec3 normalized() const
    {
        return *this / length();
    }

    float dot(const Vec3 &r) const
    {
        return {x * r.x + y * r.y + z * r.z};
    }

    Vec3 crossProduct(const Vec3 &r) const
    {
        return {y * r.z - z * r.y, z * r.x - x * r.z, x * r.y - y * r.x};
    }

    T x, y, z;
};

template <typename T>
std::ostream &operator<<(std::ostream &os, const Vec3<T> vec)
{
    os << "(" << vec.x << ", " << vec.y << ", " << vec.z << ")";
    return os;
}

template <typename T>
Vec3<T> operator+(const Vec3<T> &l, const Vec3<T> &r)
{
    return Vec3{l.x + r.x, l.y + r.y, l.z + r.z};
}

template <typename T>
Vec3<T> operator-(const Vec3<T> &l, const Vec3<T> &r)
{
    return Vec3{l.x - r.x, l.y - r.y, l.z - r.z};
}

template <typename T>
Vec3<T> operator/(const Vec3<T> &l, const float &r)
{
    return Vec3{l.x / r, l.y / r, l.z / r};
}

template <typename T>
Vec3<T> operator*(const Vec3<T> &l, const Vec3<T> &r)
{
    return Vec3{l.x * r.x, l.y * r.y, l.z * r.z};
}

template <typename T>
Vec3<T> operator*(const Vec3<T> &l, const float &r)
{
    return Vec3{l.x * r, l.y * r, l.z * r};
}

template <typename T>
Vec3<T> operator*(const float &l, const Vec3<T> &r)
{
    return r * l;
}

template <typename T>
bool operator==(const Vec3<T> &l, const Vec3<T> &r)
{
    return l.x == r.x && l.y == r.y && l.z == r.z;
}

using ScalarVector3 = Vec3<float>;
