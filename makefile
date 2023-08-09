include .env

deploy_src:
	forge script script/deploy.s.sol --private-key ${PRIV_KEY} -f ${MUMBAI_RPC} -vvvv --verify --etherscan-api-key ACF1R442Q17QZGFUVQ466C6EZBYYSG4P9R --verifier-url https://api-testnet.polygonscan.com/api/ --broadcast

deploy_dest:
	forge script script/deploy.s.sol --sig "runDst()" --private-key ${PRIV_KEY} -f ${GOERLI_RPC} -vvvv --verify --etherscan-api-key JE1H3QF86FX3B8KPECQH2SBDQR7ZFHH5PC