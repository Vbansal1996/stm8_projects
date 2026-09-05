#include <stdint.h>

#define PC_ODR  (*(volatile uint8_t *)0x500A)
#define PC_IDR  (*(volatile uint8_t *)0x500B)
#define PC_DDR  (*(volatile uint8_t *)0x500C)
#define PC_CR1  (*(volatile uint8_t *)0x500D)


#define PD_ODR  (*(volatile uint8_t *)0x500F)
#define PD_IDR  (*(volatile uint8_t *)0x5010)
#define PD_DDR  (*(volatile uint8_t *)0x5011)
#define PD_CR1  (*(volatile uint8_t *)0x5012)

#define CLK_FREQ 2000000UL
#define CLK_CONT_PER_LOOP   4
#define TIME_PER_LOOP_US   (CLK_CONT_PER_LOOP * 1000000UL / CLK_FREQ)
#define DELAY_200MS_COUNT   (20000UL / TIME_PER_LOOP_US)


#define Op_Pin_D2  2
#define Op_Pin_D3  3
#define Op_Pin_C3  3
#define Op_Pin_C4  4
#define Op_Pin_C5  5
#define Op_Pin_C6  6

#define Ip_Pin_D4  4

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
    
    PD_ODR = 0x00;
    PC_ODR = 0x00;

    /* PC4 as output */
    PC_DDR |= ((1 << Op_Pin_C3) | (1 << Op_Pin_C4) | (1 << Op_Pin_C5) | (1 << Op_Pin_C6)); /* PC3, PC4, PC5, PC6 as output */
    PD_DDR |= ((1 << Op_Pin_D2) | (1 << Op_Pin_D3)); /* PD2 and PD3 as output */
    
    
    PD_DDR &= ~(1 << Ip_Pin_D4); /* PD4 as input */

    /* Push-pull output */
    PC_CR1 |= (1 << Op_Pin_C3) | (1 << Op_Pin_C4) | (1 << Op_Pin_C5) | (1 << Op_Pin_C6); /* PC3, PC4, PC5, PC6 as push-pull output */
    PD_CR1 |= ((1 << Ip_Pin_D4) | (1 << Op_Pin_D2) | (1 << Op_Pin_D3)); /* PD4 as input pullup, PD2 and PD3 as push-pull output */

    /* Set PC4 HIGH */

    while (1)
    {
        /* Keep PC4 HIGH */
        Ip_Pin_state = (PD_IDR >> Ip_Pin_D4) & 0x01; /* Read PD4 state */
        if (Ip_Pin_state == 1 && stateChanged == 1) /* If PC3 is LOW */
        {
            PD_ODR = 0x00;
            PC_ODR = 0x00;
            stateChanged = 0;

            PD_ODR |= (1 << Op_Pin_D3); /* Set PD2 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PD_ODR &= ~(1 << Op_Pin_D3); /* Set PD2 HIGH */
            
            PC_ODR |= (1 << Op_Pin_C3); /* Set PC4 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PC_ODR &= ~(1 << Op_Pin_C3); /* Set PC4 HIGH */
            
            PD_ODR |= (1 << Op_Pin_D2); /* Set PD2 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PD_ODR &= ~(1 << Op_Pin_D2); /* Set PD2 HIGH */
            
            PC_ODR |= (1 << Op_Pin_C4); /* Set PC4 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PC_ODR &= ~(1 << Op_Pin_C4); /* Set PC4 HIGH */
            
            PC_ODR |= (1 << Op_Pin_C5); /* Set PC4 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PC_ODR &= ~(1 << Op_Pin_C5); /* Set PC4 HIGH */

            PC_ODR |= (1 << Op_Pin_C4); /* Set PC4 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PC_ODR &= ~(1 << Op_Pin_C4); /* Set PC4 HIGH */

            PD_ODR |= (1 << Op_Pin_D2); /* Set PD2 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PD_ODR &= ~(1 << Op_Pin_D2); /* Set PD2 HIGH */

            PC_ODR |= (1 << Op_Pin_C3); /* Set PC4 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PC_ODR &= ~(1 << Op_Pin_C3); /* Set PC4 HIGH */

            PD_ODR |= (1 << Op_Pin_D3); /* Set PD2 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PD_ODR &= ~(1 << Op_Pin_D3); /* Set PD2 HIGH */
            
            PC_ODR |= (1 << Op_Pin_C3); /* Set PC4 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PC_ODR &= ~(1 << Op_Pin_C3); /* Set PC4 HIGH */
            
            PD_ODR |= (1 << Op_Pin_D2); /* Set PD2 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PD_ODR &= ~(1 << Op_Pin_D2); /* Set PD2 HIGH */
            
            PC_ODR |= (1 << Op_Pin_C4); /* Set PC4 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PC_ODR &= ~(1 << Op_Pin_C4); /* Set PC4 HIGH */
            
            PC_ODR |= (1 << Op_Pin_C5); /* Set PC4 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PC_ODR &= ~(1 << Op_Pin_C5); /* Set PC4 HIGH */

            PC_ODR |= (1 << Op_Pin_C4); /* Set PC4 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PC_ODR &= ~(1 << Op_Pin_C4); /* Set PC4 HIGH */

            PD_ODR |= (1 << Op_Pin_D2); /* Set PD2 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PD_ODR &= ~(1 << Op_Pin_D2); /* Set PD2 HIGH */

            PC_ODR |= (1 << Op_Pin_C3); /* Set PC4 HIGH */
            delay(DELAY_200MS_COUNT); /* Delay for a while */
            PC_ODR &= ~(1 << Op_Pin_C3); /* Set PC4 HIGH */

            PD_ODR |= (1 << Op_Pin_D3); /* Set PD2 HIGH */
            PC_ODR |= (1 << Op_Pin_C3); /* Set PC4 HIGH */
            PD_ODR |= (1 << Op_Pin_D2); /* Set PD2 HIGH */
            PC_ODR |= (1 << Op_Pin_C4); /* Set PC4 HIGH */
            PC_ODR |= (1 << Op_Pin_C5); /* Set PC4 HIGH */
            

        }
        if (Ip_Pin_state == 0) /* If PD4 is HIGH */
        {
            stateChanged = 1;
            PC_ODR |= ((1 << Op_Pin_C3) | (1 << Op_Pin_C4) | (1 << Op_Pin_C5)); /* Set PC4 HIGH */
            PD_ODR |= ((1 << Op_Pin_D2) | (1<< Op_Pin_D3)); /* Set PD2 HIGH */
        }
    }
}