Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Get the script's directory
$scriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# Dynamic paths
$urls = Get-Content -Path (Join-Path -Path $scriptDir -ChildPath "urls.txt")
$wavExit = Join-Path -Path $scriptDir -ChildPath "noti1.wav"
$wavPause = Join-Path -Path $scriptDir -ChildPath "noti3.wav"
$wavStartResume = Join-Path -Path $scriptDir -ChildPath "noti2.wav"

# Global Variables
$Global:default_browser = "chrome"
$Global:counter = 0
$Global:current_url_pointer = 0
$Global:time = 15
$Global:NoOfurlsin_a_cluster = 100

# Function to Play Notification Sound
function play_notification_sound {
    param([string]$saction)
    $wavFile = ""
    switch ($saction) {
        "exit" { $wavFile = $wavExit }
        "pause" { $wavFile = $wavPause }
        "start" { $wavFile = $wavStartResume }
        "resume" { $wavFile = $wavStartResume }
    }
    $player = New-Object System.Media.SoundPlayer
    $player.SoundLocation = $wavFile
    $player.Load()
    $player.Play()
}

# Function to Open URLs
function url_open {
    param([string]$action, [string]$browser)

    while ($action -eq "play") {
        # Open the current URL
        Start-Process "$browser.exe" -ArgumentList $urls[$counter]
        Start-Sleep -Seconds $time
        $Global:counter++

        # Check for cluster pause
        if ($counter % $NoOfurlsin_a_cluster -eq 0) {
            $Global:current_url_pointer = $counter
            play_notification_sound "pause"
            Write-Host "Paused at URL index: $current_url_pointer"
            break
        }

        # Check if all URLs are opened
        if ($counter -ge $urls.Length) {
            play_notification_sound "exit"
            Write-Host "All URLs have been opened."
            break
        }
    }
}

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "URL Opener"
$form.Size = New-Object System.Drawing.Size(600, 300)
$form.StartPosition = "CenterScreen"

# Labels
$labelURLs = New-Object System.Windows.Forms.Label
$labelURLs.Text = "Total URLs: $($urls.Length)"
$labelURLs.Location = New-Object System.Drawing.Point(10, 10)
$labelURLs.AutoSize = $true
$form.Controls.Add($labelURLs)

$labelBrowser = New-Object System.Windows.Forms.Label
$labelBrowser.Text = "Default Browser: $default_browser"
$labelBrowser.Location = New-Object System.Drawing.Point(10, 40)
$labelBrowser.AutoSize = $true
$form.Controls.Add($labelBrowser)

$labelTimeGap = New-Object System.Windows.Forms.Label
$labelTimeGap.Text = "Time Gap: $time seconds"
$labelTimeGap.Location = New-Object System.Drawing.Point(10, 70)
$labelTimeGap.AutoSize = $true
$form.Controls.Add($labelTimeGap)

# Input for Number of URLs in a Cluster
$labelNumURLs = New-Object System.Windows.Forms.Label
$labelNumURLs.Text = "No of URLs in a Cluster:"
$labelNumURLs.Location = New-Object System.Drawing.Point(10, 100)
$labelNumURLs.AutoSize = $true
$form.Controls.Add($labelNumURLs)

$textBoxNumURLs = New-Object System.Windows.Forms.TextBox
$textBoxNumURLs.Location = New-Object System.Drawing.Point(180, 100)
$textBoxNumURLs.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($textBoxNumURLs)

# Input for Time Gap
$labelTimeGapInput = New-Object System.Windows.Forms.Label
$labelTimeGapInput.Text = "Enter Time Gap (sec):"
$labelTimeGapInput.Location = New-Object System.Drawing.Point(10, 140)
$labelTimeGapInput.AutoSize = $true
$form.Controls.Add($labelTimeGapInput)

$textBoxTimeGap = New-Object System.Windows.Forms.TextBox
$textBoxTimeGap.Location = New-Object System.Drawing.Point(180, 140)
$textBoxTimeGap.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($textBoxTimeGap)

# Buttons
$setURLsButton = New-Object System.Windows.Forms.Button
$setURLsButton.Text = "Set"
$setURLsButton.Location = New-Object System.Drawing.Point(290, 100)
$setURLsButton.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($setURLsButton)

$setTimeGapButton = New-Object System.Windows.Forms.Button
$setTimeGapButton.Text = "Set"
$setTimeGapButton.Location = New-Object System.Drawing.Point(290, 140)
$setTimeGapButton.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($setTimeGapButton)

$startButton = New-Object System.Windows.Forms.Button
$startButton.Text = "Start"
$startButton.Location = New-Object System.Drawing.Point(170, 180)
$startButton.Size = New-Object System.Drawing.Size(120, 40)
$form.Controls.Add($startButton)

$resumeButton = New-Object System.Windows.Forms.Button
$resumeButton.Text = "Resume"
$resumeButton.Location = New-Object System.Drawing.Point(300, 180)
$resumeButton.Size = New-Object System.Drawing.Size(120, 40)
$form.Controls.Add($resumeButton)

$changeBrowserButton = New-Object System.Windows.Forms.Button
$changeBrowserButton.Text = "Change Browser"
$changeBrowserButton.Location = New-Object System.Drawing.Point(430, 180)
$changeBrowserButton.Size = New-Object System.Drawing.Size(120, 40)
$form.Controls.Add($changeBrowserButton)

# Event Handlers
$setURLsButton.Add_Click({
    $numURLs = [int]$textBoxNumURLs.Text
    if ($numURLs -gt 0) {
        $Global:NoOfurlsin_a_cluster = $numURLs
        $labelNumURLs.Text = "No of URLs in a Cluster: $NoOfurlsin_a_cluster"
    } else {
        [System.Windows.Forms.MessageBox]::Show("Invalid number of URLs in a cluster!")
    }
})

$setTimeGapButton.Add_Click({
    $timeGap = [int]$textBoxTimeGap.Text
    if ($timeGap -gt 0) {
        $Global:time = $timeGap
        $labelTimeGap.Text = "Time Gap: $time seconds"
    } else {
        [System.Windows.Forms.MessageBox]::Show("Invalid time gap!")
    }
})

$startButton.Add_Click({
    play_notification_sound "start"
    $Global:counter = 0  # Reset the counter for a new start
    url_open "play" $default_browser
})

$resumeButton.Add_Click({
    play_notification_sound "resume"
    url_open "play" $default_browser
})

$changeBrowserButton.Add_Click({
    # Cycle between browsers
    if ($Global:default_browser -eq "chrome") {
        $Global:default_browser = "firefox"
    } else {
        $Global:default_browser = "chrome"
    }
    $labelBrowser.Text = "Default Browser: $default_browser"
    [System.Windows.Forms.MessageBox]::Show("Browser changed to: $default_browser")
})

# Display the Form
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
