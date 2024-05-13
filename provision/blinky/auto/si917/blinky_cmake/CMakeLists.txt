# Define minimal required version of CMake.
cmake_minimum_required(VERSION "3.25")

# Project definition
project(
	blinky
	VERSION 1.0
	LANGUAGES C CXX ASM
)

# Include the definition of the slc_blinky target,
# which contains the content of the SLC project
include(blinky.cmake)

add_executable(blinky
    # Add additional sources here
)

target_include_directories(blinky PUBLIC
    # Add additional include paths here
)

target_compile_definitions(blinky PUBLIC
    # Add additional macros here
)

target_compile_options(blinky PUBLIC
    # Set additional compiler flags here
)

target_link_options(blinky PUBLIC
    # Set additional linker flags here
)

# Link with the content defined in the SLC project
target_link_libraries(blinky PRIVATE
    slc_blinky
)

# Create .bin, .hex and .s37 artifacts after building the project
add_custom_command(TARGET blinky
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O srec "$<TARGET_FILE:blinky>" "$<TARGET_FILE_DIR:blinky>/$<TARGET_FILE_BASE_NAME:blinky>.s37"
    COMMAND ${CMAKE_OBJCOPY} -O ihex "$<TARGET_FILE:blinky>" "$<TARGET_FILE_DIR:blinky>/$<TARGET_FILE_BASE_NAME:blinky>.hex"
    COMMAND ${CMAKE_OBJCOPY} -O binary "$<TARGET_FILE:blinky>" "$<TARGET_FILE_DIR:blinky>/$<TARGET_FILE_BASE_NAME:blinky>.bin" 
)


