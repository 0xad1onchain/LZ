include .env

deploy:
	forge script script/deploy.s.sol --private-key ${PRIV_KEY} -f ${RPC} --verify --etherscan-api-key ACF1R442Q17QZGFUVQ466C6EZBYYSG4P9R -vvvv