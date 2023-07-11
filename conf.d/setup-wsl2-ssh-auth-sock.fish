if ! string length -q $WSL_DISTRO_NAME
    exit 0
end

if ! type -q socat
    echo "socat is not installed."
    exit 0
end

set -l NPIPERELAY /mnt/c/npiperelay/npiperelay.exe
set -l NPIPERELAY_DOWNLOAD_URL https://github.com/jstarks/npiperelay/releases/download/v0.1.0
set -l NPIPERELAY_ZIP npiperelay_windows_amd64.zip

if ! test -f $NPIPERELAY
    if ! type -q unzip
        echo "unzip is not installed."
        exit 0
    end
    set TEMPDIR (mktemp -d)
    curl -s -o $TEMPDIR/$NPIPERELAY_ZIP -L $NPIPERELAY_DOWNLOAD_URL/$NPIPERELAY_ZIP
    mkdir -p (dirname $NPIPERELAY)
    unzip -q $TEMPDIR/$NPIPERELAY_ZIP -d (dirname $NPIPERELAY)
    rm -rf $TEMPDIR
end

set -x SSH_AUTH_SOCK /mnt/wsl/ssh-auth.sock
if ! ss -a | grep -q $SSH_AUTH_SOCK
    rm -f $SSH_AUTH_SOCK
    setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$NPIPERELAY -ei -s //./pipe/openssh-ssh-agent",nofork >/dev/null 2>&1 &
end
