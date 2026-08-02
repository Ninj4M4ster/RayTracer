#include <gmock/gmock.h>

MATCHER_P2(Vec3Near, expected, eps,
           "is within " + ::testing::PrintToString(eps) +
           " of " + ::testing::PrintToString(expected))
{
    return std::abs(arg.x - expected.x) < eps &&
           std::abs(arg.y - expected.y) < eps &&
           std::abs(arg.z - expected.z) < eps;
}