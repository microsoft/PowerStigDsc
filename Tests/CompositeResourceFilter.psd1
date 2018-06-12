# This hash table is used filter for applicable stig data for a specific composite resource
@{
    Browser          = @("*IE*")
    
    WindowsFirewall  = @("*FW*")
    
    WindowsDnsServer = @("*DNS*")
    
    WindowsServer    = @("*DC*", "*MS*")
}
