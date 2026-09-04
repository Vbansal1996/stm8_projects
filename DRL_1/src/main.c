#include <stdint.h>

#define PC_ODR  (*(volatile uint8_t *)0x500A)
#define PC_IDR  (*(volatile uint8_t *)0x500B)
#define PC_DDR  (*(volatile uint8_t *)0x500C)
#define PC_CR1  (*(volatile uint8_t *)0x500D)

#define CLK_FREQ 2000000UL
#define CLK_CONT_PER_LOOP   4
#define TIME_PER_LOOP_US   (CLK_CONT_PER_LOOP * 1000000UL / CLK_FREQ)
#define DELAY_500MS_COUNT   (20000UL / TIME_PER_LOOP_US)


#define Op_Pin  4
#define Ip_Pin  3

void delay(uint32_t count)
{
    while (count--)
    {
        __asm__("nop");
    }
}

void main(void)
{
    uint8_t Ip_Pin_state = 0;
    uint8_t stateChanged = 1;
    /* PC4 as output */
    PC_DDR |= (1 << 4);
    PC_DDR &= ~(1 << 3); /* PC3 as input */

    /* Push-pull output */
    PC_CR1 |= (1 << 4);
    PC_CR1 |= (1 << 3); /* PC3 as input pullup */

    /* Set PC4 HIGH */

    while (1)
    {
        /* Keep PC4 HIGH */
        Ip_Pin_state = (PC_IDR >> Ip_Pin) & 0x01; /* Read PC3 state */
        if (Ip_Pin_state == 1 && stateChanged == 1) /* If PC3 is LOW */
        {
            stateChanged = 0;
            for (uint32_t i = 0; i < 6; i++)
            {
                PC_ODR |= (1 << 4); /* Set PC4 HIGH */
                delay(DELAY_500MS_COUNT); /* Delay for a while */
                PC_ODR &= ~(1 << 4); /* Set PC4 LOW */
                delay(DELAY_500MS_COUNT); /* Delay for a while */
            }
        }
        if (Ip_Pin_state == 0) /* If PC3 is HIGH */
        {
            stateChanged = 1;
        }
            
        PC_ODR |= (1 << 4); /* Set PC4 HIGH */
    }
}