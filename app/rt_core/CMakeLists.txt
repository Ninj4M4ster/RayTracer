add_library(raytracer_core STATIC
    src/gpuObjects/GpuSphere.cu
    src/objects/Sphere.cu
    src/Camera.cu
    src/GpuScene.cu
    src/renderer/CpuRenderer.cu
    src/renderer/GpuRenderer.cu
)

target_include_directories(raytracer_core
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_compile_features(raytracer_core PUBLIC cxx_std_20)

target_compile_options(raytracer_core
    PRIVATE
        $<$<COMPILE_LANGUAGE:CXX>:-Wall -Wextra -Wpedantic>
        $<$<COMPILE_LANGUAGE:CUDA>:--expt-relaxed-constexpr>
)

set_target_properties(raytracer_core PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)

add_subdirectory(tests)
