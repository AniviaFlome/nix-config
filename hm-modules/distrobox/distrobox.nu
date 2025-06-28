#!/usr/bin/env nu

def box-exists [box: string]: nothing -> bool {
    distrobox list
    | split row "\n"
    | each { $in | split row "|" | str trim }
    | drop nth 0
    | each { $in | get 1 }
    | where { $in == $box }
    | length
    | do { $in == 1 }
}

def main [
    name: string # arbitrary name used to identify the box
    image: string # docker image to use
    ...exec: string
    --home (-h): string
    --pkgs (-p): string = "git"
    --init (-i): string = "true"
]: nothing -> nothing {
    let dir = $home | default $"($env.HOME)/.local/share/distrobox/($name)"
#     let script_dir = ($env.FILE_PWD | path dirname | path join 'scripts')
#     let config_dir = ($env.FILE_PWD | path join 'config')

    if not (box-exists $name) {
        (distrobox create
            --pull
            --yes
            --name $name
#             --home $dir
            --image $image
            --init-hooks $init
            --additional-packages $pkgs
        )
    }

    if ($exec | length) > 0 {
        distrobox enter $name -- ...$exec
    } else {
        distrobox enter $name -- bash
    }
}
