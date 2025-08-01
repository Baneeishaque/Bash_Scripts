. ../installMise.bash || exit
cd /workspace || exit
if [ ! -d configurations-private ];then
    git clone https://github.com/Baneeishaque/configurations-private.git
else
    cd configurations-private || exit
    git pull
    cd ..
fi
cd Account-Ledger-Cli/bin && rm .env && rm frequencyOfAccounts.json && rm relationOfAccounts.json && mise trust --yes && mise install && ln -s /workspace/configurations-private/AccountLedger/.env .env && ln -s /workspace/configurations-private/AccountLedger/frequencyOfAccounts.json frequencyOfAccounts.json && ln -s /workspace/configurations-private/AccountLedger/relationOfAccounts.json relationOfAccounts.json
