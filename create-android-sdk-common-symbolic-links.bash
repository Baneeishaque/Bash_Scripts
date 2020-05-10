# ln -fs /media/srf/2678DE3378DE020B/Programs/Android_SDK_Common/docs docs
# ln -fs /media/srf/2678DE3378DE020B/Programs/Android_SDK_Common/extras extras
# ln -fs /media/srf/2678DE3378DE020B/Programs/Android_SDK_Common/licenses licenses
# ln -fs /media/srf/2678DE3378DE020B/Programs/Android_SDK_Common/patcher patcher
# ln -fs /media/srf/2678DE3378DE020B/Programs/Android_SDK_Common/platforms platforms
# ln -fs /media/srf/2678DE3378DE020B/Programs/Android_SDK_Common/sources sources
# ln -fs /media/srf/2678DE3378DE020B/Programs/Android_SDK_Common/system-images system-images

# TODO : Use commandline arguments (for android_sdk_common_folder & android_sdk_linux_folder) with proper validation
# TODO : Ask for commandline inputs if there are no commandline arguments
# TODO : Check for existence of directories
# TODO : Check for permission on directories for symbolic link creation

android_sdk_common_folder=/media/srf/2678DE3378DE020B/Programs/Android_SDK_Common
android_sdk_linux_folder=/opt/programs/Android_SDK_Linux

# echo ln -fs $android_sdk_common_folder/docs $android_sdk_linux_folder/docs
# echo ln -fs $android_sdk_common_folder/extras $android_sdk_linux_folder/extras
# echo ln -fs $android_sdk_common_folder/licenses $android_sdk_linux_folder/licenses
# echo ln -fs $android_sdk_common_folder/patcher $android_sdk_linux_folder/patcher
# echo ln -fs $android_sdk_common_folder/platforms $android_sdk_linux_folder/platforms
# echo ln -fs $android_sdk_common_folder/sources $android_sdk_linux_folder/sources
# echo ln -fs $android_sdk_common_folder/system-images $android_sdk_linux_folder/system-images

ln -fs $android_sdk_common_folder/docs $android_sdk_linux_folder/docs
ln -fs $android_sdk_common_folder/extras $android_sdk_linux_folder/extras
ln -fs $android_sdk_common_folder/licenses $android_sdk_linux_folder/licenses
ln -fs $android_sdk_common_folder/patcher $android_sdk_linux_folder/patcher
ln -fs $android_sdk_common_folder/platforms $android_sdk_linux_folder/platforms
ln -fs $android_sdk_common_folder/sources $android_sdk_linux_folder/sources
ln -fs $android_sdk_common_folder/system-images $android_sdk_linux_folder/system-images
