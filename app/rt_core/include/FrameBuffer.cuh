#pragma once

#include <cstdint>
#include <vector>
#include <iostream>

#include <Color.cuh>

struct FrameBuffer
{
    FrameBuffer(std::uint32_t width, std::uint32_t height) : width(width), height(height)
    {
        pixels.resize(width * height);
    }

    const uint8_t *data()
    {
        bytePixels.clear();
        bytePixels.reserve(width * height * 3);

        for (const auto &color : pixels)
        {
            bytePixels.push_back(static_cast<std::uint8_t>(std::clamp(color.r * 255.0f, 0.0f, 255.0f)));
            bytePixels.push_back(static_cast<std::uint8_t>(std::clamp(color.g * 255.0f, 0.0f, 255.0f)));
            bytePixels.push_back(static_cast<std::uint8_t>(std::clamp(color.b * 255.0f, 0.0f, 255.0f)));
        }

        return bytePixels.data();
    }

    std::uint32_t width;
    std::uint32_t height;
    std::vector<Color> pixels;

private:
    std::vector<std::uint8_t> bytePixels;
};