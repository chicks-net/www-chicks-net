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

# from ancient html/Makefile
#favicon.ico: img/favicon.pnm
#	ppmtowinicon -output favicon.ico favicon.pnm 
