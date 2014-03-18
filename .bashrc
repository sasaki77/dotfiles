export PATH=/usr/local/bin:${PATH}:
export PATH=/Applications/UpTex.app/teTex/bin:$PATH
export PATH=/opt/local/bin:/opt/local/sbin/:$PATH
export PATH=/Applications/android-sdk-mac/sdk/tools:$PATH
export PATH=/Applications/android-sdk-mac/sdk/platform-tools:$PATH
export PATH=/Applications/PictPrinter.app/Contents/MacOS:$PATH

export MANPATH=/opt/local/man:$MANPATH

#alias emacs='/Applications/Emacs24.2.app/Contents/MacOS/Emacs'
alias emacs="open -a /Applications/Emacs24.2.app"
alias emacsnw='emacs -nw'
alias ls='ls -G -a'
alias ll='ls -l -a'
alias javac='javac -J-Dfile.encoding=UTF-8'

export ANT_OPTS=-Dfile.encoding=UTF8

#finkの設定
export TERM=xterm-color
. /sw/bin/init.sh

#cern libの設定
export CERN=/cern
export CERN_ROOT=/cern/
export CERNLIB=$CERN/pro/lib
export CERNBIN=$CERN/pro/bin
export PATH=$PATH:$CERNBIN
