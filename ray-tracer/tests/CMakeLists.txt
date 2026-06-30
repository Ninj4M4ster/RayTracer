add_executable(raytracer_tests
    TestCamera.cpp
    TestVec3.cpp
)

target_include_directories(raytracer_tests
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/utils
)

target_link_libraries(raytracer_tests
    PRIVATE
        raytracer
        GTest::gtest_main
        gmock_main
)

include(GoogleTest)

gtest_discover_tests(raytracer_tests)