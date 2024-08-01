host := `uname -n`

[doc('goofing off')]
cause:
  @echo haha on {{host}} running {{os()}}
  @echo "invocation_dir={{invocation_directory()}}"
  git stp

[doc('escape from branch')]
sync:
  git checkout main
  git pull

pr:
  hugo
  git stp
  git pushup

# Thanks to https://apple.stackexchange.com/a/422206/210526
[doc('remove GPS information from an image'), no-cd]
gps_rm image:
  exiftool -overwrite_original -gps:all= {{image}}

# from ancient html/Makefile
#favicon.ico: img/favicon.pnm
#	ppmtowinicon -output favicon.ico favicon.pnm 
