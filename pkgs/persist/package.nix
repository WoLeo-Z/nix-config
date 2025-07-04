# Reference: https://github.com/CnTeng/nixfiles/blob/cfadd680c30fad79f7308a8347d042e8bc967ba9/pkgs/persist/package.nix

{ writeShellApplication }:
writeShellApplication {
  name = "persist";
  text = ''
    if [ $# -eq 0 ]; then
      echo "Usage: $0 <No such file or directory>"
      exit 1
    fi

    if [ ! -e "$1" ]; then
      echo "Error: $1 does not exist."
      exit 1
    fi

    SOURCE=$(realpath "$1")
    DEST="/persist$(dirname "$SOURCE")/"

    if [ ! -d "$DEST" ]; then
      mkdir -p "$DEST"
    fi   

    cp -r "$SOURCE" "$DEST"

    echo "Persist $SOURCE to $DEST"
  '';
}
