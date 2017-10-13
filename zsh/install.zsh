#!/bin/zsh
# install

tmpf="/tmp/$$_tmpdat"
zsh="~/.zshrc"

cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cd ~/.oh-my-zsh/custom/plugins/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/
ln -s ~/Repositories/github.com/hringriin/dotfiles/repo/zsh/plugins/hringriin/ ./
cd ~/.oh-my-zsh/custom/
ln -s ~/Repositories/github.com/hringriin/dotfiles/repo/zsh/themes/ ./

sed 's/ZSH=\/home\/hringriin/'${HOME}'/g' ${zsh} > ${tmpf}
cp ${tmpf} ${zsh}

sed 's/# ZSH_THEME/ZSH_THEME/g' ${zsh} > ${tmpf}
cp ${tmpf} ${zsh}

sed 's/# CASE_SENSITIVE/CASE_SENSITIVE/g' ${zsh} > ${tmpf}
cp ${tmpf} ${zsh}

sed 's/# ENABLE_CORRECTION/ENABLE_CORRECTION/g' ${zsh} > ${tmpf}
cp ${tmpf} ${zsh}

sed 's/# COMPLETION_WAITING_DOTS/COMPLETION_WAITING_DOTS/g' ${zsh} > ${tmpf}
cp ${tmpf} ${zsh}

sed 's/# HIST_STAMPS.*/HIST_STAMPS="yyyy-mm-dd"/g' ${zsh} > ${tmpf}
cp ${tmpf} ${zsh}

sed 's/plugins=(.*)/plugins=(hringriin mosh screen zsh-syntax-highlighting)/g' ${zsh} > ${tmpf}
cp ${tmpf} ${zsh}


rm -rf ${tmpf}
unset tmpf
