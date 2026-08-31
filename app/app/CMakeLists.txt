qt_add_executable(RayTracer
    src/main.cpp
)

target_link_libraries(RayTracer
    PUBLIC
        rt_gui
    PRIVATE
        rt_core
)

set_target_properties(RayTracer PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)
