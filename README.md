# Laptop Backup Automation

Shell scripts in this repository automate daily backups of the current user's home directory to Google Drive via `rclone`. The workflow supports one-off syncs, progress monitoring, and a user-level systemd timer that triggers a backup shortly after boot and every 24 hours thereafter.

## Prerequisites
- Linux distro with `systemd` user services enabled.
- `rclone` installed (`sudo apt install rclone` or equivalent).
- A Google Drive remote named `gdrive` configured via `rclone config`.

## Setup Steps
1. **Configure Google Drive** (first run only):
   ```bash
   ./setup_gdrive.sh      # writes a template rclone config
   rclone config reconnect gdrive:
   rclone ls gdrive:      # quick connectivity check
   ```
2. **Prime the log directory**: already handled by the scripts (`logs/` keeps all run logs, tracked via `.gitkeep`).
3. **Test a manual backup (runs in background with nohup)**:
   ```bash
   ./run_daily_backup_bg.sh
   tail -f logs/daily_backup_$(date +%Y%m%d).log   # primary rclone log
   ```
   The wrapper writes the `nohup` console output to `logs/manual_nohup_<timestamp>.log` and records the PID in `backup.pid`.
   ```

## Installing the Daily Service
Use the helper to manage a per-user systemd unit:
```bash
./backup-service.sh install   # creates ~/.config/systemd/user/{daily-backup.service,timer}
./backup-service.sh status    # shows timer schedule + last logs
./backup-service.sh uninstall # removes the service
```
The timer waits ~5 minutes after boot (`OnBootSec=5min`), then runs every 24 hours (`OnUnitActiveSec=1d`). `loginctl enable-linger $USER` is invoked so the timer survives logouts. Ensure the laptop connects to the internet before the scheduled run so `rclone` can refresh Drive tokens.

## Manual Utilities
- `run_daily_backup_bg.sh`: launches `daily_backup.sh` via `nohup`, captures stdout/stderr in `logs/manual_nohup_<timestamp>.log`, and records the PID to `backup.pid`.
- `full_home_backup.sh`: one-off full copy to `gdrive:home_backup_full/` with richer progress stats.
- `monitor_backup.sh`: shows PID status, tails `backup_progress.txt`, and streams the newest log under `logs/`.
- `check_backup_status.sh`: inspects today's log, lists recent logs, and reports lock-file state.

## Logs & State Files
- Runtime lock/progress files (`backup.lock`, `backup_progress.txt`) are ignored by git via `.gitignore`.
- Persistent logs live in `logs/`. Keep them for audit purposes but avoid committing large history by leaving only `.gitkeep` tracked.
