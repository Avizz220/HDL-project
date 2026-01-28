Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   VENDING MACHINE SIMULATION" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$iverilogPath = Get-Command iverilog -ErrorAction SilentlyContinue

if (-not $iverilogPath) {
    Write-Host "Error: Icarus Verilog not found!" -ForegroundColor Red
    Write-Host "Please install Icarus Verilog:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://bleyer.org/icarus/" -ForegroundColor Yellow
    Write-Host "2. Or visit: https://github.com/steveicarus/iverilog/releases" -ForegroundColor Yellow
    Write-Host "`nAfter installation, restart VS Code and run this script again.`n" -ForegroundColor Yellow
    
    Write-Host "Alternative: Use EDA Playground (no installation needed)" -ForegroundColor Green
    Write-Host "Visit: https://www.edaplayground.com/`n" -ForegroundColor Green
    exit 1
}

Write-Host "Icarus Verilog found at: $($iverilogPath.Source)`n" -ForegroundColor Green

Write-Host "Cleaning previous build..." -ForegroundColor Yellow
Remove-Item -Path "vending_machine.vvp" -ErrorAction SilentlyContinue
Remove-Item -Path "dump.vcd" -ErrorAction SilentlyContinue

Write-Host "Compiling design files..." -ForegroundColor Yellow
$compileResult = & iverilog -g2012 -o vending_machine.vvp vending_machine.sv testbench.sv 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "`nCompilation failed!" -ForegroundColor Red
    Write-Host $compileResult -ForegroundColor Red
    exit 1
}

Write-Host "Compilation successful!`n" -ForegroundColor Green

# Simulate
Write-Host "========================================`n" -ForegroundColor Cyan

& vvp vending_machine.vvp

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Simulation completed successfully!" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    if (Test-Path "dump.vcd") {
        Write-Host "Waveform file generated: dump.vcd" -ForegroundColor Green
        Write-Host "View with GTKWave (if installed): gtkwave dump.vcd`n" -ForegroundColor Yellow
    }
} else {
    Write-Host "`nSimulation failed!" -ForegroundColor Red
    exit 1
}
