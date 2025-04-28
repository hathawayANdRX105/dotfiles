
def log [
    message: string,
    --level: string = "info",
    --file: string = "app.log"
] {
    let timestamp = (date now | format date  "%Y-%m-%d %H:%M:%S")
    let level_str = ($level | str upcase)
    let log_entry = $"[($timestamp)] ($level_str): ($message)"
    
    echo $log_entry
    $log_entry + "\n" | save --append $file
}
