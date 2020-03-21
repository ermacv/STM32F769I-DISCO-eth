set(C_SOURCES
    main.c
    stm32f7xx_it.c
    stm32f7xx_hal_timebase_tim.c
    Drivers/CMSIS/Device/ST/STM32F7xx/Source/Templates/system_stm32f7xx.c
    Modules/HAL_user/src/HAL_user.c
)

set(ASM_SOURCES
    Drivers/CMSIS/Device/ST/STM32F7xx/Source/Templates/gcc/startup_stm32f769xx.s
)

set(AS_INCLUDES
)

set(C_INCLUDES
    .
	Drivers/CMSIS/Device/ST/STM32F7xx/Include
    Drivers/CMSIS/Include
    Modules/HAL_user/inc
)

set(HAL_src_dir Drivers/STM32F7xx_HAL_Driver/src)
set(HAL_inc_dir Drivers/STM32F7xx_HAL_Driver/inc)
set(HAL_prefix stm32f7xx_hal)

set(HAL_src
    ${HAL_src_dir}/${HAL_prefix}_cortex.c
    ${HAL_src_dir}/${HAL_prefix}_dma.c
    ${HAL_src_dir}/${HAL_prefix}_dma_ex.c
    ${HAL_src_dir}/${HAL_prefix}_eth.c
    ${HAL_src_dir}/${HAL_prefix}_flash.c
    ${HAL_src_dir}/${HAL_prefix}_flash_ex.c
    ${HAL_src_dir}/${HAL_prefix}_gpio.c
    ${HAL_src_dir}/${HAL_prefix}_pwr.c
    ${HAL_src_dir}/${HAL_prefix}_pwr_ex.c
    ${HAL_src_dir}/${HAL_prefix}_rcc.c
    ${HAL_src_dir}/${HAL_prefix}_rcc_ex.c
    ${HAL_src_dir}/${HAL_prefix}_tim.c
    ${HAL_src_dir}/${HAL_prefix}_tim_ex.c
    ${HAL_src_dir}/${HAL_prefix}_usart.c
    ${HAL_src_dir}/${HAL_prefix}.c
)

set(FREERTOS_dir "/mnt/c/dev/lib/FreeRTOSv10.3.1/FreeRTOS/Source")
set(FREERTOS_src
    ${FREERTOS_dir}/croutine.c
    ${FREERTOS_dir}/event_groups.c
    ${FREERTOS_dir}/list.c
    ${FREERTOS_dir}/queue.c
    ${FREERTOS_dir}/stream_buffer.c
    ${FREERTOS_dir}/tasks.c
    ${FREERTOS_dir}/timers.c
    ${FREERTOS_dir}/portable/MemMang/heap_4.c
    ${FREERTOS_dir}/portable/GCC/ARM_CM7/r0p1/port.c
)

set(FREERTOS_inc ${FREERTOS_dir}/include ${FREERTOS_dir}/portable/GCC/ARM_CM7/r0p1)


set(C_SOURCES ${FREERTOS_src} ${HAL_src} ${C_SOURCES})

include_directories(${C_INCLUDES} ${AS_INCLUDES} ${HAL_inc_dir} ${FREERTOS_inc})

set(common_defs "-DSTM32F769xx" CACHE INTERNAL "")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${common_defs}" CACHE INTERNAL "")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${common_defs}" CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${common_defs}" CACHE INTERNAL "")

set(LDSCRIPT STM32F769NIHx_FLASH.ld)
set(CMAKE_EXE_LINKER_FLAGS " -T${CMAKE_SOURCE_DIR}/${LDSCRIPT} ${CMAKE_EXE_LINKER_FLAGS}" CACHE INTERNAL "")
