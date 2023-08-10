include .env

deploy_src:
	forge script script/deploy.s.sol --private-key ${PRIV_KEY} -f ${MUMBAI_RPC} -vvvv --verify --etherscan-api-key ${POLYGONSCAN_API_KEY} --verifier-url https://api-testnet.polygonscan.com/api/ --broadcast

deploy_dest:
	forge script script/deploy.s.sol --sig "runDst()" --private-key ${PRIV_KEY} -f ${GOERLI_RPC} -vvvv --verify --etherscan-api-key ${ETHERSCAN_API_KEY} --verifier-url https://api-goerli.etherscan.io/api/ --broadcast



deploy_setup:
	forge script script/deploy.s.sol --sig "runPostBothDep()" --private-key ${PRIV_KEY} -f ${MUMBAI_RPC} -vvvv --broadcast

init_send:
	forge script script/deploy.s.sol --sig "initSend()" --private-key ${PRIV_KEY} -f ${MUMBAI_RPC} -vvvv --broadcast