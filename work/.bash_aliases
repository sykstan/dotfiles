# port forwarding
alias port8123="ssh -N -f -L localhost:8888:localhost:8123 stan@ds-server.carsales.office"
alias port8111="ssh -N -f -L localhost:8111:localhost:8111 stan@ds-server.carsales.office"

# conda and python
# alias conda="source $HOME/AppData/Local/Continuum/miniconda3/etc/profile.d/conda.sh"

# logging into ec2
alias lec="ssh -i ~/.ssh/ds_ec2.pem ec2-user@10.224.83.186"

alias sds="ssh -i ~/.ssh/stan_carsales stan@ds-server.carsales.office"
alias dds="ssh -i ~/.ssh/dsadmin ds-admin@ds-server.carsales.office"

# local jupyter startup
alias ljn="jt -T -N -t onedork -f code -fs 11 -cellw 98% &&  jupyter notebook --port=7777"

echo ".bash_aliases run"
