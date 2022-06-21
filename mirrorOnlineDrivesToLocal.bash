cd ~

echo "Amherstqa-files"
echo "----------------"
echo "rclone sync Amherstqa-files: Data/Misc/Baneeishaque5-GDrive/To_DK/Amhetstqa-files/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Amherstqa-files-filter.txt --dry-run"
echo "----------------"
rclone sync Amherstqa-files: Data/Misc/Baneeishaque5-GDrive/To_DK/Amhetstqa-files/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Amherstqa-files-filter.txt --dry-run

echo "Amherstqa-log-files"
echo "----------------"
echo "rclone sync Amherstqa-log-files: Data/Misc/Amhetstqa-log-files/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Amherstqa-log-files-filter.txt --dry-run"
echo "----------------"
rclone sync Amherstqa-log-files: Data/Misc/Amhetstqa-log-files/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Amherstqa-log-files-filter.txt --dry-run
echo rclone check Amherstqa-log-files: Data/Misc/Amhetstqa-log-files/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Amherstqa-log-files-filter.txt --differ Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Amherstqa-log-files-differ.txt --error Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Amherstqa-log-files-error.txt --missing-on-dst Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Amherstqa-log-files-missing-on-dst.txt --missing-on-src Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Amherstqa-log-files-missing-on-src.txt

echo "Blomp-Banee-Gmail-Drive"
echo "----------------"
echo "rclone sync Blomp-Banee-Gmail-Drive: Data/Misc/Blomp-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Blomp-Banee-Gmail-Drive-filter.txt --dry-run"
echo "----------------"
rclone sync Blomp-Banee-Gmail-Drive: Data/Misc/Blomp-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Blomp-Banee-Gmail-Drive-filter.txt --dry-run

echo "Blomp-Banee2-Gmail-Drive"
echo "----------------"
echo "rclone sync Blomp-Banee2-Gmail-Drive: Data/Misc/Blomp-Banee2-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Blomp-Banee2-Gmail-Drive-filter.txt --dry-run"
echo "----------------"
rclone sync Blomp-Banee2-Gmail-Drive: Data/Misc/Blomp-Banee2-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Blomp-Banee2-Gmail-Drive-filter.txt --dry-run

echo "Blomp-Banee3-Gmail-Drive"
echo "----------------"
echo "rclone sync Blomp-Banee3-Gmail-Drive: Data/Misc/Blomp-Banee3-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Blomp-Banee3-Gmail-Drive-filter.txt --dry-run"
echo "----------------"
rclone sync Blomp-Banee3-Gmail-Drive: Data/Misc/Blomp-Banee3-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Blomp-Banee3-Gmail-Drive-filter.txt --dry-run

echo "Blomp-Banee4-Gmail-Drive"
echo "----------------"
echo "rclone sync Blomp-Banee4-Gmail-Drive: Data/Misc/Blomp-Banee4-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync Blomp-Banee4-Gmail-Drive: Data/Misc/Blomp-Banee4-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run

echo "Box-Banee-Gmail"
echo "----------------"
echo "rclone sync Box-Banee-Gmail: Data/Misc/Box-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync Box-Banee-Gmail: Data/Misc/Box-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run

echo "Dropbox-Banee-Gmail"
echo "----------------"
echo "rclone sync Dropbox-Banee-Gmail: Data/Misc/Dropbox/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Dropbox-Banee-Gmail-root-filter.txt --dry-run"
echo "----------------"
rclone sync Dropbox-Banee-Gmail: Data/Misc/Dropbox/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Dropbox-Banee-Gmail-root-filter.txt --dry-run

echo "EShopees-SFTP:/var/www/"
echo "----------------"
echo "echo rclone sync EShopees-SFTP:/var/www/ Data/Misc/To-DK/EShopees/EShopees-var-www/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/EShopees-SFTP-filter.txt --dry-run"
echo "----------------"
echo rclone sync EShopees-SFTP:/var/www/ Data/Misc/To-DK/EShopees/EShopees-var-www/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/EShopees-SFTP-filter.txt --dry-run
echo rclone check EShopees-SFTP:/var/www/ Data/Misc/To-DK/EShopees/EShopees-var-www/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/EShopees-SFTP-filter.txt --differ Data/Labs/Lab_Banee/Misc/configurations-private/rclone/EShopees-SFTP-differ.txt --error Data/Labs/Lab_Banee/Misc/configurations-private/rclone/EShopees-SFTP-error.txt --missing-on-dst Data/Labs/Lab_Banee/Misc/configurations-private/rclone/EShopees-SFTP-missing-on-dst.txt --missing-on-src Data/Labs/Lab_Banee/Misc/configurations-private/rclone/EShopees-SFTP-missing-on-src.txt

echo "GDrive-Banee"
echo "----------------"
echo "rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee: Data/Misc/Baneeishaque-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --dry-run"
echo "----------------"
rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee: Data/Misc/Baneeishaque-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --dry-run

echo "GDrive-Banee2"
echo "----------------"
echo "rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee2: Data/Misc/Baneeishaque2-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --dry-run"
echo "----------------"
rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee2: Data/Misc/Baneeishaque2-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --dry-run

echo "GDrive-Banee3"
echo "----------------"
echo "rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee3: Data/Misc/Baneeishaque3-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --dry-run"
echo "----------------"
rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee3: Data/Misc/Baneeishaque3-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --dry-run

echo "GDrive-Banee4"
echo "----------------"
echo "rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee4: Data/Misc/Baneeishaque4-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --dry-run"
echo "----------------"
rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee4: Data/Misc/Baneeishaque4-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --dry-run

echo "GDrive-Banee5"
echo "----------------"
echo "rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee5: Data/Misc/Baneeishaque5-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --dry-run"
echo "----------------"
rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee5: Data/Misc/Baneeishaque5-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --dry-run
echo rclone check GDrive-Banee5: Data/Misc/Baneeishaque5-GDrive/ --fast-list --progress --progress-terminal-title --human-readable --differ Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GDrive-Banee5-differ.txt --error Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GDrive-Banee5-error.txt --missing-on-dst Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GDrive-Banee5-missing-on-dst.txt --missing-on-src Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GDrive-Banee5-missing-on-src.txt

echo "GDrive-Banee6"
echo "----------------"
echo "rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee6: Data/Misc/Baneeishaque6-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GDrive-Banee6-root-filter.txt --dry-run"
echo "----------------"
rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee6: Data/Misc/Baneeishaque6-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GDrive-Banee6-root-filter.txt --dry-run

echo "GDrive-Banee7"
echo "----------------"
echo "rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee7: Data/Misc/Baneeishaque7-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --dry-run"
echo "----------------"
rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee7: Data/Misc/Baneeishaque7-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/FreeFileSync-filter.txt --dry-run

echo "GPhotos-Banee:media/by-day/"
echo "----------------"
echo "rclone sync GPhotos-Banee:media/by-day/ Data/Misc/Baneeishaque-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync GPhotos-Banee:media/by-day/ Data/Misc/Baneeishaque-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --dry-run
echo "GPhotos-Banee:album/"
echo "----------------"
echo "rclone sync GPhotos-Banee:album/ Data/Misc/Baneeishaque-GPhotos/album/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync GPhotos-Banee:album/ Data/Misc/Baneeishaque-GPhotos/album/ --progress --progress-terminal-title --human-readable --dry-run
echo rclone check GPhotos-Banee:media/by-day/ Data/Misc/Baneeishaque-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --differ Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GPhotos-Banee-differ.txt --error Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GPhotos-Banee-error.txt --missing-on-dst Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GPhotos-Banee-missing-on-dst.txt --missing-on-src Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GPhotos-Banee-missing-on-src.txt

echo "GPhotos-Banee2:media/by-day/"
echo "----------------"
echo "rclone sync GPhotos-Banee2:media/by-day/ Data/Misc/Baneeishaque2-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync GPhotos-Banee2:media/by-day/ Data/Misc/Baneeishaque2-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --dry-run
echo "GPhotos-Banee2:album/"
echo "----------------"
echo "rclone sync GPhotos-Banee2:album/ Data/Misc/Baneeishaque2-GPhotos/album/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync GPhotos-Banee2:album/ Data/Misc/Baneeishaque2-GPhotos/album/ --progress --progress-terminal-title --human-readable --dry-run

echo "GPhotos-Banee3:media/by-day/"
echo "----------------"
echo "rclone sync GPhotos-Banee3:media/by-day/ Data/Misc/Baneeishaque3-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync GPhotos-Banee3:media/by-day/ Data/Misc/Baneeishaque3-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --dry-run
echo "GPhotos-Banee3:album/"
echo "----------------"
echo "rclone sync GPhotos-Banee3:album/ Data/Misc/Baneeishaque3-GPhotos/album/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync GPhotos-Banee3:album/ Data/Misc/Baneeishaque3-GPhotos/album/ --progress --progress-terminal-title --human-readable --dry-run
echo rclone check GPhotos-Banee3:media/by-day/ Data/Misc/Baneeishaque3-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --differ Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GPhotos-Banee3-differ.txt --error Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GPhotos-Banee3-error.txt --missing-on-dst Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GPhotos-Banee3-missing-on-dst.txt --missing-on-src Data/Labs/Lab_Banee/Misc/configurations-private/rclone/GPhotos-Banee3-missing-on-src.txt

echo "GPhotos-Banee7:media/by-day/"
echo "----------------"
echo "rclone sync GPhotos-Banee7:media/by-day/ Data/Misc/Baneeishaque7-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync GPhotos-Banee7:media/by-day/ Data/Misc/Baneeishaque7-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --dry-run
echo "GPhotos-Banee7:album/"
echo "----------------"
echo "rclone sync GPhotos-Banee7:album/ Data/Misc/Baneeishaque7-GPhotos/album/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync GPhotos-Banee7:album/ Data/Misc/Baneeishaque7-GPhotos/album/ --progress --progress-terminal-title --human-readable --dry-run

echo "Mail-ru-Banee-Gmail"
echo "----------------"
echo "rclone sync Mail-ru-Banee-Gmail: Data/Misc/Mail-ru-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync Mail-ru-Banee-Gmail: Data/Misc/Mail-ru-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run

echo "Mega-Banee-Gmail"
echo "----------------"
echo "rclone sync Mega-Banee-Gmail: Data/Misc/Mega-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee-Gmail-root-filter.txt --dry-run"
echo "----------------"
rclone sync Mega-Banee-Gmail: Data/Misc/Mega-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee-Gmail-root-filter.txt --dry-run

echo "Mega-Banee2-Gmail"
echo "----------------"
echo "rclone sync Mega-Banee2-Gmail: Data/Misc/Mega-Banee2-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee2-Gmail-root-filter.txt --dry-run"
echo "----------------"
rclone sync Mega-Banee2-Gmail: Data/Misc/Mega-Banee2-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee2-Gmail-root-filter.txt --dry-run

echo "Mega-Banee3-Gmail"
echo "----------------"
echo "rclone sync Mega-Banee3-Gmail: Data/Misc/Mega-Banee3-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee3-Gmail-root-filter.txt --dry-run"
echo "----------------"
rclone sync Mega-Banee3-Gmail: Data/Misc/Mega-Banee3-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee3-Gmail-root-filter.txt --dry-run

echo "Mega-Banee4-Gmail"
echo "----------------"
echo "rclone sync Mega-Banee4-Gmail: Data/Misc/Mega-Banee4-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee4-Gmail-root-filter.txt --dry-run"
echo "----------------"
rclone sync Mega-Banee4-Gmail: Data/Misc/Mega-Banee4-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee4-Gmail-root-filter.txt --dry-run

echo "Mega-Banee5-Gmail"
echo "----------------"
echo "rclone sync Mega-Banee5-Gmail: Data/Misc/Mega-Banee5-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee4-Gmail-root-filter.txt --dry-run"
echo "----------------"
rclone sync Mega-Banee5-Gmail: Data/Misc/Mega-Banee5-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Mega-Banee4-Gmail-root-filter.txt --dry-run

echo "Mega-Banee6-Gmail"
echo "----------------"
echo "rclone sync Mega-Banee6-Gmail: Data/Misc/Mega-Banee6-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync Mega-Banee6-Gmail: Data/Misc/Mega-Banee6-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run

echo "Mega-Banee7-Gmail"
echo "----------------"
echo "rclone sync Mega-Banee7-Gmail: Data/Misc/Mega-Banee7-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync Mega-Banee7-Gmail: Data/Misc/Mega-Banee7-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run

echo "Miles-5GB:public_html"
echo "----------------"
echo "rclone sync Miles-5GB:public_html Data/Misc/Miles-5GB-public_html/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Miles-5GB-public_html-filter.txt --dry-run"
echo "----------------"
rclone sync Miles-5GB:public_html Data/Misc/Miles-5GB-public_html/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Miles-5GB-public_html-filter.txt --dry-run

echo "One-Drive-Banee-Hotmail"
echo "----------------"
echo "rclone sync One-Drive-Banee-Hotmail: Data/Misc/One-Drive-Banee-Hotmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync One-Drive-Banee-Hotmail: Data/Misc/One-Drive-Banee-Hotmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run

echo "Pcloud-Banee-Gmail"
echo "----------------"
echo "rclone sync Pcloud-Banee-Gmail: Data/Misc/pCloud-Drive/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync Pcloud-Banee-Gmail: Data/Misc/pCloud-Drive/ --progress --progress-terminal-title --human-readable --dry-run

echo "Storj-Banee-Gmail"
echo "----------------"
echo "rclone sync Storj-Banee-Gmail: Data/Misc/Storj-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Storj-Banee-Gmail-root-filter.txt --dry-run"
echo "----------------"
rclone sync Storj-Banee-Gmail: Data/Misc/Storj-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Storj-Banee-Gmail-root-filter.txt --dry-run

echo "Wozi-info-tech-com"
echo "----------------"
echo "echo rclone sync Wozi-info-tech-com: Data/Misc/To-DK/Wozi-info-tech-com-root/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Wozi-info-tech-com-root-filter.txt --dry-run"
echo "----------------"
echo rclone sync Wozi-info-tech-com: Data/Misc/To-DK/Wozi-info-tech-com-root/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Wozi-info-tech-com-root-filter.txt --dry-run
echo rclone check Wozi-info-tech-com: Data/Misc/To-DK/Wozi-info-tech-com-root/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Wozi-info-tech-com-root-filter.txt --differ Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Wozi-info-tech-com-differ.txt --error Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Wozi-info-tech-com-error.txt --missing-on-dst Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Wozi-info-tech-com-missing-on-dst.txt --missing-on-src Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Wozi-info-tech-com-missing-on-src.txt

echo "Yandex-Banee"
echo "----------------"
echo "rclone sync Yandex-Banee: Data/Misc/Yandex-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run"
echo "----------------"
rclone sync Yandex-Banee: Data/Misc/Yandex-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run

echo "Telegram Desktop Movies to Storj-Banee-Gmail"
echo "----------------"
echo "rclone copy "/home/dk/Downloads/Telegram Desktop/" Storj-Banee-Gmail:films/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Telegram-Desktop-Movies-to-Storj-filter.txt --dry-run"
echo "----------------"
rclone copy "/home/dk/Downloads/Telegram Desktop/" Storj-Banee-Gmail:films/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/Misc/configurations-private/rclone/Telegram-Desktop-Movies-to-Storj-filter.txt --dry-run
