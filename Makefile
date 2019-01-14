# determine architecture
ARC=Linux
ifeq ($(OS),Windows_NT)
  ARC=Windows
else
  UNAME_S := $(shell uname -s)
  ifeq ($(UNAME_S),Darwin)
    ARC=OSX
  endif
endif

EXCLUDE=README.md Makefile fonts pygments rover.patch youtube-dl
ifeq ($(ARC),Windows)
  EXCLUDE+=asoundrc xsession root rootrc
else
  EXCLUDE+=minttyrc startxwinrc
endif
TARGETS=$(filter-out $(EXCLUDE), $(wildcard *))
TARGETS+=bin terminfo nano ytdl

all:$(TARGETS)

asoundrc:
	n=`lspci|grep audio|wc -l`; if [ $$n != "1" ]; then ln -sf $(PWD)/$@ ~/.$@; fi

a2psrc:
	mkdir -p ~/.a2ps
	ln -sf $(PWD)/$@ ~/.a2ps/$@

bashrc:
	ln -sf $(PWD)/$@ ~/.$@

bin:
	mkdir -p ~/$@
	for each in `ls -1 $@`; do ln -sf $(PWD)/$@/$$each ~/$@/; done

ctags:
	ln -sf $(PWD)/$@ ~/.$@

dircolors:
	ln -sf $(PWD)/$@ ~/.$@

fonts:
	mkdir -p ~/github/
	if [ -d ~/github/powerline-fonts ]; then \
	  cd ~/github/powerline-fonts && git pull && install.sh; \
	else \
	  cd ~/github; \
	  git clone https://github.com/powerline/fonts.git powerline-fonts; \
	fi

gitconfig:
	ln -sf $(PWD)/$@ ~/.$@

hvrc:
	ln -sf $(PWD)/$@ ~/.$@

latexmkrc:
	ln -sf $(PWD)/$@ ~/.$@

lynx:
	mkdir -p ~/.$@
	ln -sf $(PWD)/$@/lynx.cfg ~/.$@/lynx.cfg
	ln -sf $(PWD)/$@/lynx.lss ~/.$@/lynx.lss
	ln -sf $(PWD)/$@/jump.html ~/.$@/jump.html

mime.types:
	ln -sf $(PWD)/$@ ~/.$@

minttyrc:
	ln -sf $(PWD)/$@ ~/.$@

mutt:
	mkdir -p ~/.$@
	mkdir -p ~/.$@/cache
	ln -sf $(PWD)/$@/color ~/.$@/color
	ln -sf $(PWD)/$@/sign ~/.$@/sign
	ln -sf $(PWD)/$@/mailcap ~/.$@/mailcap
	ln -sf $(PWD)/$@/muttrc ~/.$@/muttrc

nano:
	if (( `nano --version | head -1 | awk -F. '{print $$2}'` -gt 6 )); then \
	  ln -sf $(PWD)/$@7rc ~/.$@rc; \
	else \
	  ln -sf $(PWD)/$@rc ~/.$@rc; \
	fi
	if [ -d ~/github/$@rc ]; then \
	  cd ~/github/$@rc && git pull; \
	else \
	  cd ~/github; \
	  git clone https://github.com/jintonic/$@rc.git; \
	fi

profile:
	ln -sf $(PWD)/$@ ~/.$@

pygments:
	curl 'https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py' | python
	rm -f setuptools*
	easy_install Pygments
rootrc:
	ln -sf $(PWD)/$@ ~/.$@

root:
	mkdir -p ~/.$@
	ln -sf $(PWD)/$@/logon.C ~/.$@/logon.C

# cd /path/to/rover && git diff > rover.patch
# cd /path/to/rover && git apply rover.patch
rover:
	mkdir -p ~/github/
	if [ -d ~/github/$@ ]; then \
	  cd ~/github/$@ && git checkout -- '*' && git pull; \
	else \
	  cd ~/github && git clone https://github.com/lecram/$@.git; \
	fi
	cd ~/github/$@ && git apply ../dots/$@.patch
	if [ "$(ARC)" = "OSX" ]; then \
	  cd ~/github/$@ && LDFLAGS=-L/usr/local/Cellar/ncurses/6.0_4/lib CFLAGS=-I/usr/local/Cellar/ncurses/6.0_4/include make install; \
	else \
	  cd ~/github/$@ && make install; \
	fi

screenrc:
	ln -sf $(PWD)/$@ ~/.$@
	mkdir ~/.screen && chmod 700 ~/.screen
	if [ "$(ARC)" = "Windows" ]; then rm -f /var/run/utmp; fi

scrc:
	ln -sf $(PWD)/$@ ~/.$@

startxwinrc:
	ln -sf $(PWD)/$@ ~/.$@

terminfo:
	infocmp | sed 's/kbs=^H/kbs=\\177/' > /tmp/ti.src
	tic /tmp/ti.src
	rm -f /tmp/ti.src

w3m:
	mkdir -p ~/.$@
	ln -sf $(PWD)/$@/cgi-bin ~/.$@
	ln -sf $(PWD)/$@/urimethodmap ~/.$@/urimethodmap
	ln -sf $(PWD)/$@/bookmark.html ~/.$@/bookmark.html
	ln -sf $(PWD)/$@/config ~/.$@/config
	ln -sf $(PWD)/$@/mailcap ~/.$@/mailcap
	ln -sf $(PWD)/$@/keymap ~/.$@/keymap

ytdl:
	mkdir -p ~/.config/youtube-dl
	ln -sf $(PWD)/youtube-dl.conf ~/.config/youtube-dl/config

# https://wiki.vifm.info/index.php?title=Obtaining_Vifm
vifm:
	mkdir -p ~/.$@
	ln -sf $(PWD)/$@/$@rc ~/.$@/$@rc
	mkdir -p ~/.$@/colors
	ln -sf $(PWD)/$@/colors/solarized.$@ ~/.$@/colors/

vim:
	ln -sf $(PWD)/$@rc ~/.$@rc
	mkdir -p ~/.$@
	mkdir -p ~/.$@/dein/repos/github.com/Shougo/dein.vim
	cd ~/.$@/dein/repos/github.com/Shougo/dein.vim; \
	  if [ ! -f README.md ]; then \
	  git clone https://github.com/Shougo/dein.vim.git .; \
	  vim -X +"call dein#install()" +q; \
	  else git pull;\
	  vim -X +"call dein#update()" +q; \
	  fi
	ln -sf $(PWD)/$@/after ~/.$@/
	mkdir -p ~/.$@/dic
	ln -sf $(PWD)/$@/dic/* ~/.$@/dic
	mkdir -p ~/.$@/spell
	ln -sf $(PWD)/$@/spell/en.utf-8.add ~/.$@/spell/en.utf-8.add
	vim -X ~/.$@/spell/en.utf-8.add +"mkspell! %" +q

xfig:
	if [ ! -d ~/.xfig ]; then \
	  wget https://gsalam.web.cern.ch/gsalam/repository/software/Feynman_Diagrams.tgz; \
	  tar xfvz Feynman_Diagrams.tgz; rm -f Feynman_Diagrams.tgz; \
	  mv Feynman_Diagrams ~/.xfig; fi

xpdfrc:
	ln -sf $(PWD)/$@ ~/.$@

xsession:
	ln -sf $(PWD)/$@ ~/.$@

Xdefaults:
	ln -sf $(PWD)/$@ ~/.$@

info:
	@echo $(TARGETS)

.PHONY:all clean info $(TARGETS)
