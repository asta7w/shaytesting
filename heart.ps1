# Beating heart animation for the console. Ctrl+C to stop.
$text = "I LOVE YOU"   # change this text
$esc  = [char]27
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$full = [string][char]0x2588; $mid = [string][char]0x2593; $lite = [string][char]0x2592
$w = 64; $h = 28; $f = 0
Clear-Host
[Console]::CursorVisible = $false
try {
  while ($true) {
    $beat  = [math]::Pow([math]::Abs([math]::Sin($f * 0.18)), 6)
    $scale = 0.95 + 0.22 * $beat
    $color = if ($beat -gt 0.35) { "91" } else { "31" }
    $sb = New-Object Text.StringBuilder
    for ($y = 0; $y -lt $h; $y++) {
      for ($x = 0; $x -lt $w; $x++) {
        $nx = ($x - $w / 2) / ($w / 2) * 1.5 / $scale
        $ny = (($h / 2) - $y) / ($h / 2) * 1.5 / $scale + 0.1
        $a = $nx * $nx + $ny * $ny - 1
        $v = $a * $a * $a - $nx * $nx * $ny * $ny * $ny
        if ($v -le -0.25) { [void]$sb.Append($full) }
        elseif ($v -le -0.05) { [void]$sb.Append($mid) }
        elseif ($v -le 0) { [void]$sb.Append($lite) }
        else { [void]$sb.Append(' ') }
      }
      [void]$sb.Append("`n")
    }
    $pad = ' ' * [math]::Max(0, [int](($w - $text.Length) / 2))
    [Console]::SetCursorPosition(0, 0)
    [Console]::Write("$esc[${color}m" + $sb.ToString() + "$esc[97m" + $pad + $text + "$esc[0m")
    $f++
    Start-Sleep -Milliseconds 40
  }
} finally {
  [Console]::CursorVisible = $true
  Write-Host "$esc[0m"
}
