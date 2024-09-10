host := `uname -n`

# default works without naming it
[group('example')]
whatever:
  just --list

# goofing off
[group('example')]
cause:
  @echo haha on {{host}} running {{os()}}
  @echo "invocation_dir={{invocation_directory()}}"
  git stp

# escape from branch, back go starting point
[group('process')]
sync:
  git checkout main
  git pull

# under development
[group('process')]
pr:
  hugo
  git stp
  git pushup

# Thanks to https://apple.stackexchange.com/a/422206/210526
# remove GPS information from an image
[no-cd, group('utility')]
gps_rm image:
  exiftool -overwrite_original -gps:all= {{image}}

# from ancient html/Makefile
#favicon.ico: img/favicon.pnm
#	ppmtowinicon -output favicon.ico favicon.pnm 
