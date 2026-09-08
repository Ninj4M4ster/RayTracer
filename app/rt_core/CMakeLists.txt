add_library(rt_core STATIC
    src/objects/Sphere.cu
    src/Camera.cu
    src/GpuScene.cu
    src/renderer/CpuRenderer.cu
    src/renderer/GpuRenderer.cu
)

target_include_directories(rt_core
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_compile_features(rt_core PUBLIC cxx_std_20)

target_compile_options(rt_core
    PRIVATE
        $<$<COMPILE_LANGUAGE:CXX>:-Wall -Wextra -Wpedantic>
        $<$<COMPILE_LANGUAGE:CUDA>:--expt-relaxed-constexpr>
)

set_target_properties(rt_core PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)

add_subdirectory(tests)
