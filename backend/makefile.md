forge script --rpc-url $SEPOLIA_RPC_URL --private-key $DEV_PRIVATE_KEY script/DeployMainToken.s.sol:GreenToken

Deployed at: https://sepolia.etherscan.io/token/0xc9bedbc9dbb65c820036bcf7a12c9c9caf9d6d02

owner = 0x7d577a597B2742b498Cb5Cf0C26cDCD726d39E6e;

forge test --match-path test/MainToken.t.sol -vvvvv
forge test --match-path test/FundsHandlerTest.t.sol -vvv
