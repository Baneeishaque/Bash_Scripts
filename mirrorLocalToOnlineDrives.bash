cd ~

rclone sync Data/Misc/Blomp-Banee-Gmail-Drive/ Blomp-Banee-Gmail-Drive: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Blomp-Banee-Gmail-Drive-filter.txt --dry-run

rclone sync Data/Misc/Blomp-Banee2-Gmail-Drive/ Blomp-Banee2-Gmail-Drive: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Blomp-Banee2-Gmail-Drive-filter.txt --dry-run

rclone sync Data/Misc/Blomp-Banee3-Gmail-Drive/ Blomp-Banee3-Gmail-Drive: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Blomp-Banee3-Gmail-Drive-filter.txt --dry-run

rclone sync Data/Misc/Blomp-Banee4-Gmail-Drive/ Blomp-Banee4-Gmail-Drive: --progress --progress-terminal-title --human-readable --dry-run

echo "GDrive-Banee3"
echo "----------------"
echo "rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque3-GDrive/ GDrive-Banee3: --fast-list --filter-from Data/Labs/Lab_Banee/rclone/FreeFileSync-filter.txt --dry-run"
echo "----------------"
rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque3-GDrive/ GDrive-Banee3: --fast-list --filter-from Data/Labs/Lab_Banee/rclone/FreeFileSync-filter.txt --dry-run

pause

echo "GDrive-Banee4"
echo "----------------"
echo "rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque4-GDrive/ GDrive-Banee4: --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GDrive-Banee4-root-filter.txt --dry-run"
echo "----------------"
rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque4-GDrive/ GDrive-Banee4: --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GDrive-Banee4-root-filter.txt --dry-run

pause

echo "GDrive-Banee5"
echo "----------------"
echo "rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque5-GDrive/ GDrive-Banee5: --fast-list --dry-run"
echo "----------------"
rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque5-GDrive/ GDrive-Banee5: --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --dry-run

rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque6-GDrive/ GDrive-Banee6: --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GDrive-Banee6-root-filter.txt --dry-run

rclone sync Data/Misc/Baneeishaque-GPhotos/album/ GPhotos-Banee:album/ --progress --progress-terminal-title --human-readable --dry-run

rclone sync Data/Misc/Baneeishaque2-GPhotos/album/ GPhotos-Banee2:album/ --progress --progress-terminal-title --human-readable --dry-run

rclone sync Data/Misc/Baneeishaque3-GPhotos/album/ GPhotos-Banee3:album/ --progress --progress-terminal-title --human-readable --dry-run

rclone sync Data/Misc/Baneeishaque7-GPhotos/album/ GPhotos-Banee7:album/ --progress --progress-terminal-title --human-readable --dry-run

rclone sync Data/Misc/Mega-Banee-Gmail-Drive/ Mega-Banee-Gmail: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee-Gmail-root-filter.txt --dry-run

rclone sync Data/Misc/Mega-Banee2-Gmail-Drive/ Mega-Banee2-Gmail: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee2-Gmail-root-filter.txt --dry-run

echo "Avita-Linux -> Mega-Banee3-Gmail"
echo "----------------"
echo "rclone sync Data/Misc/Mega-Banee3-Gmail-Drive/ Mega-Banee3-Gmail: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee3-Gmail-root-filter.txt --dry-run"
echo "----------------"
rclone sync Data/Misc/Mega-Banee3-Gmail-Drive/ Mega-Banee3-Gmail: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee3-Gmail-root-filter.txt --dry-run

rclone sync Data/Misc/Mega-Banee4-Gmail-Drive/ Mega-Banee4-Gmail: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee4-Gmail-root-filter.txt --dry-run

rclone sync Data/Misc/Mega-Banee5-Gmail-Drive/ Mega-Banee5-Gmail: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee4-Gmail-root-filter.txt --dry-run

rclone sync Data/Misc/Mega-Banee6-Gmail-Drive/ Mega-Banee6-Gmail: --progress --progress-terminal-title --human-readable --dry-run

rclone sync Data/Misc/Mega-Banee7-Gmail-Drive/ Mega-Banee7-Gmail: --progress --progress-terminal-title --human-readable --dry-run

echo "Avita-Linux -> Mega-Banee-Hotmail"
echo "----------------"
echo "rclone sync Data/Misc/Mega-Banee-Hotmail-Drive/ Mega-Banee-Hotmail: --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync Data/Misc/Mega-Banee-Hotmail-Drive/ Mega-Banee-Hotmail: --progress --progress-terminal-title --human-readable --dry-run

rclone sync Data/Misc/Miles-5GB-public_html/ Miles-5GB:public_html --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Miles-5GB-public_html-filter.txt --dry-run

rclone sync Data/Misc/One-Drive-Banee-Hotmail-Drive/ One-Drive-Banee-Hotmail: --progress --progress-terminal-title --human-readable --dry-run

rclone sync Data/Misc/pCloud-Drive/ Pcloud-Banee-Gmail: --progress --progress-terminal-title --human-readable --dry-run

echo "Telegram Desktop Movies to Storj-Banee-Gmail"
echo "----------------"
echo "rclone copy "/home/dk/Downloads/Telegram Desktop/" Storj-Banee-Gmail:films/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Telegram-Desktop-Movies-to-Storj-filter.txt --dry-run"
echo "----------------"
rclone copy "/home/dk/Downloads/Telegram Desktop/" Storj-Banee-Gmail:films/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Telegram-Desktop-Movies-to-Storj-filter.txt --dry-run

read -r -s -p $'Press enter to continue...'

echo "Telegram Desktop Movies to Storj-Banee2-Gmail"
echo "----------------"
echo "rclone copy "/home/dk/Downloads/Telegram Desktop/" Storj-Banee2-Gmail:films/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Telegram-Desktop-Movies-to-Storj-Banee-Gmail-filter.txt --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Telegram-Desktop-Movies-to-Storj-Banee2-Gmail-filter.txt --dry-run"
echo "----------------"
rclone copy "/home/dk/Downloads/Telegram Desktop/" Storj-Banee2-Gmail:films/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Telegram-Desktop-Movies-to-Storj-Banee-Gmail-filter.txt --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Telegram-Desktop-Movies-to-Storj-Banee2-Gmail-filter.txt --dry-run

read -r -s -p $'Press enter to continue...'
