#pragma once

#include <cstdint>
#include <vector>
#include <iostream>

#include <Color.cuh>

struct FrameBuffer
{
    FrameBuffer(std::uint32_t width, std::uint32_t height) : width(width), height(height)
    {
        resize(width, height);
    }

    void resize(std::uint32_t newWidth, std::uint32_t newHeight)
    {
        width = newWidth;
        height = newHeight;
        pixels.assign(static_cast<std::size_t>(width) * static_cast<std::size_t>(height), Color{});
        bytePixels.clear();
        bytePixels.resize(byteSize());
    }

    std::size_t byteSize() const
    {
        return static_cast<std::size_t>(width) *
               static_cast<std::size_t>(height) * 3u;
    }

    const uint8_t *data()
    {
        bytePixels.resize(byteSize());

        auto dst = bytePixels.begin();
        for (const auto &color : pixels)
        {
            *dst++ = static_cast<std::uint8_t>(std::clamp(color.r * 255.0f, 0.0f, 255.0f));
            *dst++ = static_cast<std::uint8_t>(std::clamp(color.g * 255.0f, 0.0f, 255.0f));
            *dst++ = static_cast<std::uint8_t>(std::clamp(color.b * 255.0f, 0.0f, 255.0f));
        }

        return bytePixels.empty() ? nullptr : bytePixels.data();
    }

    std::uint32_t width;
    std::uint32_t height;
    std::vector<Color> pixels;

private:
    std::vector<std::uint8_t> bytePixels;
};