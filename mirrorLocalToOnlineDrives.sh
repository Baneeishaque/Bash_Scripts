cd ~
echo "GDrive-Banee3"
echo "----------------"
echo "rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque3-GDrive/ GDrive-Banee3: --fast-list --filter-from Data/Labs/Lab_Banee/rclone/FreeFileSync-filter.txt --dry-run"
echo "----------------"
rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque3-GDrive/ GDrive-Banee3: --fast-list --filter-from Data/Labs/Lab_Banee/rclone/FreeFileSync-filter.txt --dry-run
pause
echo "GDrive-Banee4"
echo "----------------"
echo "rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque4-GDrive/ GDrive-Banee4: --fast-list --filter-from Data/Labs/Lab_Banee/rclone/FreeFileSync-filter.txt --dry-run"
echo "----------------"
rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque4-GDrive/ GDrive-Banee4: --fast-list --filter-from Data/Labs/Lab_Banee/rclone/FreeFileSync-filter.txt --dry-run
pause
echo "GDrive-Banee5"
echo "----------------"
echo "rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque5-GDrive/ GDrive-Banee5: --fast-list --dry-run"
echo "----------------"
rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque5-GDrive/ GDrive-Banee5: --fast-list --dry-run

