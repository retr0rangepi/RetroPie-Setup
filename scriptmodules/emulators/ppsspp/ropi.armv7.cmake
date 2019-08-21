include_directories(SYSTEM
  /usr/include
)

set(ARCH_FLAGS "-O2 -march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard -ftree-vectorize -funsafe-math-optimizations -pipe")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${ARCH_FLAGS}"  CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ARCH_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${ARCH_FLAGS}" CACHE STRING "" FORCE)
set(OPENGL_LIBRARIES GLESv2)
set(USING_GLES2 ON)
set(ARMV7 ON)
set(USING_EGL OFF)
set(USING_FBDEV ON)
