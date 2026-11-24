# Smooth beating heart for the console, centered. Ctrl+C to stop.
$text = "I LOVE YOU"   # change this text
$esc  = [char]27
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$half = [string][char]0x2580
[Console]::CursorVisible = $false
Clear-Host
$sw = [Diagnostics.Stopwatch]::StartNew()
$lastW = 0; $lastH = 0
$cr = @(0,0); $cg = @(0,0); $cb = @(0,0)
try {
  while ($true) {
    $ww = $Host.UI.RawUI.WindowSize.Width
    $wh = $Host.UI.RawUI.WindowSize.Height
    if ($ww -ne $lastW -or $wh -ne $lastH) { Clear-Host; $lastW = $ww; $lastH = $wh }
    $rows = [math]::Min(26, $wh - 4)
    if ($rows -lt 8) { $rows = 8 }
    $ph = $rows * 2
    $pw = [math]::Min($ph, $ww - 2)
    $left = [math]::Max(0, [int](($ww - $pw) / 2))
    $top  = [math]::Max(0, [int](($wh - $rows - 2) / 2))
    $t = $sw.Elapsed.TotalSeconds
    $beat  = [math]::Pow([math]::Abs([math]::Sin($t * 3.2)), 6)
    $scale = 0.92 + 0.20 * $beat
    $sb = New-Object Text.StringBuilder
    for ($row = 0; $row -lt $rows; $row++) {
      [void]$sb.Append("$esc[$($top + $row + 1);$($left + 1)H")
      $prev = ''
      for ($col = 0; $col -lt $pw; $col++) {
        for ($k = 0; $k -lt 2; $k++) {
          $py = $row * 2 + $k
          $nx = ($col - $pw / 2 + 0.5) / ($ph / 2) * 1.45 / $scale
          $ny = (($ph / 2) - $py - 0.5) / ($ph / 2) * 1.45 / $scale + 0.12
          $a = $nx * $nx + $ny * $ny - 1
          $v = $a * $a * $a - $nx * $nx * $ny * $ny * $ny
          if ($v -ge 0) {
            $cr[$k] = -1
          } else {
            $al = -$v * 25; if ($al -gt 1) { $al = 1 }
            $d  = -$v / 0.7; if ($d -gt 1) { $d = 1 }
            $hx = $nx + 0.45; $hy = $ny - 0.5
            $hl = 1 - ($hx * $hx + $hy * $hy) * 2.2; if ($hl -lt 0) { $hl = 0 }
            $rr = 190 + 55 * $d + 70 * $hl + 20 * $beat
            $gg = 25 + 45 * $d + 70 * $hl + 10 * $beat
            $bb = 60 + 45 * $d + 70 * $hl + 10 * $beat
            if ($rr -gt 255) { $rr = 255 }
            if ($gg -gt 255) { $gg = 255 }
            if ($bb -gt 255) { $bb = 255 }
            $cr[$k] = [int](([int](12 + ($rr - 12) * $al)) / 4) * 4
            $cg[$k] = [int](([int](12 + ($gg - 12) * $al)) / 4) * 4
            $cb[$k] = [int](([int](12 + ($bb - 12) * $al)) / 4) * 4
          }
        }
        if ($cr[0] -lt 0 -and $cr[1] -lt 0) {
          if ($prev -ne 'bg') { [void]$sb.Append("$esc[0m "); $prev = 'bg' } else { [void]$sb.Append(' ') }
        } else {
          $tr = $cr[0]; $tg = $cg[0]; $tb = $cb[0]
          $br = $cr[1]; $bg = $cg[1]; $bl = $cb[1]
          if ($tr -lt 0) { $tr = 12; $tg = 12; $tb = 12 }
          if ($br -lt 0) { $br = 12; $bg = 12; $bl = 12 }
          $key = "$tr,$tg,$tb,$br,$bg,$bl"
          if ($key -ne $prev) {
            [void]$sb.Append("$esc[38;2;${tr};${tg};${tb}m$esc[48;2;${br};${bg};${bl}m")
            $prev = $key
          }
          [void]$sb.Append($half)
        }
      }
    }
    $tl = [math]::Max(0, [int](($ww - $text.Length) / 2))
    [void]$sb.Append("$esc[0m$esc[$($top + $rows + 2);$($tl + 1)H$esc[97m$text$esc[0m")
    [Console]::Write($sb.ToString())
  }
} finally {
  [Console]::CursorVisible = $true
  [Console]::Write("$esc[0m")
}
