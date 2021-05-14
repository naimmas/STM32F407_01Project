#include "stm32f4xx.h"

int main(void)
{
  // GPIOA GPIOD icin clk aktif hale getirme
  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOA | RCC_AHB1Periph_GPIOD, ENABLE);

  // GPIOD structure tanimlama
  GPIO_InitTypeDef GPIO_InitStruct;
  GPIO_InitStruct.GPIO_Pin  = GPIO_Pin_12 | GPIO_Pin_15;
  GPIO_InitStruct.GPIO_Mode = GPIO_Mode_OUT;
  GPIO_InitStruct.GPIO_Speed = GPIO_Speed_2MHz;
  GPIO_InitStruct.GPIO_OType = GPIO_OType_PP;
  GPIO_InitStruct.GPIO_PuPd = GPIO_PuPd_NOPULL;
  GPIO_Init(GPIOD, &GPIO_InitStruct);
  // GPIOA structure tanimlama
  GPIO_InitStruct.GPIO_Pin  = GPIO_Pin_0;
  GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IN;
  GPIO_InitStruct.GPIO_PuPd = GPIO_PuPd_DOWN;
  GPIO_Init(GPIOA, &GPIO_InitStruct);

  while(1)
  {
    // Buton basildigi zaman ledi yak
    if(GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_0))
    {
      GPIO_SetBits(GPIOD, GPIO_Pin_12 | GPIO_Pin_15);
    }
    else
    {
      GPIO_ResetBits(GPIOD, GPIO_Pin_12 | GPIO_Pin_15);
    }
/***********************************************************/
 // yaklasik bir saniye araligiyla ledi yak sondur 
	/*Bu kismi kullanmak istiyorsaniz ust kismi silin ya da commentleyin ve bu kismi aktif edin*/
	
    /* GPIO_SetBits(GPIOD, GPIO_Pin_12);
     for(long i=0; i<SystemCoreClock/8; i++){__NOP();} //yaklasik 1sn bekle

     GPIO_ResetBits(GPIOD, GPIO_Pin_12);
     GPIO_SetBits(GPIOD, GPIO_Pin_15);
     for(long i=0; i<SystemCoreClock/8; i++){__NOP();} //yaklasik 1sn bekle
 GPIO_ResetBits(GPIOD, GPIO_Pin_15);*/
 
/***********************************************************/
  }
  return 0;
}
