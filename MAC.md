-----
MAC (Ethernet)
====


<br/>
<br/>
<br/>
<br/>
<hr>


# RMII Clock Input mode


```bash
┌──────RK3568 SoC────────────────┐    ┌──────RTL8201F───────┐
| GMAC1 (ethernet@2a230000)      |    |                     |
| GPIO2_C6 : ETH1_TXD0_M0        |>>>>| TXD0                |
| GPIO2_C7 : ETH1_TXD1_M0        |>>>>| TXD1                |
| GPIO2_D0 : ETH1_TXCTL_M0       |>>>>| TXEN                |
|                                |    |                     |
| GPIO2_D1 : ETH1_RXD0_M0        |<<<<| RXD0                |
| GPIO2_D2 : ETH1_RXD1_M0        |<<<<| RXD1                |
| GPIO2_D3 : ETH1_RXCTL_M0       |<<<<| CRS/CRS_DV          |
|                                |    |                     |
| GPIO2_D4 : ETH1_MDC_M0         |>>>>| MDC                 |
| GPIO2_D5 : ETH1_MDIO_M0        |<-->| MDIO                |
|                                |    |                     |
| GPIO2_D7 : ETH1_MCLK_M0        |<<<<| TXC(50MHz)          |
|                                |    |                     |
| GPIO2_D6                       |>>>>| PHYRSTB             |
└────────────────────────────────┘    └─────────────────────┘
```
