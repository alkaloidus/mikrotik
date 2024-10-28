# Don't forget, if you've multiple ISPs
# HostPingA and HostPingB 
# must have the static routes.
# example:
# (if HostPingA=8.8.8.8; HostPingB=8.8.4.4;
# and GW of ISP1=172.16.18.1 ) 
# 
# /ip route 
# add dst-address=8.8.8.8 gateway=172.16.18.1 scope=10
# add dst-address=8.8.4.4 gateway=172.16.18.1 scope=10

##### Script Settings #####
:local WanName "wan"
:local HostPingA "1.1.1.1"
:local HostPingB "8.8.8.8"
#####################

:local PingCount "5"
:local WanStat
/interface pppoe-client monitor $WanName once do={ :set WanStat $status}
:if ($WanStat = "connected") do={
  :local pingresultA [/ping $HostPingA count=$PingCount];
    :if ($pingresultA = 0) do={ 
      :local pingresultB [/ping $HostPingB count=$PingCount]; 
      :if ($pingresultB = 0) do={ 
        :log error message="Script can not ping thru <$WanName>. Try to reconnect..."; 
        :interface pppoe-client disable $WanName; 
        :delay 5; 
        :interface pppoe-client enable $WanName; 
        :log warning message="PPPoE has Reconnected by script";
      }
    }
}