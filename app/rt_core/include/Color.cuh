#pragma once

#include <CudaCompat.cuh>

// TODO(Jakub Drzewiecki): Define color for uint8_t directly
struct Color
{
    float r;
    float g;
    float b;
};

RT_HD
inline Color operator*(const Color &l, const float &r)
{
    return Color{l.r * r, l.g * r, l.b * r};
}

RT_HD
inline Color operator*(const float &l, const Color &r)
{
    return r * l;
}
