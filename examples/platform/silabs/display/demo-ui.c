/**
 * @file
 * @brief User Interface core logic for demo.
 *******************************************************************************
 * # License
 * <b>Copyright 2020 Silicon Laboratories Inc.
 *www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon
 *Laboratories Inc. Your use of this software is
 *governed by the terms of Silicon Labs Master
 *Software License Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement.
 *This software is distributed to you in Source Code
 *format and is governed by the sections of the MSLA
 *applicable to Source Code.
 *
 ******************************************************************************/

#include "demo-ui.h"
#include "demo-ui-bitmaps.h"
#include "dmd/dmd.h"
#include "em_types.h"
#include "glib.h"
#include "sl_component_catalog.h"
#include "sl_memlcd.h"
#include <app/icd/server/ICDServerConfig.h>
#if defined(SL_WIFI) && SL_WIFI && !SLI_SI91X_MCU_INTERFACE
#include <platform/silabs/wifi/ncp/spi_multiplex.h>
#endif // SL_WIFI && !SLI_SI91X_MCU_INTERFACE
#include <string.h>

// Main Logo and App image
#define SILICONLABS_X_POSITION ((glibContext.pDisplayGeometry->xSize - SILICONLABS_BITMAP_WIDTH) / 2)
#define SILICONLABS_Y_POSITION 0
#define APP_BITMAP_WIDTH 64
#define APP_BITMAP_HEIGHT 64
#define APP_X_POSITION ((glibContext.pDisplayGeometry->xSize - APP_BITMAP_WIDTH) / 2)
#define APP_Y_POSITION (glibContext.pDisplayGeometry->ySize - APP_BITMAP_HEIGHT - 5)
#define PROT1_ID_X_POSITION 1
#define PROT2_ID_X_POSITION 79

// Matter Logo
#define PROT2_X_POSITION 104
#define PROT2_Y_POSITION (APP_Y_POSITION + (APP_Y_POSITION / 2))

// Networking Protocol Logo
#ifdef SL_WIFI
#define PROT1_BITMAP_WIDTH WIFI_BITMAP_WIDTH
#define PROT1_BITMAP_HEIGHT WIFI_BITMAP_HEIGHT
#define PROT1_X_POSITION 8
#define PROT1_Y_POSITION (APP_Y_POSITION + (APP_Y_POSITION / 2))
#else
#define PROT1_BITMAP_WIDTH THREAD_BITMAP_WIDTH
#define PROT1_BITMAP_HEIGHT THREAD_BITMAP_HEIGHT
#define PROT1_X_POSITION 8
#ifdef SL_CATALOG_ZIGBEE_ZCL_FRAMEWORK_CORE_PRESENT
#define ZIGBEE_POSITION_Y (APP_Y_POSITION + (APP_Y_POSITION / 2) + (ZIGBEE_BITMAP_HEIGHT / 2))
#define PROT1_Y_POSITION (APP_Y_POSITION + (APP_Y_POSITION / 2) - (ZIGBEE_BITMAP_HEIGHT / 2))
#else
#define PROT1_Y_POSITION (APP_Y_POSITION + (APP_Y_POSITION / 2))
#endif
#endif

/*******************************************************************************
 ***************************  LOCAL VARIABLES   ********************************
 ******************************************************************************/
static GLIB_Context_t glibContext; /* Global glib context */

static const uint8_t siliconlabsBitmap[] = { SILABS_BITMAP };
static const uint8_t matterLogoBitmap[]  = { MATTER_LOGO_BITMAP };

static const uint8_t OnStateBitMap[]  = { ON_DEMO_BITMAP };
static const uint8_t OffStateBitMap[] = { OFF_DEMO_BITMAP };

#ifdef SL_WIFI
static const uint8_t networkBitMap[] = { WIFI_BITMAP };
#else
static const uint8_t networkBitMap[] = { THREAD_BITMAP };
#endif

#ifdef SL_CATALOG_ZIGBEE_ZCL_FRAMEWORK_CORE_PRESENT
static const uint8_t zigbeeBitMap[] = { ZIGBEE_BITMAP };
#endif

// Future usage
// static const uint8_t unconnectedBitMap[] = { QUESTION_MARK_BITMAP };

/*******************************************************************************
 **************************   LOCAL FUNCTIONS   ********************************
 ******************************************************************************/
static void demoUIDisplayLogo(void)
{
    GLIB_drawBitmap(&glibContext, SILICONLABS_X_POSITION, SILICONLABS_Y_POSITION, SILICONLABS_BITMAP_WIDTH,
                    SILICONLABS_BITMAP_HEIGHT, siliconlabsBitmap);
}
/*******************************************************************************
 **************************   GLOBAL FUNCTIONS   *******************************
 ******************************************************************************/
void demoUIInit(GLIB_Context_t * context)
{
    memcpy(&glibContext, context, sizeof(GLIB_Context_t));
}

sl_status_t updateDisplay(void)
{
    sl_status_t status = SL_STATUS_OK;

#if defined(SLI_SI91X_MCU_INTERFACE) && SLI_SI91X_MCU_INTERFACE && CHIP_CONFIG_ENABLE_ICD_SERVER
    // In sleep, memlcd will not be retained so re-initialize MEMLCD interface after sleep wakeup
    sl_memlcd_post_wakeup_init();
#endif // SLI_SI91X_MCU_INTERFACE && SL_ICD_ENABLED && CHIP_CONFIG_ENABLE_ICD_SERVER

#if defined(SL_LCDCTRL_MUX) && SL_LCDCTRL_MUX
    status = sl_wfx_host_pre_lcd_spi_transfer();
    if (status != SL_STATUS_OK)
        return status;
#endif // defined(SL_LCDCTRL_MUX) && SL_LCDCTRL_MUX
    status = DMD_updateDisplay();
    if (status != DMD_OK)
        return SL_STATUS_FAIL;
#if defined(SL_LCDCTRL_MUX) && SL_LCDCTRL_MUX
    status = sl_wfx_host_post_lcd_spi_transfer();
    if (status != SL_STATUS_OK)
        return status;
#endif // defined(SL_LCDCTRL_MUX) && SL_LCDCTRL_MUX

#if defined(SLI_SI91X_MCU_INTERFACE) && SLI_SI91X_MCU_INTERFACE && CHIP_CONFIG_ENABLE_ICD_SERVER
    // MEMLCD is not a UULP component and not available in sleep so powering down before sleep and need to be re-initialized after
    // sleep-wakeup
    sl_memlcd_power_on(NULL, false);
#endif // SLI_SI91X_MCU_INTERFACE && CHIP_CONFIG_ENABLE_ICD_SERVER

    return SL_STATUS_OK;
}

void demoUIDisplayHeader(char * name)
{
    demoUIDisplayLogo();
    if (APP_NAME_MAX_LENGTH >= strlen(name))
    {
        GLIB_drawStringOnLine(&glibContext, name, 5, GLIB_ALIGN_CENTER, 0, 0, true);
    }
    updateDisplay();
}

void demoUIDisplayApp(bool on)
{
    GLIB_drawBitmap(&glibContext, APP_X_POSITION, APP_Y_POSITION, APP_BITMAP_WIDTH, APP_BITMAP_HEIGHT,
                    (on ? OnStateBitMap : OffStateBitMap));
    updateDisplay();
}

void demoUIDisplayProtocols()
{
    GLIB_drawBitmap(&glibContext, PROT2_X_POSITION, PROT2_Y_POSITION, MATTER_LOGO_WIDTH, MATTER_LOGO_HEIGHT, matterLogoBitmap);
    GLIB_drawBitmap(&glibContext, PROT1_X_POSITION, PROT1_Y_POSITION, PROT1_BITMAP_WIDTH, PROT1_BITMAP_HEIGHT, networkBitMap);
#ifdef SL_CATALOG_ZIGBEE_ZCL_FRAMEWORK_CORE_PRESENT
    GLIB_drawBitmap(&glibContext, PROT1_X_POSITION, ZIGBEE_POSITION_Y, ZIGBEE_BITMAP_WIDTH, ZIGBEE_BITMAP_HEIGHT, zigbeeBitMap);
#endif
    updateDisplay();
}

void demoUIClearMainScreen(uint8_t * name)
{
    GLIB_clear(&glibContext);
    demoUIDisplayHeader((char *) name);
    demoUIDisplayProtocols();
}








// APP_BITMAP_WIDTH x APP_BITMAP_HEIGHT 1-bpp bitmaps consumed by
// GLIB_drawBitmap (see DMD_writeData in dmd_memlcd.c). Each row is packed
// into APP_BITMAP_WIDTH / 8 bytes; rows are stored top-to-bottom. The
// row-pattern macros below (SQUARE_FULL_ROW / SQUARE_FRAME_ROW) and the
// per-row repeat counts in the array initializers encode the current 64x64
// layout; if either dimension changes, the SQUARE_BYTES bound check on
// the arrays will fail at compile time so the mismatch is caught
// immediately.
//
// GLIB convention (do NOT confuse with most other 1-bpp formats):
//   * Bit value 1 = white pixel (background, invisible on the memlcd).
//   * Bit value 0 = black pixel (foreground, visible).
//   * Pixels are packed LSB-first within each byte: pixel 0 of a row is
//     bit 0 of byte 0, pixel 7 is bit 7, pixel 8 is bit 0 of byte 1, etc.
#define SQUARE_BORDER 2
#define SQUARE_ROW_BYTES (APP_BITMAP_WIDTH / 8)
#define SQUARE_BYTES (SQUARE_ROW_BYTES * APP_BITMAP_HEIGHT)

// One row, all pixels black (visible).
#define SQUARE_FULL_ROW 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
// One row with a 2-pixel-thick black border on the left and right and white
// (background) in the middle. With LSB-first packing the leftmost 2 pixels
// are bits 0..1 of byte 0 (cleared -> 0xFC) and the rightmost 2 pixels are
// bits 6..7 of byte 7 (cleared -> 0x3F).
#define SQUARE_FRAME_ROW 0xFC, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x3F

// Row-repeat helpers. Variadic so a row macro that itself expands to a
// comma-separated list of bytes is forwarded as a single __VA_ARGS__ rather
// than several arguments. The frame uses 60 middle rows = 8*7 + 4.
#define SQUARE_REPEAT_2(...) __VA_ARGS__, __VA_ARGS__
#define SQUARE_REPEAT_4(...) SQUARE_REPEAT_2(__VA_ARGS__), SQUARE_REPEAT_2(__VA_ARGS__)
#define SQUARE_REPEAT_8(...) SQUARE_REPEAT_4(__VA_ARGS__), SQUARE_REPEAT_4(__VA_ARGS__)

static const uint8_t SolidSquare[SQUARE_BYTES] = {
    SQUARE_REPEAT_8(SQUARE_FULL_ROW), SQUARE_REPEAT_8(SQUARE_FULL_ROW), SQUARE_REPEAT_8(SQUARE_FULL_ROW),
    SQUARE_REPEAT_8(SQUARE_FULL_ROW), SQUARE_REPEAT_8(SQUARE_FULL_ROW), SQUARE_REPEAT_8(SQUARE_FULL_ROW),
    SQUARE_REPEAT_8(SQUARE_FULL_ROW), SQUARE_REPEAT_8(SQUARE_FULL_ROW),
};

static const uint8_t EmptySquare[SQUARE_BYTES] = {
    // Top border: 2 rows.
    SQUARE_REPEAT_2(SQUARE_FULL_ROW),
    // Middle: 60 rows (8*7 + 4) with only the side pixels set.
    SQUARE_REPEAT_8(SQUARE_FRAME_ROW), SQUARE_REPEAT_8(SQUARE_FRAME_ROW), SQUARE_REPEAT_8(SQUARE_FRAME_ROW),
    SQUARE_REPEAT_8(SQUARE_FRAME_ROW), SQUARE_REPEAT_8(SQUARE_FRAME_ROW), SQUARE_REPEAT_8(SQUARE_FRAME_ROW),
    SQUARE_REPEAT_8(SQUARE_FRAME_ROW), SQUARE_REPEAT_4(SQUARE_FRAME_ROW),
    // Bottom border: 2 rows.
    SQUARE_REPEAT_2(SQUARE_FULL_ROW),
};

void demoWriteDebug(bool state)
{
    // 8byte per line, 64 lines
    // uint8_t bitmap_solid[512];
    // uint8_t bitmap_empty[512];
    GLIB_drawBitmap(&glibContext, APP_X_POSITION, APP_Y_POSITION, APP_BITMAP_WIDTH, APP_BITMAP_HEIGHT,
                    (state ? SolidSquare : EmptySquare));
    updateDisplay();
}