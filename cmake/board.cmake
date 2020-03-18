set(SDK_ROOT "/mnt/c/dev/sdk/SDK_2.7.1_LPCXpresso55S69" CACHE INTERNAL "")

set(C_SOURCES
    main.c
    Drivers/CMSIS/Device/ST/STM32F7xx/Source/Templates/system_stm32f7xx.c
)

set(ASM_SOURCES
    Drivers/CMSIS/Device/ST/STM32F7xx/Source/Templates/gcc/startup_stm32f769xx.s
)

set(AS_INCLUDES
)

set(C_INCLUDES
	Drivers/CMSIS/Device/ST/STM32F7xx/Include
	Drivers/CMSIS/Include
)

include_directories(${C_INCLUDES} ${AS_INCLUDES})

set(common_defs "-DSTM32F769xx" CACHE INTERNAL "")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${common_defs}" CACHE INTERNAL "")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${common_defs}" CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${common_defs}" CACHE INTERNAL "")

set(LDSCRIPT STM32F769NIHx_FLASH.ld)
set(CMAKE_EXE_LINKER_FLAGS " -T${CMAKE_SOURCE_DIR}/${LDSCRIPT} ${CMAKE_EXE_LINKER_FLAGS}" CACHE INTERNAL "")
