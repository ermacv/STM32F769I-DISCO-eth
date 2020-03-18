###############################################################################
#Setup common options
###############################################################################
#CPU specific modes
set(cpu_common_modes "-mcpu=cortex-m7" CACHE INTERNAL "")
#Need to check this option
# set(cpu_common_modes "${cpu_common_modes} -mtune=cortex-m4")
set(cpu_common_modes "${cpu_common_modes} -mlittle-endian" CACHE INTERNAL "")
set(cpu_common_modes "${cpu_common_modes} -mthumb" CACHE INTERNAL "")
set(cpu_common_modes "${cpu_common_modes} -mabi=aapcs" CACHE INTERNAL "")
set(cpu_common_modes "${cpu_common_modes} -mfloat-abi=hard" CACHE INTERNAL "")
set(cpu_common_modes "${cpu_common_modes} -mfpu=fpv5-d16" CACHE INTERNAL "")
###############################################################################
#Compiler specific flags
set(compiler_common_flags "-ffunction-sections" CACHE INTERNAL "")
set(compiler_common_flags "${compiler_common_flags} -fdata-sections" CACHE INTERNAL "")
set(compiler_common_flags "${compiler_common_flags} -fno-strict-aliasing" CACHE INTERNAL "")
set(compiler_common_flags "${compiler_common_flags} -fno-builtin" CACHE INTERNAL "")
set(compiler_common_flags "${compiler_common_flags} -fshort-enums" CACHE INTERNAL "")
###############################################################################
#Common warnings
set(compiler_common_warnings "-Wall" CACHE INTERNAL "")
# set(compiler_common_warnings "${compiler_common_warnings} -Werror" CACHE INTERNAL "")

###############################################################################
#Setup C options
###############################################################################
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${cpu_common_modes}" CACHE INTERNAL "")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${compiler_common_flags}" CACHE INTERNAL "")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${compiler_common_warnings}" CACHE INTERNAL "")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99" CACHE INTERNAL "")
###############################################################################
#Setup CXX options
###############################################################################
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${cpu_common_modes}" CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${compiler_common_flags}" CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${compiler_common_warnings}" CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} std=c++11" CACHE INTERNAL "")
###############################################################################
#Setup ASM options
###############################################################################
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${cpu_common_modes}" CACHE INTERNAL "")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${compiler_common_flags}" CACHE INTERNAL "")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${compiler_common_warnings}" CACHE INTERNAL "")
###############################################################################
#Setup Linker options
###############################################################################
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${cpu_common_modes}" CACHE INTERNAL "")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${compiler_common_flags}" CACHE INTERNAL "")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${compiler_common_warnings}" CACHE INTERNAL "")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--gc-sections" CACHE INTERNAL "")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --specs=nano.specs" CACHE INTERNAL "")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --specs=nosys.specs" CACHE INTERNAL "")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lc" CACHE INTERNAL "")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lnosys" CACHE INTERNAL "")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lm" CACHE INTERNAL "")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lc_nano" CACHE INTERNAL "")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${CMAKE_PROJECT_NAME}.map" CACHE INTERNAL "")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--print-memory-usage" CACHE INTERNAL "")
