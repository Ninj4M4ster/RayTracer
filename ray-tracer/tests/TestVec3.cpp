#include <gtest/gtest.h>

#include <Vec3.cuh>

TEST(TestVec, Addition)
{
    Vec3<float> a(1.f, 2.f, 3.f);
    Vec3<float> b(4.f, 5.f, 6.f);

    const auto c = a + b;

    EXPECT_FLOAT_EQ(c.x, 5.f);
    EXPECT_FLOAT_EQ(c.y, 7.f);
    EXPECT_FLOAT_EQ(c.z, 9.f);
}