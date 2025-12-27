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

# check for GPS data in an image or all images in repo
[group('Compliance')]
gps_check image="":
    #!/usr/bin/env bash
    set -euo pipefail # strict mode

    # if image parameter is provided, check just that file
    if [[ -n "{{ image }}" ]]; then
        if [[ ! -f "{{ image }}" ]]; then
            echo "{{RED}}Error: File '{{ image }}' not found{{NORMAL}}"
            exit 1
        fi
        echo "{{BLUE}}Checking {{ image }} for GPS data...{{NORMAL}}"
        gps_data=$(exiftool -gps:all "{{ image }}" 2>/dev/null | grep "GPS" || true)
        if [[ -n "$gps_data" ]]; then
            echo "{{RED}}⚠️  GPS data found:{{NORMAL}}"
            echo "$gps_data"
            echo ""
            echo "{{YELLOW}}Run 'just gps_rm {{ image }}' to remove GPS data{{NORMAL}}"
            exit 1
        else
            echo "{{GREEN}}✓ No GPS data found{{NORMAL}}"
            exit 0
        fi
    fi

    # otherwise check all images in the repo
    echo "{{BLUE}}Checking all images in repository for GPS data...{{NORMAL}}"
    echo ""

    has_gps=0
    checked=0

    # find all image files and process them
    while IFS= read -r -d '' img; do
        gps_data=$(exiftool -gps:all "$img" 2>/dev/null | grep "GPS" || true)
        if [[ -n "$gps_data" ]]; then
            echo "{{RED}}⚠️  GPS data found in $img:{{NORMAL}}"
            echo "$gps_data"
            echo ""
            has_gps=1
        fi
        ((checked++))
    done < <(find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) ! -path "*/public/*" ! -path "*/.git/*" ! -path "*/node_modules/*" -print0)

    if [[ $checked -eq 0 ]]; then
        echo "{{YELLOW}}No images found in repository{{NORMAL}}"
        exit 0
    fi

    echo "{{MAGENTA}}Checked $checked images{{NORMAL}}"
    if [[ $has_gps -eq 0 ]]; then
        echo "{{GREEN}}✓ No GPS data found in any images{{NORMAL}}"
        exit 0
    else
        echo ""
        echo "{{RED}}ERROR: GPS data found in one or more images!{{NORMAL}}"
        echo "{{YELLOW}}Run 'just gps_rm <image>' to remove GPS metadata{{NORMAL}}"
        exit 1
    fi

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

# find Mac Finder duplicate files (with space and number before extension)
[group('Utility')]
finder_dupes remove="":
    #!/usr/bin/env bash
    set -euo pipefail # strict mode

    found=0

    # Find files matching pattern " N.ext" where N is a number
    # This matches Mac Finder's duplicate naming: "file 2.txt", "image 3.jpg", etc.
    while IFS= read -r -d '' file; do
        basename=$(basename "$file")
        # Check if filename matches pattern: ends with " N.extension"
        if [[ "$basename" =~ \ [0-9]+\.[^.]+$ ]]; then
            echo "{{YELLOW}}Found: $file{{NORMAL}}"
            ((found++))

            if [[ "{{ remove }}" == "yes" ]] || [[ "{{ remove }}" == "true" ]]; then
                echo "{{RED}}  Removing...{{NORMAL}}"
                rm "$file"
            fi
        fi
    done < <(find . -type f ! -path "*/public/*" ! -path "*/.git/*" ! -path "*/node_modules/*" ! -path "*/public.prev/*" -print0)

    if [[ $found -eq 0 ]]; then
        echo "{{GREEN}}✓ No Finder duplicate files found{{NORMAL}}"
    else
        echo ""
        echo "{{MAGENTA}}Found $found Finder duplicate file(s){{NORMAL}}"

        if [[ "{{ remove }}" != "yes" ]] && [[ "{{ remove }}" != "true" ]]; then
            echo "{{BLUE}}Run 'just finder_dupes yes' to remove them{{NORMAL}}"
        else
            echo "{{GREEN}}✓ Removed $found file(s){{NORMAL}}"
        fi
    fi
