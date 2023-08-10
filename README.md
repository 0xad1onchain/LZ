# <h1 align="center"> LZ Token Bridge </h1>

**Quick demo on using OFT protocol to send tokens crosschain using LayerZero**



## Getting Started

Clone this repository. If you dont have foundry installed, set it up

Or, if your repo already exists, run:
```sh
forge build
```

Create a `.env` file with following secrets 

```
PRIV_KEY
MUMBAI_RPC
GOERLI_RPC
ETHERSCAN_API_KEY
POLYGONSCAN_API_KEY
```

## Deploying cross chain token

At the moment, the codebase scripts are configured to bridge a token from mumbai testnet to goerli testnet. This can be changed by changing chain id and lz_endpoints in `deploy.s.sol` 

1. Run `make deploy_src` to deploy a sample token and proxy contract on the source chain
2. Run `make deploy_dest` to deploy receiver OFT contract on the destination chain
3. Run `make deploy_setup` to setup source chain contract to interact with destination contract
4. Run `make init_send` to initiate a token bridge call from source chain



## Development

This project uses [Foundry](https://getfoundry.sh). See the [book](https://book.getfoundry.sh/getting-started/installation.html) for instructions on how to install and use Foundry.
