from brownie import MacawCollectible, accounts, network, config # imports the  MacawCollectible contract    

def main(): # main function
    dev = accounts.add(config["wallets"]["from_key"]) # add the dev account to the accounts list
    print(dev)
        