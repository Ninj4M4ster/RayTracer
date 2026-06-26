PROJECT := ray-tracer

DEBUG_DIR := $(PROJECT)/build/debug
RELEASE_DIR := $(PROJECT)/build/release

.PHONY: build run clean

build:
	cmake -S $(PROJECT) -B $(DEBUG_DIR) -DCMAKE_BUILD_TYPE=Debug
	cmake --build $(DEBUG_DIR)

release:
	cmake -S $(PROJECT) -B $(RELEASE_DIR) -DCMAKE_BUILD_TYPE=Release
	cmake --build $(RELEASE_DIR)

run: build
	./$(DEBUG_DIR)/RayTracer

run-release: release
	./$(RELEASE_DIR)/RayTracer

clean:
	rm -rf $(PROJECT)/build
