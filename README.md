# foundry-template • [![CI](https://github.com/transmissions11/foundry-template/actions/workflows/tests.yml/badge.svg)](https://github.com/transmissions11/foundry-template/actions/workflows/tests.yml)

Streamlined template for getting started with Foundry and Solmate.

## Contributing

You will need a copy of [Foundry](https://github.com/foundry-rs/foundry) installed before proceeding. See the [installation guide](https://github.com/foundry-rs/foundry#installation) for details.

### Setup

```sh
$ git clone https://github.com/transmissions11/foundry-template.git 
$ cd foundry-template
$ git submodule init 
$ forge build 
```

### Run Tests

```sh
$ forge test
```

### Update Gas Snapshots

```sh
$ forge snapshot
```

### Install dependencies

```
$ forge install
$ forge install transmissions11/solmate -->
$ forge install Openzeppelin/openzeppelin-contracts -->
$ forge install OpenZeppelin/openzeppelin-contracts-upgradeable --no-commit -->
```

### Before Pushing to github

```
$ forge test
$ forge fmt
$ forge snapshot
$ forge fmt --check
$ forge snapshot --check
$ git push
```

### Create a contract

```
$ forge create {{contract}} --rpc-url=$GOERLI_PRIVATE_KEY --private-key=$GOERLI_PRIVATE_KEY
$ forge create {{contract}} --rpc-url=$RPC_URL --private-key=$PRIVATE_KEY --constructor-args <name> <symbol>
$ forge create --rpc-url <your_rpc_url> --private-key <your_private_key> src/MyContract.sol:MyContract
$ forge create --rpc-url <your_rpc_url> --constructor-args "ForgeUSD" "FUSD" 18 1000000000000000000000 --private-key <your_private_key> src/MyToken.sol:MyToken --etherscan-api-key <your_etherscan_api_key> --verify
```

### send a transaction
```
$ cast send --rpc-url=$GOERLI_PRIVATE_KEY $TARGET_ADDRESS {{method}} {{args}} --private-key=$GOERLI_PRIVATE_KEY
$ cast call --rpc-url=$GOERLI_PRIVATE_KEY $TARGET_ADDRESS {{method}} {{args}}
```

### Debug
```
$ forge debug --debug {{file}} --sig {{method}} {{args}} {{args1}}
$ forge debug --debug src/SomeContract.sol --sig "myFunc(uint256,string)" 123 "hello"
$ forge test --debug "testSomething()"
```
