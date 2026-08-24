#include <stdint.h>

#define PC_ODR  (*(volatile uint8_t *)0x500A)
#define PC_DDR  (*(volatile uint8_t *)0x500C)
#define PC_CR1  (*(volatile uint8_t *)0x500D)

void main(void)
{
    /* PC4 as output */
    PC_DDR |= (1 << 4);

    /* Push-pull output */
    PC_CR1 |= (1 << 4);

    /* Set PC4 HIGH */
    PC_ODR |= (1 << 4);

    while (1)
    {
        /* Keep PC4 HIGH */
    }
}