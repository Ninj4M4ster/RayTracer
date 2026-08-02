qt_add_executable(RayTracer
    src/main.cpp
)

target_link_libraries(RayTracer
    PRIVATE
        raytracer_core     
        Qt6::Core
        Qt6::Gui
        Qt6::Widgets
)

set_target_properties(RayTracer PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)
