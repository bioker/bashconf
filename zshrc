rm ~/.zcompdump*

export ZSH="/home/wls/.oh-my-zsh"
export SDKMAN_DIR=/home/wls/.sdkman
export PATH=$PATH:/home/wls/Programs/gradle/bin
export PATH=$PATH:/home/wls/Programs/groovy/bin
export PATH=$PATH:/usr/lib/jvm/jdk-12.0.2/bin
export PATH=$PATH:/home/wls/Programs/chromedriver
export PATH=$PATH:/home/wls/Programs/evans
export PATH=$PATH:/home/wls/Programs/kafka/bin
export PATH=$PATH:/home/wls/.local/bin
export JAVA_HOME=/usr/lib/jvm/jdk-12.0.2
export GROOVY_HOME=/home/wls/Programs/groovy
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

ZSH_THEME="agnoster"

plugins=(vi-mode z git tmux zsh-syntax-highlighting zsh-autosuggestions
  docker docker-compose kubectl minikube python pip colorize fzf
  mongodb zsh-completions gcloud helm kafka-zsh-completions zsh-abbr npm node)

source $ZSH/oh-my-zsh.sh

autoload -U +X bashcompinit && bashcompinit

[[ -s "/home/wls/.jfrog/jfrog_zsh_completion" ]] && source "/home/wls/.jfrog/jfrog_zsh_completion"
[[ -s "/home/wls/.configure_ansible_completion.sh" ]] && source "/home/wls/.configure_ansible_completion.sh"
[[ -s "/home/wls/.sdkman/bin/sdkman-init.sh" ]] && source "/home/wls/.sdkman/bin/sdkman-init.sh"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "/home/wls/Crypto/Resources/conf/zshrc" ]] && source "/home/wls/Crypto/Resources/conf/zshrc"

compdef _VBoxManage vm
compdef _VBoxHeadless vmh
complete -o nospace -C /usr/bin/vault vault
complete -o nospace -C /usr/bin/terraform terraform

alias e='vim ~/.zshrc'
alias s='source ~/.zshrc'
alias k='kubectl'
alias d='sudo docker'
alias dps='sudo docker ps'
alias dip="sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'"
alias dex="sudo docker exec -it"
alias dl="sudo docker logs"
alias ds='sudo docker stop'
alias dsa='sudo docker stop $(sudo docker ps -qa)'
alias jc='jupyter console'
alias vm='VBoxManage'
alias vmh='VBoxHeadless'
alias gb='./gradlew clean build --parallel'
alias gbxt='./gradlew clean build -x test --parallel'
alias gi='./gradlew buildImage --parallel'
alias gt='./gradlew test --parallel'
alias gr='./gradlew release -Prelease.useAutomaticVersion=true'
alias gtasks='./gradlew tasks --all -q > ./.gradle/.gradle_tasks' # caches current tasks of the project
abbr -S -g --force --quiet gtask='`cat ./.gradle/.gradle_tasks | fzf | cut -d " " -f1`' # runs the task that you choose in fzf
abbr -S -g --force --quiet fprb='ffprobe -hide_banner'
abbr -S -g --force --quiet kdev='kubectl -n develop'
abbr -S -g --force --quiet ktest='kubectl -n test'
abbr -S -g --force --quiet kdis='kubectl -n discovery'
abbr -S -g --force --quiet kair='kubectl -n airflow'
abbr -S -g --force --quiet kaut='kubectl -n autotests'
abbr -S -g --force --quiet ap='ansible-playbook'
abbr -S -g --force --quiet k='kubectl'
abbr -S -g --force --quiet ave='ansible-vault encrypt'
abbr -S -g --force --quiet avd='ansible-vault decrypt'
abbr -S -g --force --quiet ksc='kubectl config use-context'
abbr -S -g --force --quiet kgc='kubectl config get-contexts'
alias gajava='git add \*.java'
alias gasql='git add \*.sql'
alias gaproto='git add \*.proto'
alias gaprops='git add \*.properties'
alias gpcb='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gccb='git rev-parse --abbrev-ref HEAD | xclip -selection c'
alias gdev='git checkout develop'
alias gicc='git checkout -- .'
alias gic='git checkout --'
alias gis='git status'
alias gipl='git pull'
alias giph='git push'
alias gidh='git diff HEAD'
alias gicb="git branch -a | fzf | tr -d '[:space:]' | tr -d '*' | xargs git checkout"
alias gicdf="echo \"clean all non-versioned files?\" && [[ 'yes' == \"\$(read temp; echo \$temp)\" ]] && git clean -df"
alias now='date +%s%3N'
alias jmx='java -jar /home/wls/Programs/jmxterm/jmxterm.jar'
alias tf='terraform'
alias passgen='cat /dev/urandom | head -c24 | md5sum | cut -d " " -f1 | tr -d $"\n"'

function optimizevideo {
    in_file_arg=${in_file:-"video.mp4"}
    out_file_arg=${out_file:-"optimized-video.mp4"}
    resoultion_arg=${res:-"1080x720"}
    frate_arg=${rate:-"30"}
    brate_arg=${bitrate:-"3500K"}
    ffmpeg -i $in_file_arg -s $resoultion_arg -r $frate_arg -b:v $brate_arg $out_file_arg
}

function agsed {
    ag -l $1 | xargs sed -i -e "s/$1/$2/g"
}

function genkey {
    openssl genrsa -out ${key_file:-"some.key"} ${key_size:-"4096"}
}

function gencert {
    key_file_arg=${key_file:-"some.key"}
    cert_file_arg=${cert_file:-"some.crt"}
    subj_arg=${subj:-"/C=EE/ST=Harju/L=Tallinn/O=Viktor Vlasov/OU=Viktor Vlasov/CN=localhost"}
    openssl req -new -x509 -key $key_file_arg -out $cert_file_arg -subj $subj_arg
}

function gencsr {
    key_arg=${key_file:-"some.key"}
    config_arg=${config_file:-"some.config"}
    csr_arg=${csr_file:-"some.csr"}
    openssl req -new -out $csr_arg -key $key_arg -config $config_arg
}

function gensigncert {
    csr_arg=${csr_file:-"cert-request.csr"}
    ca_cert_arg=${ca_cert_file:-"ca.crt"}
    ca_key_arg=${ca_key_file:-"ca.key"}
    cert_arg=${cert_file:-"some.crt"}
    openssl x509 -req -in $csr_arg -CA $ca_cert_arg -CAkey $ca_key_arg -CAcreateserial -out $cert_arg
}

function copy2p12 {
    key_file_arg=${key_file:-"some.key"}
    cert_file_arg=${cert_file:-"some.crt"}
    p12_file_arg=${p12_file:-"some.p12"}
    openssl pkcs12 -export -out $p12_file_arg -inkey $key_file_arg -in $cert_file_arg
}

function gencakey {
    key_file=ca.key genkey
}

function genserkey {
    key_file=server.key genkey
}

function genclikey {
    key_file=client.key genkey
}

function gencacert {
    key_file=ca.key cert_file=ca.crt gencert
}

function gensercsr {
    key_file=server.key config_file=server-csr.config csr_file=server.csr gencsr
}

function genclicsr {
    key_file=client.key config_file=client-csr.config csr_file=client.csr gencsr
}

function gensercrt {
    csr_file=server.csr ca_cert_file=ca.crt ca_key_file=ca.key cert_file=server.crt gensigncert
}

function genclicrt {
    csr_file=client.csr ca_cert_file=ca.crt ca_key_file=ca.key cert_file=client.crt gensigncert
}

function prepare_ssl_files {
    gencakey
    genserkey
    genclikey
    gencacert
    gensercsr
    genclicsr
    gensercrt
    genclicrt
}

function jks2p12 {
    keytool -importkeystore -srckeystore $1 -destkeystore $2 -deststoretype PKCS12
}

function get_p12_cert {
    openssl pkcs12 -in $1 -nokeys
}

function get_p12_key {
    openssl pkcs12 -in $1 -nocerts -nodes
}
