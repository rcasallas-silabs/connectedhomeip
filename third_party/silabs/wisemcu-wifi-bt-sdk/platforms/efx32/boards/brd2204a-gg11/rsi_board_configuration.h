#ifndef RSI_BOARD_CONFIG_H
#define RSI_BOARD_CONFIG_H

typedef struct {
    unsigned char port;
    unsigned char pin;
} rsi_pin_t;

#define PIN(port_id, pin_id)  (rsi_pin_t){.port=gpioPort##port_id, .pin=pin_id}

#define SLEEP_CONFIRM_PIN  PIN(A, 12)
#define WAKE_INDICATOR_PIN PIN(A, 13)
#define RESET_PIN          PIN(B, 11)

#define SPI_CLOCK_PIN PIN(E, 12) // PIN(C, 2)
#define SPI_MOSI_PIN  PIN(E, 10) // PIN(C, 0)
#define SPI_MISO_PIN  PIN(E, 11) // PIN(C, 1)
#define SPI_CS_PIN    PIN(E, 13) // PIN(C, 3)

#define INTERRUPT_PIN PIN(B, 9)


#define RX_LDMA_CHANNEL   0
#define TX_LDMA_CHANNEL   1

#define RSI_SDIO_INTERFACE  1
#define EFM32_SDIO          1

// Declaration of MCU type
#define RSI_ARM_CM4F

#endif // RSI_BOARD_CONFIG_H
