# www-chicks-net justfile

# some useful variables
host := `uname -n`

# display date with reversed background
[group('example')]
color-test:
    #!/usr/bin/env bash
    NOW=$(just utcdate)
    echo "NOW={{ INVERT }}$NOW{{ BG_WHITE }}"

# goofing off
[group('example')]
cause:
    @echo haha on {{ host }} running {{ os() }}
    @echo "invocation_dir={{ invocation_directory() }}"
    git stp
