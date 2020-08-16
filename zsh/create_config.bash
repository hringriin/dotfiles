#!/bin/bash
# create_config for <<zsh>>

prgname="zsh"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

tmpf="/tmp/$$_tmpdat"
zsh="${HOME}/.zshrc"

main()
{
    cd ~
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    cd ~/.oh-my-zsh/custom/plugins/
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
    ln -s ~/Repositories/github.com/hringriin/dotfiles/repo/zsh/plugins/hringriin/ ./
    cd ~/.oh-my-zsh/custom/themes/
    ln -s ~/Repositories/github.com/hringriin/dotfiles/repo/zsh/themes/hringriin.zsh-theme ./

    echo "setting theme"
    sleep 1
    cat ${zsh} | sed -e 's/ZSH_THEME=".*"/ZSH_THEME="hringriin"/g' > ${tmpf}
    cp ${tmpf} ${zsh}
    sleep 1

    echo "setting hyphen insensitive"
    sleep 1
    cat ${zsh} | sed -e 's/# HYPHEN_INSENSITIVE/HYPHEN_INSENSITIVE/g' > ${tmpf}
    cp ${tmpf} ${zsh}
    sleep 1

    echo "enable autocorrection"
    sleep 1
    cat ${zsh} | sed -e 's/# ENABLE_CORRECTION/ENABLE_CORRECTION/g' > ${tmpf}
    cp ${tmpf} ${zsh}
    sleep 1

    echo "enable completing dots"
    sleep 1
    cat ${zsh} | sed -e 's/# COMPLETION_WAITING_DOTS/COMPLETION_WAITING_DOTS/g' > ${tmpf}
    cp ${tmpf} ${zsh}
    sleep 1

    echo "setting history timestamp format"
    sleep 1
    cat ${zsh} | sed -e 's/# HIST_STAMPS.*/HIST_STAMPS="yyyy-mm-dd"/g' > ${tmpf}
    cp ${tmpf} ${zsh}
    sleep 1

    echo "setting plugin list"
    sleep 1
    echo "You need to edit line 62 of .zshrc manually!"
    sleep 1
    cat ${zsh} | sed -e 's/plugins=(.*)/plugins=(colored-man-pages hringriin mosh screen zsh-syntax-highlighting)/g' > ${tmpf}
    cp ${tmpf} ${zsh}
    sleep 1


    rm -rf ${tmpf}
    unset tmpf
}

main
exit 0
