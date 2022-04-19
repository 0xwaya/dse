from pickle import FALSE
from brownie import AdvancedCollectible, accounts, network, config # imports the AdvancedCollectible contract, accounts, network, and config

def main(): # main function
    dev = accounts.add(config["wallets"]["from_key"]) # add the dev account to the accounts list
    print(network.show_network)  # prints "local" to the console to confirm that the network is local   
    print(dev.address)  # prints the address of the dev account  
    print("Welcome to wayalabs Macaw Collection") # prints welcome message to the user
    publish_source = FALSE  # set publish_source to false
    AdvancedCollectible = AdvancedCollectible.deploy( # deploys the AdvancedCollectible contract
        config["networks"][network.show_active()]["vrf_coordinator"], 
        config["networks"][network.show_active()]["link_token"],
        config["networks"][network.show_active()]["keyhash"],
        {"from": dev}, 
        publish_source = publish_source)
        