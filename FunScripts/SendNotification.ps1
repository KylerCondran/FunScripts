# Function to send a Windows 10/11 notification using default Windows API (no external modules required)
function Send-WindowsNotification {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Title,
        
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $AppId = "{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe"
    
    $Template = @"
<toast>
    <visual>
        <binding template="ToastText02">
            <text id="1">$Title</text>
            <text id="2">$Message</text>
        </binding>
    </visual>
</toast>
"@

    $XmlDoc = New-Object Windows.Data.Xml.Dom.XmlDocument
    $XmlDoc.LoadXml($Template)
    
    $Toast = [Windows.UI.Notifications.ToastNotification]::new($XmlDoc)
    
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($Toast)
}

# Example usage:
Send-WindowsNotification -Title "Hello!" -Message "This is a test notification"