add_library(rt_gui STATIC
    src/MainWindow.cpp
    src/RenderController.cpp
    src/RenderWorker.cpp
    include/MainWindow.hpp
    include/RenderController.hpp
    include/RenderWorker.hpp
)

target_include_directories(rt_gui
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(rt_gui
    PUBLIC
        Qt6::Core
        Qt6::Gui
        Qt6::Widgets

    PRIVATE
        rt_core
)

target_compile_features(rt_gui
    PUBLIC
        cxx_std_20
)

set_target_properties(rt_gui PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)
