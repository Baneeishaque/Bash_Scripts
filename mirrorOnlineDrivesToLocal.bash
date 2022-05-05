cd ~

rclone sync Amherstqa-files: Data/Misc/Baneeishaque5-GDrive/To_DK/Amhetstqa-files/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Amherstqa-files-filter.txt --dry-run

echo Amherstqa-log-files Local++
rclone sync Amherstqa-log-files: Data/Misc/Amhetstqa-log-files/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Amherstqa-log-files-filter.txt --dry-run
echo rclone check Amherstqa-log-files: Data/Misc/Amhetstqa-log-files/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Amherstqa-log-files-filter.txt --differ Data/Labs/Lab_Banee/rclone/Amherstqa-log-files-differ.txt --error Data/Labs/Lab_Banee/rclone/Amherstqa-log-files-error.txt --missing-on-dst Data/Labs/Lab_Banee/rclone/Amherstqa-log-files-missing-on-dst.txt --missing-on-src Data/Labs/Lab_Banee/rclone/Amherstqa-log-files-missing-on-src.txt

rclone sync Blomp-Banee-Gmail-Drive: Data/Misc/Blomp-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Blomp-Banee-Gmail-Drive-filter.txt --dry-run
rclone sync Data/Misc/Blomp-Banee-Gmail-Drive/ Blomp-Banee-Gmail-Drive: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Blomp-Banee-Gmail-Drive-filter.txt --dry-run

rclone sync Blomp-Banee2-Gmail-Drive: Data/Misc/Blomp-Banee2-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Blomp-Banee2-Gmail-Drive-filter.txt --dry-run
rclone sync Data/Misc/Blomp-Banee2-Gmail-Drive/ Blomp-Banee2-Gmail-Drive: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Blomp-Banee2-Gmail-Drive-filter.txt --dry-run

rclone sync Blomp-Banee3-Gmail-Drive: Data/Misc/Blomp-Banee3-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Blomp-Banee3-Gmail-Drive-filter.txt --dry-run
rclone sync Data/Misc/Blomp-Banee3-Gmail-Drive/ Blomp-Banee3-Gmail-Drive: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Blomp-Banee3-Gmail-Drive-filter.txt --dry-run

rclone sync Box-Banee-Gmail: Data/Misc/Box-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run

rclone sync Dropbox-Banee-Gmail: Data/Misc/Dropbox/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Dropbox-Banee-Gmail-root-filter.txt --dry-run

echo EShopees-SFTP Local++
rclone sync EShopees-SFTP:/var/www/ Data/Misc/To-DK/EShopees/EShopees-var-www/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/EShopees-SFTP-filter.txt --dry-run
echo rclone check EShopees-SFTP:/var/www/ Data/Misc/To-DK/EShopees/EShopees-var-www/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/EShopees-SFTP-filter.txt --differ Data/Labs/Lab_Banee/rclone/EShopees-SFTP-differ.txt --error Data/Labs/Lab_Banee/rclone/EShopees-SFTP-error.txt --missing-on-dst Data/Labs/Lab_Banee/rclone/EShopees-SFTP-missing-on-dst.txt --missing-on-src Data/Labs/Lab_Banee/rclone/EShopees-SFTP-missing-on-src.txt

rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee: Data/Misc/Baneeishaque-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/rclone/FreeFileSync-filter.txt --dry-run

rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee2: Data/Misc/Baneeishaque2-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/rclone/FreeFileSync-filter.txt --dry-run

rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee3: Data/Misc/Baneeishaque3-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/rclone/FreeFileSync-filter.txt --dry-run

rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee4: Data/Misc/Baneeishaque4-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/rclone/FreeFileSync-filter.txt --dry-run
rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque4-GDrive/ GDrive-Banee4: --fast-list --filter-from Data/Labs/Lab_Banee/rclone/FreeFileSync-filter.txt --dry-run

echo GDrive5++
rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee5: Data/Misc/Baneeishaque5-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/rclone/FreeFileSync-filter.txt --dry-run
echo rclone check GDrive-Banee5: Data/Misc/Baneeishaque5-GDrive/ --fast-list --progress --progress-terminal-title --human-readable --differ Data/Labs/Lab_Banee/rclone/GDrive-Banee5-differ.txt --error Data/Labs/Lab_Banee/rclone/GDrive-Banee5-error.txt --missing-on-dst Data/Labs/Lab_Banee/rclone/GDrive-Banee5-missing-on-dst.txt --missing-on-src Data/Labs/Lab_Banee/rclone/GDrive-Banee5-missing-on-src.txt

rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee6: Data/Misc/Baneeishaque6-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/rclone/GDrive-Banee6-root-filter.txt --dry-run
rclone sync --progress --progress-terminal-title --human-readable Data/Misc/Baneeishaque6-GDrive/ GDrive-Banee6: --fast-list --filter-from Data/Labs/Lab_Banee/rclone/GDrive-Banee6-root-filter.txt --dry-run

rclone sync --progress --progress-terminal-title --human-readable GDrive-Banee7: Data/Misc/Baneeishaque7-GDrive/ --fast-list --filter-from Data/Labs/Lab_Banee/rclone/FreeFileSync-filter.txt --dry-run

echo GPhotos Local++
rclone sync GPhotos-Banee:media/by-day/ Data/Misc/Baneeishaque-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --dry-run
rclone sync GPhotos-Banee:album/ Data/Misc/Baneeishaque-GPhotos/album/ --progress --progress-terminal-title --human-readable --dry-run
rclone sync Data/Misc/Baneeishaque-GPhotos/album/ GPhotos-Banee:album/ --progress --progress-terminal-title --human-readable --dry-run
echo rclone check GPhotos-Banee:media/by-day/ Data/Misc/Baneeishaque-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --differ Data/Labs/Lab_Banee/rclone/GPhotos-Banee-differ.txt --error Data/Labs/Lab_Banee/rclone/GPhotos-Banee-error.txt --missing-on-dst Data/Labs/Lab_Banee/rclone/GPhotos-Banee-missing-on-dst.txt --missing-on-src Data/Labs/Lab_Banee/rclone/GPhotos-Banee-missing-on-src.txt

rclone sync GPhotos-Banee2:media/by-day/ Data/Misc/Baneeishaque2-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --dry-run
rclone sync GPhotos-Banee2:album/ Data/Misc/Baneeishaque2-GPhotos/album/ --progress --progress-terminal-title --human-readable --dry-run
rclone sync Data/Misc/Baneeishaque2-GPhotos/album/ GPhotos-Banee2:album/ --progress --progress-terminal-title --human-readable --dry-run

echo GPhotos3 Local++
rclone sync GPhotos-Banee3:media/by-day/ Data/Misc/Baneeishaque3-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --dry-run
rclone sync GPhotos-Banee3:album/ Data/Misc/Baneeishaque3-GPhotos/album/ --progress --progress-terminal-title --human-readable --dry-run
rclone sync Data/Misc/Baneeishaque3-GPhotos/album/ GPhotos-Banee3:album/ --progress --progress-terminal-title --human-readable --dry-run
echo rclone check GPhotos-Banee3:media/by-day/ Data/Misc/Baneeishaque3-GPhotos/media/by-day/ --progress --progress-terminal-title --human-readable --differ Data/Labs/Lab_Banee/rclone/GPhotos-Banee3-differ.txt --error Data/Labs/Lab_Banee/rclone/GPhotos-Banee3-error.txt --missing-on-dst Data/Labs/Lab_Banee/rclone/GPhotos-Banee3-missing-on-dst.txt --missing-on-src Data/Labs/Lab_Banee/rclone/GPhotos-Banee3-missing-on-src.txt

rclone sync Mail-ru-Banee-Gmail: Data/Misc/Mail-ru-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run

rclone sync Mega-Banee-Gmail: Data/Misc/Mega-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Mega-Banee-Gmail-root-filter.txt --dry-run
rclone sync Data/Misc/Mega-Banee-Gmail-Drive/ Mega-Banee-Gmail: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Mega-Banee-Gmail-root-filter.txt --dry-run

rclone sync Mega-Banee2-Gmail: Data/Misc/Mega-Banee2-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Mega-Banee2-Gmail-root-filter.txt --dry-run
rclone sync Data/Misc/Mega-Banee2-Gmail-Drive/ Mega-Banee2-Gmail: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Mega-Banee2-Gmail-root-filter.txt --dry-run

rclone sync Mega-Banee3-Gmail: Data/Misc/Mega-Banee3-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Mega-Banee3-Gmail-root-filter.txt --dry-run
rclone sync Data/Misc/Mega-Banee3-Gmail-Drive/ Mega-Banee3-Gmail: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Mega-Banee3-Gmail-root-filter.txt --dry-run
rclone sync Mega-Banee4-Gmail: Data/Misc/Mega-Banee4-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Mega-Banee4-Gmail-root-filter.txt --dry-run
rclone sync Data/Misc/Mega-Banee4-Gmail-Drive/ Mega-Banee4-Gmail: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Mega-Banee4-Gmail-root-filter.txt --dry-run
rclone sync Mega-Banee5-Gmail: Data/Misc/Mega-Banee5-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Mega-Banee4-Gmail-root-filter.txt --dry-run
rclone sync Data/Misc/Mega-Banee5-Gmail-Drive/ Mega-Banee5-Gmail: --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Mega-Banee4-Gmail-root-filter.txt --dry-run
rclone sync Mega-Banee6-Gmail: Data/Misc/Mega-Banee6-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run
rclone sync Data/Misc/Mega-Banee6-Gmail-Drive/ Mega-Banee6-Gmail: --progress --progress-terminal-title --human-readable --dry-run
rclone sync Mega-Banee7-Gmail: Data/Misc/Mega-Banee7-Gmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run
rclone sync Data/Misc/Mega-Banee7-Gmail-Drive/ Mega-Banee7-Gmail: --progress --progress-terminal-title --human-readable --dry-run
rclone sync Miles-5GB:public_html Data/Misc/Miles-5GB-public_html/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Miles-5GB-public_html-filter.txt --dry-run
rclone sync Data/Misc/Miles-5GB-public_html/ Miles-5GB:public_html --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Miles-5GB-public_html-filter.txt --dry-run
echo One Drive--
rclone sync One-Drive-Banee-Hotmail: Data/Misc/One-Drive-Banee-Hotmail-Drive/ --progress --progress-terminal-title --human-readable --dry-run
rclone sync Data/Misc/One-Drive-Banee-Hotmail-Drive/ One-Drive-Banee-Hotmail: --progress --progress-terminal-title --human-readable --dry-run
rclone sync Pcloud-Banee-Gmail: Data/Misc/pCloud-Drive/ --progress --progress-terminal-title --human-readable --dry-run
rclone sync Data/Misc/pCloud-Drive/ Pcloud-Banee-Gmail: --progress --progress-terminal-title --human-readable --dry-run
rclone sync Storj-Banee-Gmail: Data/Misc/Storj-Banee-Gmail-Drive/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Storj-Banee-Gmail-root-filter.txt --dry-run
echo Wozi Local++
rclone sync Wozi-info-tech-com: Data/Misc/To-DK/Wozi-info-tech-com-root/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Wozi-info-tech-com-root-filter.txt --dry-run
echo rclone check Wozi-info-tech-com: Data/Misc/To-DK/Wozi-info-tech-com-root/ --progress --progress-terminal-title --human-readable --filter-from Data/Labs/Lab_Banee/rclone/Wozi-info-tech-com-root-filter.txt --differ Data/Labs/Lab_Banee/rclone/Wozi-info-tech-com-differ.txt --error Data/Labs/Lab_Banee/rclone/Wozi-info-tech-com-error.txt --missing-on-dst Data/Labs/Lab_Banee/rclone/Wozi-info-tech-com-missing-on-dst.txt --missing-on-src Data/Labs/Lab_Banee/rclone/Wozi-info-tech-com-missing-on-src.txt
