#!/bin/zsh
# install

tmpf="/tmp/$$_tmpdat"
zsh="${HOME}/.zshrc"

cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cd ~/.oh-my-zsh/custom/plugins/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
ln -s ~/Repositories/github.com/hringriin/dotfiles/repo/zsh/plugins/hringriin/ ./
cd ~/.oh-my-zsh/themes/
ln -s ~/Repositories/github.com/hringriin/dotfiles/repo/zsh/themes/hringriin.zsh-theme ./

echo "setting theme"
cat ${zsh} | sed -e 's/ZSH_THEME=".*"/ZSH_THEME="hringriin"/g' > ${tmpf}
cp ${tmpf} ${zsh}

echo "setting hyphen insensitive"
cat ${zsh} | sed -e 's/# HYPHEN_INSENSITIVE/HYPHEN_INSENSITIVE/g' > ${tmpf}
cp ${tmpf} ${zsh}

echo "enable autocorrection"
cat ${zsh} | sed -e 's/# ENABLE_CORRECTION/ENABLE_CORRECTION/g' > ${tmpf}
cp ${tmpf} ${zsh}

echo "enable completing dots"
cat ${zsh} | sed -e 's/# COMPLETION_WAITING_DOTS/COMPLETION_WAITING_DOTS/g' > ${tmpf}
cp ${tmpf} ${zsh}

echo "setting history timestamp format"
cat ${zsh} | sed -e 's/# HIST_STAMPS.*/HIST_STAMPS="yyyy-mm-dd"/g' > ${tmpf}
cp ${tmpf} ${zsh}

echo "setting plugin list"
echo "You need to edit line 62 of .zshrc manually!"
cat ${zsh} | sed -e 's/plugins=(.*)/plugins=(colored-man-pages hringriin mosh screen zsh-syntax-highlighting)/g' > ${tmpf}
cp ${tmpf} ${zsh}


rm -rf ${tmpf}
unset tmpf
