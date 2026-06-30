#include <iostream>
#include <Vec3.cuh>
#include <Camera.cuh>

int main()
{
    ScalarVector3 origin{0.0, 0.0, 0.0};
    Quaternion orientation{1.0, {0.0, 0.0, 0.0}};
    CameraSettings settings{1920, 1080, M_PI / 2.0};
    Camera cam{origin, orientation, settings};
    std::uint32_t x = 0, y = 1;

    std::cout << cam.generateRay(x, y) << std::endl;

    x = settings.width / 2;
    y = settings.height / 2;

    std::cout << cam.generateRay(x, y) << std::endl;
    return 0;
}