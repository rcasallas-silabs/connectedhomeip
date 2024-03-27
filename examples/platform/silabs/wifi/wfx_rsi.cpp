#include "wfx_rsi.h"
#include <silabs_utils.h>

// TODO: Figure out why we actually need this, we are already handling failure and retries somewhere else.
#define WIFI_SCAN_TIMEOUT_TICK 10000
// TODO: Confirm that this value works for size and timing
#define WFX_QUEUE_SIZE 10


sl_status_t WfxRsi::Init()
{
    sl_status_t status = SL_STATUS_OK;

    // Create Sempaphore for scan
    mScanSemaphore = osSemaphoreNew(1, 0, NULL);
    if (mScanSemaphore == NULL)
    {
        return SL_STATUS_ALLOCATION_FAILED;
    }
    // Create the message queue
    mEventQueue = osMessageQueueNew(WFX_QUEUE_SIZE, sizeof(WfxEvent_t), NULL);
    if (mEventQueue == NULL)
    {
        return SL_STATUS_ALLOCATION_FAILED;
    }

    // Create timer for DHCP polling
    // TODO: Use LWIP timer instead of creating a new one here
    mDHCPTimer = osTimerNew(DHCPTimerEventHandler, osTimerPeriodic, NULL, NULL);
    if (mDHCPTimer == NULL)
    {
        return SL_STATUS_ALLOCATION_FAILED;
    }

    return status;
}


void WfxRsi::PostEvent(WfxEvent_t * event)
{
    sl_status_t status = osMessageQueuePut(mEventQueue, event, 0, 0);

    if (status != osOK)
    {
        SILABS_LOG("WfxPostEvent: failed to post event with status: %d", status);
        // TODO: Handle error, requeue event depending on queue size or notify relevant task, Chipdie, etc.
    }
}


sl_status_t WfxRsi::GetNextEvent(WfxEvent_t & wfxEvent)
{
    return osMessageQueueGet(mEventQueue, &wfxEvent, NULL, osWaitForever);
}


void WfxRsi::DHCPTimerEventHandler(void * arg)
{
    WfxRsi & wfx_rsi = WfxRsi::Instance();
    WfxEvent_t event;
    event.eventType = WFX_EVT_DHCP_POLL;
    wfx_rsi.PostEvent(&event);
}


void WfxRsi::StartDHCPTimer(uint32_t timeout)
{
    osStatus_t status;

    // Cancel timer if already started
    CancelDHCPTimer();

    status = osTimerStart(mDHCPTimer, pdMS_TO_TICKS(timeout));
    if (status != osOK)
    {
        SILABS_LOG("StartDHCPTimer: failed to start timer with status: %d", status);
    }
}


void WfxRsi::CancelDHCPTimer()
{
    osStatus_t status;

    // Check if timer started
    if (!osTimerIsRunning(mDHCPTimer))
    {
        SILABS_LOG("CancelDHCPTimer: timer not running");
        return;
    }

    status = osTimerStop(mDHCPTimer);
    if (status != osOK)
    {
        SILABS_LOG("CancelDHCPTimer: failed to stop timer with status: %d", status);
    }
}


void WfxRsi::BlockScan()
{
    osSemaphoreAcquire(mScanSemaphore, WIFI_SCAN_TIMEOUT_TICK);
}


void WfxRsi::ReleaseScan()
{
    osSemaphoreRelease(mScanSemaphore);
}


/// NotifyConnectivity
/// @brief Notify the application about the connectivity status if it has not been notified yet.
///        Helper function for HandleDHCPPolling.
void WfxRsi::NotifyConnectivity()
{
    if (!mHasNotifiedWifiConnectivity)
    {
        wfx_connected_notify(CONNECTION_STATUS_SUCCESS, &this->ap_mac);
        mHasNotifiedWifiConnectivity = true;
    }
}


void WfxRsi::HandleDHCPPolling()
{
    struct netif * sta_netif;
    WfxEvent_t event;

    sta_netif = wfx_get_netif(SL_WFX_STA_INTERFACE);
    if (sta_netif == NULL)
    {
        // TODO: Notify the application that the interface is not set up or Chipdie here because we are in an unkonwn state
        SILABS_LOG("HandleDHCPPolling: failed to get STA netif");
        return;
    }
#if (CHIP_DEVICE_CONFIG_ENABLE_IPV4)
    uint8_t dhcp_state = dhcpclient_poll(sta_netif);
    if (dhcp_state == DHCP_ADDRESS_ASSIGNED && !mHasNotifiedIPV4)
    {
        wfx_dhcp_got_ipv4((uint32_t) sta_netif->ip_addr.u_addr.ip4.addr);
        mHasNotifiedIPV4 = true;
        NotifyConnectivity();
    }
    else if (dhcp_state == DHCP_OFF)
    {
        wfx_ip_changed_notify(IP_STATUS_FAIL);
        mHasNotifiedIPV4 = false;
    }
#endif /* CHIP_DEVICE_CONFIG_ENABLE_IPV4 */
    /* Checks if the assigned IPv6 address is preferred by evaluating
     * the first block of IPv6 address ( block 0)
     */
    if ((ip6_addr_ispreferred(netif_ip6_addr_state(sta_netif, 0))) && !mHasNotifiedIPV6)
    {
        wfx_ipv6_notify(GET_IPV6_SUCCESS);
        mHasNotifiedIPV6 = true;
        event.eventType = WFX_EVT_STA_DHCP_DONE;
        PostEvent(&event);
        NotifyConnectivity();
    }
}

/// ResetDHCPNotificationFlags
/// @brief Reset the flags that are used to notify the application about DHCP connectivity
///        and emits a WFX_EVT_STA_DO_DHCP event to trigger DHCP polling checks. Helper function for ProcessEvent.
void WfxRsi::ResetDHCPNotificationFlags()
{
    WfxRsi & wfx_rsi = WfxRsi::Instance();
    WfxEvent_t outEvent;

#if (CHIP_DEVICE_CONFIG_ENABLE_IPV4)
    mHasNotifiedIPV4 = false;
#endif // CHIP_DEVICE_CONFIG_ENABLE_IPV4
    mHasNotifiedIPV6             = false;
    mHasNotifiedWifiConnectivity = false;

    outEvent.eventType = WFX_EVT_STA_DO_DHCP;
    wfx_rsi.PostEvent(&outEvent);
}
