#include <gtest/gtest.h>
#include <FrameBuffer.cuh>


TEST(TestFrameBuffer, DataBufferMatchesRGBLayout)
{
    FrameBuffer fb(2u, 2u);
    fb.pixels = {
        Color{1.0f, 0.0f, 0.0f},
        Color{0.0f, 1.0f, 0.0f},
        Color{0.0f, 0.0f, 1.0f},
        Color{1.0f, 1.0f, 1.0f},
    };

    const auto *bytes = fb.data();

    ASSERT_NE(bytes, nullptr);
    EXPECT_EQ(fb.byteSize(), static_cast<std::size_t>(2u * 2u * 3u));
    EXPECT_EQ(bytes[0], 255u);
    EXPECT_EQ(bytes[1], 0u);
    EXPECT_EQ(bytes[2], 0u);
    EXPECT_EQ(bytes[3], 0u);
    EXPECT_EQ(bytes[4], 255u);
    EXPECT_EQ(bytes[5], 0u);
    EXPECT_EQ(bytes[6], 0u);
    EXPECT_EQ(bytes[7], 0u);
    EXPECT_EQ(bytes[8], 255u);
    EXPECT_EQ(bytes[9], 255u);
    EXPECT_EQ(bytes[10], 255u);
    EXPECT_EQ(bytes[11], 255u);
}

TEST(TestFrameBuffer, ResizeUpdatesDimensionsAndBufferSize)
{
    FrameBuffer fb(2u, 2u);
    fb.resize(4u, 3u);

    EXPECT_EQ(fb.width, 4u);
    EXPECT_EQ(fb.height, 3u);
    EXPECT_EQ(fb.pixels.size(), static_cast<std::size_t>(4u * 3u));
    EXPECT_EQ(fb.byteSize(), static_cast<std::size_t>(4u * 3u * 3u));
}
