# port forwarding
alias port8123="ssh -N -f -L localhost:8888:localhost:8123 stan@ds-server.carsales.office"

# conda and python
# alias conda="source $HOME/AppData/Local/Continuum/miniconda3/etc/profile.d/conda.sh"

# logging into ec2
alias lec="ssh -i ~/.ssh/stan_ec2 ec2-user@10.241.15.241"

alias sds="ssh -i ~/.ssh/stan_carsales stan@ds-server.carsales.office"

# local jupyter startup
alias ljn="jt -T -N -t onedork -f code -fs 11 -cellw 98% &&  jupyter notebook --port=7777"
