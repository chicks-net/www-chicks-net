# utility justfile

# extract hashtags from article
[group('Utility')]
hashtags filename:
    #!/usr/bin/env bash
    set -euo pipefail # strict mode
    tomlfile=$(mktemp /tmp/justfile.XXXXXX)
    hashtagfile=$(mktemp /tmp/justfile.XXXXXX)
    #echo $tomlfile
    grep -e '^\(tags\|keywords\)' "{{ filename }}" > "$tomlfile"
    #cat $tomlfile

    set +e # one of the tomls could fail
    toml get -r "$tomlfile" 'tags' | sed -e 's/]$//' -e 's/^\[//' -e 's/["]//g' -e 's/,/\n/g' | sed -e 's/^/#/g' > "$hashtagfile"
    toml get -r "$tomlfile" 'keywords' | sed -e 's/]$//' -e 's/^\[//' -e 's/["]//g' -e 's/,/\n/g' | sed -e 's/^/#/g' >> "$hashtagfile"
    set -e # back to strict

    echo "{{BLUE}}hashtags for {{ filename }}:{{NORMAL}}"
    tr '\n' ' ' < "$hashtagfile" | sed -e 's/ $/\n/'

    rm "$tomlfile" "$hashtagfile"

# remove GPS information from an image
[group('Utility')]
[no-cd]
gps_rm image:
    exiftool -overwrite_original -gps:all= {{ image }}

# TODO: convert into just, but we didn't need it for the last favicon generated
# from ancient html/Makefile
#favicon.ico: img/favicon.pnm
#	ppmtowinicon -output favicon.ico favicon.pnm

# print UTC date/time
[group('Utility')]
[no-cd]
@utcdatetime:
    TZ=UTC date

# test network speed
[group('Utility')]
[no-cd]
[macos]
speedtest:
	networkQuality
