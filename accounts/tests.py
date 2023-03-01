from django.test import TestCase
from web3 import Web3

infura_url = "https://goerli.infura.io/v3/7be23b899a744c88b7019f1c8af2f211"
web3 = Web3(Web3.HTTPProvider(infura_url))
print(web3.isConnected())
print(web3.eth.blockNumber)


balance = web3.eth.getBalance("0x776274b162A6821307542dB86b8F6091379d5FC8")

print(balance)
