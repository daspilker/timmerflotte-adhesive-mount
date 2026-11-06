#!/usr/bin/env bash
# Renders preview images (e.g. for Printables) into images/.
# Requires: openscad, xvfb-run (xvfb), imagemagick
set -euo pipefail
cd "$(dirname "$0")/.."

out=images
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$out"

bg='#f8f8f8'   # background colour of the Tomorrow colour scheme

render() { # name camera size [extra args...]
    local name=$1 camera=$2 size=$3; shift 3
    xvfb-run -a -s "-screen 0 2600x2000x24" \
        openscad -o "$tmp/$name.png" --preview --imgsize="$size" \
        --colorscheme=Tomorrow --projection=p --camera="$camera" "$@" \
        scripts/render-images.scad
}

# Trim the empty background and fit the model into a 1600x1200 (4:3) image.
fit() {
    convert "$tmp/$1.png" -trim +repage -resize 1440x1080 \
        -background "$bg" -gravity center -extent 1600x1200 "$out/$1.png"
}

render 01-overview    62,-78,62,0,3,0       2560,1920 --viewall --autocenter
render 02-pin-closeup 18,-2,10,0,22.5,3.5   1600,1200
render 03-side        0,-120,8,0,0,2        2560,1920

fit 01-overview
cp "$tmp/02-pin-closeup.png" "$out/"
fit 03-side

ls -l "$out"
