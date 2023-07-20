#!/bin/sh

export HOME_1=$HOME/.simapp-1
export HOME_2=$HOME/.simapp-2
export HOME_3=$HOME/.simapp-3

export GENESIS_1=$HOME_1/config/genesis.json
export GENESIS_2=$HOME_2/config/genesis.json
export GENESIS_3=$HOME_3/config/genesis.json

export GENTX_1=$HOME_1/config/gentx
export GENTX_2=$HOME_2/config/gentx
export GENTX_3=$HOME_3/config/gentx

export CONFIG_1=$HOME_1/config/config.toml
export CONFIG_2=$HOME_2/config/config.toml
export CONFIG_3=$HOME_3/config/config.toml

if [ -d "$(dirname "$GENESIS_1")" ]; then
  echo "Validators already initialized. Exiting."
  exit 0
fi

relictumd keys add validator-1 --keyring-backend=test --home="$HOME_1"
relictumd keys add validator-2 --keyring-backend=test --home="$HOME_2"
relictumd keys add validator-3 --keyring-backend=test --home="$HOME_3"

relictumd init --chain-id relictum --default-denom GTN validator-1 --home="$HOME_1"
relictumd init --chain-id relictum --default-denom GTN validator-2 --home="$HOME_2"
relictumd init --chain-id relictum --default-denom GTN validator-3 --home="$HOME_3"

export VAL_1=$(relictumd tendermint show-node-id --home="$HOME_1")
export VAL_2=$(relictumd tendermint show-node-id --home="$HOME_2")
export VAL_3=$(relictumd tendermint show-node-id --home="$HOME_3")

relictumd tendermint show-node-id --home="$HOME_1"
relictumd tendermint show-node-id --home="$HOME_2"
relictumd tendermint show-node-id --home="$HOME_3"

rm -rf $GENESIS_2
rm -rf $GENESIS_3
rm -rf $GENTX_2
rm -rf $GENTX_3
ln -s $GENTX_1 $GENTX_2
ln -s $GENTX_1 $GENTX_3
ln -s $GENESIS_1 $GENESIS_2
ln -s $GENESIS_1 $GENESIS_3

relictumd genesis add-genesis-account validator-1 500000000000000000GTN --keyring-backend=test --home="$HOME_1"
relictumd genesis gentx validator-1 --ip "validator-1" --moniker "validator-1" 500000000000000000GTN --chain-id relictum --keyring-backend=test --home="$HOME_1"

relictumd genesis add-genesis-account validator-2 500000000000000000GTN --keyring-backend=test --home="$HOME_2"
relictumd genesis gentx validator-2 --ip "validator-2" --moniker "validator-2" 500000000000000000GTN --chain-id relictum --keyring-backend=test --home="$HOME_2"

relictumd genesis add-genesis-account validator-3 500000000000000000GTN --keyring-backend=test --home="$HOME_3"
relictumd genesis gentx validator-3 --ip "validator-3" --moniker "validator-3" 500000000000000000GTN --chain-id relictum --keyring-backend=test --home="$HOME_3"
#relictumd genesis collect-gentxs --home="$HOME_3"

relictumd genesis collect-gentxs --home="$HOME_1"
relictumd genesis collect-gentxs --home="$HOME_2"
relictumd genesis collect-gentxs --home="$HOME_3"

jq '.app_state.mint.minter.inflation = "0.0"' "$GENESIS_1" > temp.json && mv temp.json "$GENESIS_1"
jq '.app_state.mint.params.inflation_rate_change = "0.0"' "$GENESIS_1" > temp.json && mv temp.json "$GENESIS_1"
jq '.app_state.mint.params.inflation_min = "0.0"' "$GENESIS_1" > temp.json && mv temp.json "$GENESIS_1"
jq '.app_state.mint.params.inflation_max = "0.0"' "$GENESIS_1" > temp.json && mv temp.json "$GENESIS_1"

relictumd genesis validate-genesis --home="$HOME_1"

rm -rf $GENESIS_2
rm -rf $GENESIS_3
cp $GENESIS_1 $GENESIS_2
cp $GENESIS_1 $GENESIS_3

sed -i "s/laddr = \"tcp:\/\/.*:26657\"/laddr = \"tcp:\/\/0.0.0.0:26657\"/" $CONFIG_1
#sed -i "s/persistent_peers = \".*\"/persistent_peers = \"$VAL_1@vaildator-2:26656,$VAL_3@vaildator-3:26656\"/" $CONFIG_2
#sed -i "s/persistent_peers = \".*\"/persistent_peers = \"$VAL_1@vaildator-2:26656,$VAL_2@vaildator-3:26656\"/" $CONFIG_3
