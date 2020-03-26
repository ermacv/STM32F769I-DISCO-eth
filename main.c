#include "stm32f7xx_hal.h"
#include "FreeRTOS.h"
#include "task.h"
#include "timers.h"
#include "stm32f769xx.h"
#include "stm32f7xx_hal_gpio.h"
#include "stm32f7xx_hal_rcc_ex.h"
#include "stm32f7xx_hal_eth.h"
#include "ethernetif.h"
#include "lwip.h"
#include "SEGGER_RTT.h"
#include "lwip/netifapi.h"

extern struct netif gnetif;
extern ETH_HandleTypeDef heth;

void SystemClock_Config(void);
void Error_Handler(void);
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim);
void vTaskCode( void * pvParameters );

int main(void)
{
  HAL_Init();
  SystemClock_Config();

  __HAL_RCC_GPIOJ_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();

  GPIO_InitTypeDef led = {0};

  led.Pin = GPIO_PIN_12;
  led.Mode = GPIO_MODE_OUTPUT_PP;
  led.Speed = GPIO_SPEED_FREQ_LOW;
  led.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOA, &led);

  led.Pin = GPIO_PIN_5 | GPIO_PIN_13;
  HAL_GPIO_Init(GPIOJ, &led);

  HAL_GPIO_WritePin(GPIOJ, GPIO_PIN_5 | GPIO_PIN_13, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_12, GPIO_PIN_RESET);

  SEGGER_RTT_ConfigUpBuffer(0, NULL, NULL, 0, SEGGER_RTT_MODE_BLOCK_IF_FIFO_FULL);
  SEGGER_RTT_WriteString(0, "\r\nMain function started\r\n");

  MX_LWIP_Init();



  BaseType_t xReturned;
  TaskHandle_t xHandle = NULL;

  xReturned = xTaskCreate(
                  vTaskCode,       /* Function that implements the task. */
                  "NAME",          /* Text name for the task. */
                  512,      /* Stack size in words, not bytes. */
                  ( void * ) 1,    /* Parameter passed into the task. */
                  tskIDLE_PRIORITY,/* Priority at which the task is created. */
                  &xHandle );      /* Used to pass out the created task's handle. */

  if( xReturned == pdPASS )
  {
    Error_Handler();
  }

  vTaskStartScheduler();
  
  while(1)
  {

  }

  return 0;
}

void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};
  RCC_PeriphCLKInitTypeDef PeriphClkInitStruct = {0};

  /** Configure LSE Drive Capability 
  */
  HAL_PWR_EnableBkUpAccess();
  /** Configure the main internal regulator output voltage 
  */
  __HAL_RCC_PWR_CLK_ENABLE();
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);
  /** Initializes the CPU, AHB and APB busses clocks 
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSI;
  RCC_OscInitStruct.PLL.PLLM = 8;
  RCC_OscInitStruct.PLL.PLLN = 216;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = 9;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }
  /** Activate the Over-Drive mode 
  */
  if (HAL_PWREx_EnableOverDrive() != HAL_OK)
  {
    Error_Handler();
  }
  /** Initializes the CPU, AHB and APB busses clocks 
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV2;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_7) != HAL_OK)
  {
    Error_Handler();
  }
  PeriphClkInitStruct.PeriphClockSelection = RCC_PERIPHCLK_USART1|RCC_PERIPHCLK_CLK48;
  PeriphClkInitStruct.Usart1ClockSelection = RCC_USART1CLKSOURCE_PCLK2;
  PeriphClkInitStruct.Clk48ClockSelection = RCC_CLK48SOURCE_PLL;
  if (HAL_RCCEx_PeriphCLKConfig(&PeriphClkInitStruct) != HAL_OK)
  {
    Error_Handler();
  }
}

void Error_Handler(void)
{

}

void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
  if (htim->Instance == TIM14) {
    HAL_IncTick();
  }
}

void vTaskCode( void * pvParameters )
{
  HAL_GPIO_WritePin(GPIOJ, GPIO_PIN_13, GPIO_PIN_SET);

  for( ;; )
  {
    HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_12);
    
    uint32_t regvalue = 0;
    HAL_ETH_ReadPHYRegister(&heth, 0x01, &regvalue);
    vTaskDelay(300);

    static int link_prev_state = 0;
    int link_curr_state = 0;

    if (regvalue & (0x1 << 2))
    {
      link_curr_state = 1;
    }

    if (link_curr_state != link_prev_state)
    {
      uint8_t lwip_state = netif_is_link_up(&gnetif);

      SEGGER_RTT_printf(0, "link_curr_state = %d, link_prev_state = %d, lwip_state = %d", link_curr_state, link_prev_state, lwip_state);

      if (lwip_state != link_curr_state)
      {
        if (link_curr_state)
        {
          HAL_GPIO_WritePin(GPIOJ, GPIO_PIN_13, GPIO_PIN_RESET);
          netifapi_netif_set_link_up(&gnetif);
          HAL_ETH_Start(&heth);
          HAL_NVIC_EnableIRQ(ETH_IRQn);
        }
        else
        {
          HAL_GPIO_WritePin(GPIOJ, GPIO_PIN_13, GPIO_PIN_SET);
          HAL_NVIC_DisableIRQ(ETH_IRQn);
          HAL_ETH_Stop(&heth);
          netifapi_netif_set_link_down(&gnetif);
        }
      }
      link_prev_state = link_curr_state;
    }
  }
}
