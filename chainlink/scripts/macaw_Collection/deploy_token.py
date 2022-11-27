from brownie import accounts,  config, WayaToken  # , Contract

initial_supply = 200000000 * 10 ** 18
token_name = "Tree Nuts"
token_symbol = "NUTS"

def main():
    account = accounts(0)  
    IERC20 = WayaToken.deploy(
        initial_supply, token_name, token_symbol, {'from': account})
    