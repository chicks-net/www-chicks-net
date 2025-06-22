# www-chicks-net justfile

# clean out references to old hugo modules
[group('Hugo')]
hugo_mod_tidy:
    hugo mod tidy

# update hugo modules
[group('Hugo')]
hugo_mod_update:
    hugo mod get -u

# run hugo from the top of the repo
[group('Hugo')]
hugo:
    #!/usr/bin/env bash
    PREV_DIR="public.prev"
    if [[ -e "$PREV_DIR" ]]; then
        echo "{{RED}}The $PREV_DIR directory exists.  Is there a bug on a previous hugo run?{{NORMAL}}"
        exit 5
    fi
    echo "{{GREEN}}no $PREV_DIR directory, so safe to rebuild with hugo...{{NORMAL}}"

    set -euxo pipefail # strict mode

    mv public public.prev

    TZ=America/Los_Angeles hugo

    git stp

    rm -rf public.prev

# run hugo server
[group('Hugo')]
server:
    #!/usr/bin/env bash
    TZ=America/Los_Angeles hugo server
    just hugo # cleanup after server!

# open browser to hugo site
[group('Hugo')]
see-server:
    open http://localhost:1313/
    just server
