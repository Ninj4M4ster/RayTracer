#include <gtest/gtest.h>

#include <Camera.cuh>
#include <Matchers.hpp>
#include <cmath>


namespace {
const ScalarVector3 origin{0.0, 0.0, 0.0};
const Quaternion orientation{1.0, {0.0, 0.0, 0.0}};
const std::uint32_t width{1920};
const std::uint32_t height{1080};
const CameraSettings cameraSettings{width, height, M_PI / 2.0};
}

class TestCamera : public testing::Test {
protected:
    Camera sut{origin, orientation, cameraSettings};
};

TEST_F(TestCamera, GenerateRay) {
    const auto topLeftRay{sut.generateRay(0, 0)};
    const auto bottomLeftRay{sut.generateRay(0, height - 1)};
    const auto topRightRay{sut.generateRay(width - 1, 0)};
    const auto bottomRightRay{sut.generateRay(width - 1, height - 1)};

    EXPECT_THAT(topLeftRay.origin, Vec3Near(origin, 1e-4));
    EXPECT_THAT(bottomLeftRay.origin, Vec3Near(origin, 1e-4));
    EXPECT_THAT(topRightRay.origin, Vec3Near(origin, 1e-4));
    EXPECT_THAT(bottomRightRay.origin, Vec3Near(origin, 1e-4));

    const auto oppositeXDirectionToTopRightRay{topRightRay.direction * Vec3<float>{-1.0, 1.0, 1.0}};
    std::cout << topLeftRay << ", " << bottomLeftRay << std::endl;
    EXPECT_THAT(topLeftRay.direction, Vec3Near(oppositeXDirectionToTopRightRay, 1e-3));

    const auto oppositeYDirectionToBottomLeftRay{bottomLeftRay.direction * Vec3<float>{1.0, -1.0, 1.0}};
    EXPECT_THAT(topLeftRay.direction, Vec3Near(oppositeYDirectionToBottomLeftRay, 1e-3));

    const auto oppositeXYDirectionToBottomRighttRay{bottomRightRay.direction * Vec3<float>{-1.0, -1.0, 1.0}};
    EXPECT_THAT(topLeftRay.direction, Vec3Near(oppositeXYDirectionToBottomRighttRay, 1e-3));
    
    const auto rayCenter{sut.generateRay(width / 2, height / 2)};
    const Vec3<float> expectedDirection{0.0, 0.0, -1.0};
    EXPECT_THAT(rayCenter.origin, Vec3Near(origin, 1e-4));
    EXPECT_THAT(
        rayCenter.direction,
        Vec3Near(expectedDirection, 1e-3));
}