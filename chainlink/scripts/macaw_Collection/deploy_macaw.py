from brownie import MacawCollection, accounts, network, config  # import the MacawCollection library

def main():
    dev = accounts.add(config["wallets"]["from_key"]) # add the dev account
    print(network.current_network)  # prints "local")   
    print(dev.address)  # prints the address of the dev account 
    print("Welcome to wayalabs Macaw Collection")
    pass
