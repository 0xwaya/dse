#!/usr/bin/python3
import os
from webbrowser import MacOSX
from brownie import MacawCollectible as brownie_MacawCollectible, accounts, network, config # imports the MacawCollectible contract

def main(): # main function
    dev = accounts.add(config["wallets"]["from_key"]) # add the dev account to the accounts list
    macaw_collectible = MacawCollectible[len(MacawCollectible)-1] 
    interface.LinkTokenInterface(config["networks"][network.show_active()]["link_token"]).transfer(
        macaw_collectible, config["networks"][network.show_active()]["fee"]), {"from": dev}
    
    