# This script mounts VHDX files in WSL2 at startup.
# It reads the configuration from ~/.config/wsl/mount_vhdx_config.
#
# The configuration file should contain lines in the format:
# <vhdx_path> <mount_point>
#
# Example:
# C:\Users\habu\Documents\disk1.vhdx mount-disk1
# C:\Users\habu\Documents\disk2.vhdx mount-disk2

set mount_vhdx_config "$HOME/.config/wsl/mount_vhdx_config"

if ! test -e $mount_vhdx_config
    return
end

for line in (cat $mount_vhdx_config | grep -v '^#' | grep -v '^$')
    set vhdx_path (echo $line | awk '{print $1}')
    set mount_point (echo $line | awk '{print $2}')

    set mount_path "/mnt/wsl/$mount_point"

    # Delete the directory if /mnt/wsl/$mount_point is empty
    if test -d $mount_path
        set files (ls -A $mount_path)
        if test -z "$files"
            sudo rmdir $mount_path
        end
    end

    # Mount the VHDX file if it is not already mounted
    if ! test -d $mount_path
        wsl.exe --mount "$vhdx_path" --vhd --name $mount_point
    end
end
