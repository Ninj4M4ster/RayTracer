cmake_minimum_required(VERSION 3.24)

project(
    RayTracer
    VERSION 1.0
    DESCRIPTION "CUDA Ray Tracer"
    LANGUAGES CXX CUDA
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CUDA_STANDARD 20)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CUDA_ARCHITECTURES native)

# Library
add_library(raytracer STATIC 
    src/Camera.cu
    src/CpuRenderer.cu
)

target_include_directories(raytracer
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_compile_features(raytracer PUBLIC cxx_std_20)

target_compile_options(raytracer
    PRIVATE
        $<$<COMPILE_LANGUAGE:CXX>:-Wall -Wextra -Wpedantic>
        $<$<COMPILE_LANGUAGE:CUDA>:--expt-relaxed-constexpr>
)

set_target_properties(raytracer PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)

# Executable
add_executable(RayTracer
    src/main.cu
)

target_link_libraries(RayTracer
    PRIVATE
        raytracer
)

set_target_properties(RayTracer PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)

# Google Test
include(CTest)
enable_testing()

include(FetchContent)

FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/refs/tags/v1.17.0.zip
)

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(googletest)

add_subdirectory(tests)
