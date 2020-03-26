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

if(DEFINED ENV{DEV_RTOS_DIR})
    set(DEV_RTOS_dir $ENV{DEV_RTOS_DIR} CACHE INTERNAL "DEV_RTOS_DIR path")
else()
    message("Please provide an environment variable DEV_RTOS_DIR\n")
endif()

set(FREERTOS_dir ${DEV_RTOS_dir}/FreeRTOS-latest/FreeRTOS/Source)
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

#LWIP
set(LWIP_glue_dir Modules/LWIP_glue)
set(LWIP_glue_src ${LWIP_glue_dir}/ethernetif.c ${LWIP_glue_dir}/lwip.c)
set(LWIP_glue_inc ${LWIP_glue_dir})

#rtt
if(DEFINED ENV{DEV_LIB_DIR})
    set(DEV_LIB_dir $ENV{DEV_LIB_DIR} CACHE INTERNAL "DEV_LIB_DIR path")
else()
    message("Please provide an environment variable DEV_LIB_DIR\n")
endif()

set(RTT_dir ${DEV_LIB_dir}/SEGGER_RTT-latest)
set(RTT_C_src
    ${RTT_dir}/RTT/SEGGER_RTT.c
    ${RTT_dir}/RTT/SEGGER_RTT_printf.c
    # ${RTT_dir}/Syscalls/SEGGER_RTT_Syscalls_GCC.c
)

set(RTT_ASM_src
    ${RTT_dir}/RTT/SEGGER_RTT_ASM_ARMv7M.S
)

set(RTT_inc
    ${RTT_dir}/RTT
    ${RTT_dir}/Syscalls
)

#Lwip FreeRTOS contrib
set(LWIP_Contrib_dir ${DEV_LIB_dir}/lwip-contrib-latest)
set(LWIP_Contrib_FreeRTOS_port_dir ${LWIP_Contrib_dir}/ports/freertos)

set(LWIP_Contrib_FreeRTOS_port_src_dir ${LWIP_Contrib_FreeRTOS_port_dir}/sys_arch.c)
set(LWIP_Contrib_FreeRTOS_port_inc_dir ${LWIP_Contrib_FreeRTOS_port_dir}/include)
#######################


#OSAL CMSIS RTOS2
set(CMSIS_RTOS_2_dir Modules/CMSIS_RTOS_V2)
set(CMSIS_RTOS_2_src ${CMSIS_RTOS_2_dir}/cmsis_os2.c)
set(CMSIS_RTOS_2_inc ${CMSIS_RTOS_2_dir})

set(C_SOURCES ${FREERTOS_src} ${HAL_src} ${C_SOURCES} ${LWIP_glue_src} ${RTT_C_src} ${LWIP_Contrib_FreeRTOS_port_src_dir} ${CMSIS_RTOS_2_src})
set (ASM_SOURCES ${ASM_SOURCES} ${RTT_ASM_src})
include_directories(${C_INCLUDES} ${AS_INCLUDES} ${HAL_inc_dir} ${FREERTOS_inc} ${LWIP_glue_inc} ${RTT_inc} ${LWIP_Contrib_FreeRTOS_port_inc_dir} ${CMSIS_RTOS_2_inc})

set(common_defs "-DSTM32F769xx -DLWIP_DEBUG" CACHE INTERNAL "")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${common_defs}" CACHE INTERNAL "")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${common_defs}" CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${common_defs}" CACHE INTERNAL "")

set(LDSCRIPT STM32F769NIHx_FLASH.ld)
set(CMAKE_EXE_LINKER_FLAGS " -T${CMAKE_SOURCE_DIR}/${LDSCRIPT} ${CMAKE_EXE_LINKER_FLAGS}" CACHE INTERNAL "")
