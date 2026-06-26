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

add_executable(RayTracer
    src/main.cu
)

target_include_directories(RayTracer
    PRIVATE
        include
)

target_compile_features(RayTracer PRIVATE cxx_std_20)

target_compile_options(RayTracer
    PRIVATE
        $<$<COMPILE_LANGUAGE:CXX>:-Wall -Wextra -Wpedantic>
        $<$<COMPILE_LANGUAGE:CUDA>:--expt-relaxed-constexpr>
)

set_target_properties(RayTracer PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)