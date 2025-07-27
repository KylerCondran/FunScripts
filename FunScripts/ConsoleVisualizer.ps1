# ConsoleVisualizer.ps1
# A fun script that creates a real-time sound visualizer in the console
# Combines audio generation with visual patterns, AI generated

# Constants for visual patterns
$PATTERNS = @(
    '*', '#', '=', '-', '+', '|', '/', '\\', 'o', 'O', 'x', 'X'
)

function Get-RandomPattern {
    return $PATTERNS | Get-Random
}

function Get-ColoredText {
    param([string]$text, [int]$freq)
    
    # Map frequency ranges to colors
    $color = switch ($freq) {
        { $_ -lt 300 }  { 'DarkBlue' }
        { $_ -lt 500 }  { 'Blue' }
        { $_ -lt 700 }  { 'Cyan' }
        { $_ -lt 900 }  { 'Green' }
        { $_ -lt 1100 } { 'Yellow' }
        { $_ -lt 1300 } { 'Red' }
        default         { 'Magenta' }
    }
    
    $pattern = Get-RandomPattern
    return @{
        Text = $text * ([Math]::Max(1, [Math]::Min(20, $freq / 100)))
        Color = $color
    }
}

function Show-SoundVisual {
    param([int]$freq, [int]$duration, [bool]$reverse = $false, [bool]$glitch = $false)
    $width = $host.UI.RawUI.WindowSize.Width
    $height = [int]$host.UI.RawUI.WindowSize.Height
    $heightMinus2 = $height - 2
    $visual = Get-ColoredText -freq $freq -text (Get-RandomPattern)
    $spaces = " " * ([Math]::Floor($freq / 100) % ($width / 2))
    $matrixChars = @("0","1","|","I","l","!","$","@","#","%","^","&","*","+","-","=","~","A","B","C","D","E","F","G","H","J","K","L","M","N","P","Q","R","S","T","U","V","W","X","Y","Z")
    $allColors = @("Black","DarkBlue","DarkGreen","DarkCyan","DarkRed","DarkMagenta","DarkYellow","Gray","DarkGray","Blue","Green","Cyan","Red","Magenta","Yellow","White")
    $emojis = @(":)", ":D", ";)", ":P", ":-O", ":-|", ":-/", ":-\\", "<3", "^_^", "O_O", "T_T", "¯\_(ツ)_/¯")
    $invertColors = $false
    if ((Get-Random -Minimum 0 -Maximum 30) -eq 0) { $invertColors = $true }
    if ($invertColors) {
        $allColors = $allColors[($allColors.Length-1)..0]
    }
    # 2. Occasionally print a random PowerShell command at the top
    if ((Get-Random -Minimum 0 -Maximum 40) -eq 0) {
        $cmds = @('Get-Process','Get-Random','ls','Get-Date','Write-Host "Hello!"','Get-ChildItem','Get-Help','Clear-Host','Start-Sleep 1','Get-Location')
        $host.UI.RawUI.CursorPosition = @{X=0;Y=0}
        Write-Host ($cmds | Get-Random) -ForegroundColor ($allColors | Get-Random)
    }
    # 4. Occasionally clear only half the screen
    if ((Get-Random -Minimum 0 -Maximum 50) -eq 0) {
        for ($y=0; $y -lt [math]::Floor($height/2); $y++) {
            $host.UI.RawUI.CursorPosition = @{X=0;Y=$y}
            Write-Host (' ' * $width) -NoNewline
        }
    }
    if ($glitch -or $true) {
        # Matrix waterfall: vertical columns, mostly green, intentional chaos, more color variance
        for ($col = 0; $col -lt $width; $col += Get-Random -Minimum 1 -Maximum 6) {
            $dropLen = Get-Random -Minimum 2 -Maximum ([Math]::Max(4, $heightMinus2))
            $startRow = Get-Random -Minimum 0 -Maximum $heightMinus2
            for ($row = $startRow; $row -lt [Math]::Min($height, $startRow+$dropLen); $row++) {
                # 5. Occasionally print a random emoji
                if ((Get-Random -Minimum 0 -Maximum 100) -eq 0) {
                    $char = $emojis | Get-Random
                } else {
                    $char = $matrixChars | Get-Random
                }
                $color = $allColors | Get-Random
                $bg = $allColors | Get-Random
                try {
                    $host.UI.RawUI.CursorPosition = @{X=$col;Y=$row}
                } catch {}
                Write-Host $char -ForegroundColor $color -BackgroundColor $bg -NoNewline
            }
        }
        # --- Horizontal Waterfall Effect ---
        if ((Get-Random -Minimum 0 -Maximum 2) -eq 0) {
            for ($row = 0; $row -lt $height; $row += Get-Random -Minimum 1 -Maximum 6) {
                $dropLen = Get-Random -Minimum 2 -Maximum ([Math]::Max(4, $width-2))
                $startCol = Get-Random -Minimum 0 -Maximum ($width-2)
                for ($col = $startCol; $col -lt [Math]::Min($width, $startCol+$dropLen); $col++) {
                    if ((Get-Random -Minimum 0 -Maximum 100) -eq 0) {
                        $char = $emojis | Get-Random
                    } else {
                        $char = $matrixChars | Get-Random
                    }
                    $color = $allColors | Get-Random
                    $bg = $allColors | Get-Random
                    try {
                        $host.UI.RawUI.CursorPosition = @{X=$col;Y=$row}
                    } catch {}
                    Write-Host $char -ForegroundColor $color -BackgroundColor $bg -NoNewline
                }
            }
        }
        # Intentionally overlap lines and leave cursor in random place
        $host.UI.RawUI.CursorPosition = @{X=(Get-Random -Minimum 0 -Maximum $width);Y=(Get-Random -Minimum 0 -Maximum $height)}
        # Add some random gibberish at the bottom
        Write-Host ""; for ($i=0;$i -lt ($width/2);$i++) { Write-Host ($matrixChars | Get-Random) -ForegroundColor ($allColors | Get-Random) -NoNewline }; Write-Host ""
    } else {
        Write-Host "`r$spaces$($visual.Text)" -ForegroundColor ($allColors | Get-Random) -NoNewline
    }
    # 3. Occasionally play a long beep
    if ((Get-Random -Minimum 0 -Maximum 6) -eq 0) {
        [console]::Beep($freq, 500)
    } else {
        [console]::Beep($freq, $duration)
    }
    Start-Sleep -Milliseconds 1
}

function Show-AsciiArt {
    $arts = @(
        @'
   (o_o)
  <(   )>
    / \
'@,
        @'
  /\_/\
 ( o.o )
  > ^ <
'@,
        @'
  |\---/|
  | o_o |
   \_^_/
'@,
        @'
   .-"""-.
  / .===. \
  \/ 6 6 \/
  ( \___/ )
___ooo__ooo___
'@,
        @'
   _____
  /     \
 | () () |
  \  ^  /
   ||||#
   ||||#
'@,
        @'
   __
  /  \
 |    |
 |    |
 |____|
'@,
        @'
   .-.
  (o o)
   |=|
  __|__
'@,
        @'
  ( )  ( )
   (  ..  )
    (____)
'@,
        @'
   _____
  /     \
 |  0 0  |
  \  ^  /
   ||||#
   ||||#
'@,
        @'
  (\_/)
  ( •_•)
 / >🍪
'@
    )
    Write-Host ("`n" + ($arts | Get-Random)) -ForegroundColor ("Cyan","Yellow","Magenta","Green" | Get-Random)
    Start-Sleep -Milliseconds 400
}

function Play-Chord {
    param([int[]]$freqs, [int]$duration)
    foreach ($f in $freqs) {
        $clamped = [Math]::Max(37, [Math]::Min(32767, $f))
        [console]::Beep($clamped, [Math]::Max(10, [Math]::Min($duration, 40)))
    }
}

function Start-Visualizer {
    Clear-Host
    Write-Host "Console Sound Visualizer: WILD MODE"
    Write-Host "Press Ctrl+C to exit`n"
    $scale = @(262, 294, 330, 349, 392, 440, 494, 523, 587, 659, 698, 784, 880, 988, 1047)
    $frame = 0
    try {
        while ($true) {
            foreach ($baseFreq in $scale) {
                $randomOffset = Get-Random -Minimum -60 -Maximum 60
                $freq = $baseFreq + $randomOffset
                $freq = [Math]::Max(37, [Math]::Min(32767, $freq)) # Clamp to valid beep range
                $duration = Get-Random -Minimum 5 -Maximum 20
                $reverse = $false
                $glitch = $false
                # Every 20 frames, show ASCII art
                if ($frame % 20 -eq 0 -and $frame -ne 0) {
                    Show-AsciiArt
                }
                # Occasionally invert direction
                if ((Get-Random -Minimum 0 -Maximum 12) -eq 0) {
                    $reverse = $true
                }
                # Occasionally glitch
                if ((Get-Random -Minimum 0 -Maximum 18) -eq 0) {
                    $glitch = $true
                }
                # Occasionally play a chord
                if ((Get-Random -Minimum 0 -Maximum 25) -eq 0) {
                    $chord = @($freq, $freq + 37, $freq + 7)
                    Play-Chord -freqs $chord -duration $duration
                } else {
                    Show-SoundVisual -freq $freq -duration $duration -reverse:$reverse -glitch:$glitch
                }
                $frame++
            }
            if ((Get-Random -Minimum 0 -Maximum 2) -eq 0) {
                [array]::Reverse($scale)
            }
        }
    }
    catch {
        Write-Host $error
    }
    finally {
        Write-Host ""
    }
}

# Run the visualizer
Start-Visualizer