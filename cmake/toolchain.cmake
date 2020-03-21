#CPU setup
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
#System paths

set(COMPILER_PATH "")

if(DEFINED ENV{ARM_GCC_COMPILER_DIR})
	set(COMPILER_PATH $ENV{ARM_GCC_COMPILER_DIR} CACHE INTERNAL "ARM_GCC_COMPILER_DIR path")
else()
	message("Please provide an environment variable ARM_GCC_COMPILER_DIR\n")
endif()

SET(COMPILER_PREFIX arm-none-eabi)
set(COMPILER_PATH ${ARM_GCC_COMPILER_DIR})
SET(COMPILER_BIN "${COMPILER_PATH}/bin")


set(COMPILER_VERSION "6.2.1")

execute_process(COMMAND ${COMPILER_BIN}/${COMPILER_PREFIX}-gcc -dumpversion 
				OUTPUT_VARIABLE COMPILER_VERSION 
				OUTPUT_STRIP_TRAILING_WHITESPACE)

SET(TOOLCHAIN_LIB_DIR "${COMPILER_PATH}/${COMPILER_PREFIX}/lib/thumb/v7e-m+dp/hard")
SET(TOOLCHAIN_INC_DIR "${COMPILER_PATH}/${COMPILER_PREFIX}/include")
set(LIBLTO_PATH "${COMPILER_PATH}/lib/gcc/${COMPILER_PREFIX}/${COMPILER_VERSION}/liblto_plugin.so")

SET(CMAKE_C_COMPILER "${COMPILER_BIN}/${COMPILER_PREFIX}-gcc" CACHE INTERNAL "")
SET(CMAKE_ASM_COMPILER "${COMPILER_BIN}/${COMPILER_PREFIX}-gcc" CACHE INTERNAL "")
SET(CMAKE_CXX_COMPILER "${COMPILER_BIN}/${COMPILER_PREFIX}-g++" CACHE INTERNAL "")
SET(CMAKE_OBJCOPY "${COMPILER_BIN}/${COMPILER_PREFIX}-objcopy" CACHE INTERNAL "")
SET(CMAKE_SIZE "${COMPILER_BIN}/${COMPILER_PREFIX}-size" CACHE INTERNAL "")
SET(CMAKE_OBJDUMP "${COMPILER_BIN}/${COMPILER_PREFIX}-objdump" CACHE INTERNAL "")
SET(CMAKE_LINKER "${COMPILER_BIN}/${COMPILER_PREFIX}-ld" CACHE INTERNAL "")
SET(CMAKE_RANLIB "${COMPILER_BIN}/${COMPILER_PREFIX}-ranlib" CACHE INTERNAL "")
SET(CMAKE_AR "${COMPILER_BIN}/${COMPILER_PREFIX}-ar" CACHE INTERNAL "")
SET(CMAKE_NM "${COMPILER_BIN}/${COMPILER_PREFIX}-nm" CACHE INTERNAL "")
SET(CMAKE_STRIP "${COMPILER_BIN}/${COMPILER_PREFIX}-strip" CACHE INTERNAL "")

SET(CMAKE_C_FLAGS "-isystem ${TOOLCHAIN_INC_DIR}" CACHE INTERNAL "C compiler sysroot")
SET(CMAKE_CXX_FLAGS "-isystem ${TOOLCHAIN_INC_DIR}" CACHE INTERNAL "CXX compiler sysroot")
SET(CMAKE_ASM_FLAGS "-isystem ${TOOLCHAIN_INC_DIR}" CACHE INTERNAL "ASM compiler sysroot")
#setup path for precompiled libs
set(CMAKE_EXE_LINKER_FLAGS "-L${TOOLCHAIN_LIB_DIR}" CACHE INTERNAL "")
#To enable lto need to provide this string
set(CMAKE_C_CREATE_STATIC_LIBRARY "<CMAKE_AR> -cr --plugin=${LIBLTO_PATH} <LINK_FLAGS> <TARGET> <OBJECTS>")
#Cmake compiles a lib before building a project
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
#Cmake search dirs
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)