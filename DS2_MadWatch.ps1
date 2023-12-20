# Process name for Dark Souls 2
$processName = "DarkSoulsII"

# Time interval for checking the process (in seconds)
$interval = 0.1

# Store the last memory usage
$lastMemory = 0

# Continuously check in an infinite loop
while ($true) {
    # Get process information
    $process = Get-Process | Where-Object { $_.ProcessName -eq $processName } -ErrorAction SilentlyContinue | Select-Object -First 1

    # If process exists
    if ($process) {
        # Convert memory from bytes to MB
        $currentMemory = $process.WorkingSet64 / 1MB

        # If not the first check, compare memory usage
        if ($lastMemory -ne 0) {
            # Calculate change in memory
            $memoryChange = $currentMemory - $lastMemory

            # If increase in memory is more than 5 MB, indicate possible spawn and beep
            if ($memoryChange -gt 5) {
                Clear-Host
                Write-Output "$(Get-Date -Format "HH:mm:ss") - Mad Warrior spawned. Memory increased by $memoryChange MB"
                [Console]::Beep(1000, 500) # Beep for 500 milliseconds at 1000 Hz
            }
        }
        
        # Update last memory usage for next comparison
        $lastMemory = $currentMemory
    }
    else {
        Write-Output "Process $processName not found."
    }

    # Wait for the defined interval before next check
    Start-Sleep -Milliseconds (1000 * $interval)
}
