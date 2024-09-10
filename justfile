host := `uname -n`

# default
default:
  just --list

# goofing off
cause:
  @echo haha on {{host}} running {{os()}}
  @echo "invocation_dir={{invocation_directory()}}"
  git stp

# escape from branch
sync:
  git checkout main
  git pull

# under development
pr:
  hugo
  git stp
  git pushup

# Thanks to https://apple.stackexchange.com/a/422206/210526
# remove GPS information from an image
[no-cd]
gps_rm image:
  exiftool -overwrite_original -gps:all= {{image}}

# from ancient html/Makefile
#favicon.ico: img/favicon.pnm
#	ppmtowinicon -output favicon.ico favicon.pnm 
