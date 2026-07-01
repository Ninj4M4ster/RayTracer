#pragma once

#include <cstdint>
#include <vector>

#include <Color.cuh>

struct FrameBuffer
{
    FrameBuffer(std::uint32_t width, std::uint32_t height) : width(width), height(height)
    {
        pixels.resize(width * height);
    }

    std::uint32_t width;
    std::uint32_t height;
    std::vector<Color> pixels;
};