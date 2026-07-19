<#
    Fantasy Sound Player
    An interactive menu to play original tunes/effects via [Console]::Beep().
    Safe for managed environments: no network, no files, no elevation.
#>

# --- Note frequency table (Hz), including sharps/flats ---
$note = @{
    'REST' = 37     # near-inaudible placeholder for rests (min freq is 37)
    'C3'=131;  'CS3'=139; 'D3'=147;  'DS3'=156; 'E3'=165;  'F3'=175
    'FS3'=185; 'G3'=196;  'GS3'=208; 'A3'=220;  'AS3'=233; 'B3'=247
    'C4'=262;  'CS4'=277; 'D4'=294;  'DS4'=311; 'E4'=330;  'F4'=349
    'FS4'=370; 'G4'=392;  'GS4'=415; 'A4'=440;  'AS4'=466; 'B4'=494
    'C5'=523;  'CS5'=554; 'D5'=587;  'DS5'=622; 'E5'=659;  'F5'=698
    'FS5'=740; 'G5'=784;  'GS5'=831; 'A5'=880;  'AS5'=932; 'B5'=988
    'C6'=1047; 'CS6'=1109;'D6'=1175; 'DS6'=1245;'E6'=1319; 'F6'=1397
    'FS6'=1480;'G6'=1568
}

# --- Play a single note (or rest) ---
function Play-Note {
    param([string]$Name, [int]$Duration)
    if ($Name -eq 'REST') {
        Start-Sleep -Milliseconds $Duration
    } else {
        [Console]::Beep($note[$Name], $Duration)
    }
    Start-Sleep -Milliseconds 12   # tiny gap so repeated notes are distinct
}

# --- Play a whole sequence, given a base quarter-note length ---
function Play-Sequence {
    param([array]$Sequence, [int]$Quarter)
    $e  = [int]($Quarter / 2)      # eighth
    $s  = [int]($Quarter / 4)      # sixteenth
    $h  = [int]($Quarter * 2)      # half
    $dh = [int]($Quarter * 3)      # dotted half
    $w  = [int]($Quarter * 4)      # whole
    $q  = $Quarter

    $dur = @{ 's'=$s; 'e'=$e; 'q'=$q; 'h'=$h; 'dh'=$dh; 'w'=$w }
    foreach ($n in $Sequence) {
        Play-Note -Name $n[0] -Duration $dur[$n[1]]
    }
}

# ============================================================
#  MAIN MENU THEME  (extended)
#  Format: @('NOTE','duration')  where duration = s,e,q,h,dh,w
# ============================================================
$mainMenuTheme = @(
    # --- Section A: heroic opening ---
    @('G4','e'), @('C5','e'), @('E5','q'), @('G5','q')
    @('F5','e'), @('E5','e'), @('D5','h'), @('REST','e')
    @('A4','e'), @('D5','e'), @('F5','q'), @('A5','q')
    @('G5','e'), @('F5','e'), @('E5','h'), @('REST','e')

    # --- Section B: soaring midsection ---
    @('C6','q'), @('B5','e'), @('A5','e')
    @('G5','q'), @('E5','q')
    @('F5','e'), @('G5','e'), @('A5','h'), @('REST','e')

    # --- Section C: new lyrical phrase (extension) ---
    @('E5','e'), @('F5','e'), @('G5','q'), @('C6','q')
    @('B5','e'), @('A5','e'), @('G5','h'), @('REST','e')
    @('A5','e'), @('G5','e'), @('F5','q'), @('D5','q')
    @('E5','e'), @('F5','e'), @('E5','h'), @('REST','e')

    # --- Section D: descending bridge (extension) ---
    @('C6','q'), @('A5','q'), @('F5','q'), @('D5','q')
    @('E5','e'), @('D5','e'), @('C5','e'), @('D5','e')
    @('E5','h'), @('REST','e')

    # --- Section E: build-up (extension) ---
    @('G5','e'), @('A5','e'), @('B5','e'), @('C6','e')
    @('D6','q'), @('E6','q')
    @('D6','e'), @('C6','e'), @('B5','q'), @('G5','q')

    # --- Section F: triumphant resolve ---
    @('G5','e'), @('A5','e'), @('B5','e'), @('C6','e')
    @('D6','q'), @('B5','q')
    @('C6','dh'), @('REST','q')
)

# ============================================================
#  BATTLE THEME  (fast, driving, minor key)
# ============================================================
$battleTheme = @(
    # Tense pulsing intro
    @('E4','e'), @('E4','e'), @('E5','e'), @('E4','e')
    @('F4','e'), @('E4','e'), @('D4','e'), @('E4','e')

    # Main aggressive riff
    @('A4','q'), @('C5','e'), @('B4','e'), @('A4','e'), @('G4','e')
    @('A4','q'), @('E5','q')
    @('F5','e'), @('E5','e'), @('D5','e'), @('C5','e'), @('B4','q')

    # Rising tension
    @('A4','e'), @('B4','e'), @('C5','e'), @('D5','e')
    @('E5','e'), @('F5','e'), @('G5','e'), @('A5','e')

    # Climax hits
    @('A5','q'), @('G5','e'), @('F5','e'), @('E5','q'), @('D5','q')
    @('C5','e'), @('D5','e'), @('E5','h')
    @('REST','e')
)

# ============================================================
#  CHEST OPEN  (short "treasure get" jingle)
# ============================================================
$chestOpen = @(
    @('G5','s'), @('A5','s'), @('B5','s'), @('C6','s')
    @('D6','s'), @('E6','s'), @('G6','e')
    @('REST','s')
    @('E6','e'), @('G6','q')     # sparkling resolve
)

# ============================================================
#  MENU SYSTEM
# ============================================================
function Show-Menu {
    Clear-Host
    Write-Host ""
    Write-Host "  ============================================" -ForegroundColor DarkCyan
    Write-Host "            F A N T A S Y   S O U N D S       " -ForegroundColor Cyan
    Write-Host "  ============================================" -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host "    [1] Main Menu Theme        (loops)" -ForegroundColor White
    Write-Host "    [2] Battle Theme           (loops)" -ForegroundColor White
    Write-Host "    [3] Open Chest             (one-shot)" -ForegroundColor White
    Write-Host "    [Q] Quit" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  --------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  Looping tracks: press Ctrl+C to stop, then" -ForegroundColor DarkGray
    Write-Host "  press Enter to return to this menu." -ForegroundColor DarkGray
    Write-Host ""
}

function Play-Looping {
    param([array]$Sequence, [int]$Quarter, [string]$Title)
    Write-Host ""
    Write-Host "  Now playing: $Title" -ForegroundColor Yellow
    Write-Host "  (Ctrl+C to stop)" -ForegroundColor DarkGray
    Write-Host ""
    try {
        $loop = 1
        while ($true) {
            Write-Host ("    Loop #{0}..." -f $loop) -ForegroundColor DarkGray
            Play-Sequence -Sequence $Sequence -Quarter $Quarter
            Start-Sleep -Milliseconds 700
            $loop++
        }
    }
    finally {
        Write-Host ""
        Write-Host "  Stopped. Press Enter to return to the menu." -ForegroundColor DarkGray
        [void](Read-Host)
    }
}

# --- Main loop ---
$running = $true
while ($running) {
    Show-Menu
    $choice = Read-Host "  Choose an option"

    switch ($choice.ToUpper()) {
        '1' { Play-Looping -Sequence $mainMenuTheme -Quarter 250 -Title "Main Menu Theme" }
        '2' { Play-Looping -Sequence $battleTheme   -Quarter 180 -Title "Battle Theme" }
        '3' {
            Write-Host ""
            Write-Host "  You found a treasure chest!" -ForegroundColor Yellow
            Play-Sequence -Sequence $chestOpen -Quarter 220
            Start-Sleep -Milliseconds 400
        }
        'Q' {
            $running = $false
            Write-Host ""
            Write-Host "  Farewell, adventurer." -ForegroundColor Cyan
            Write-Host ""
        }
        default {
            Write-Host "  Unknown option. Try again." -ForegroundColor Red
            Start-Sleep -Milliseconds 800
        }
    }
}
