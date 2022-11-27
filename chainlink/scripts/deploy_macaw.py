#!/usr/bin/python3
import os
from webbrowser import MacOSX
from brownie import MacawCollectible as brownie_MacawCollectible, accounts, network, config # imports the MacawCollectible contract


def main(): # main function
    dev = accounts.add(config["wallets"]["from_key"]) # add the dev account to the accounts list
    print(network.show_active()
    return MacawCollectible.deploy(config["networks"][network.show_active()]
                                                        ["vrf_coordinator"], 
                                   config["networks"][network.show_active()]
                                                        ["link_token"],
                                   config["networks"][network.show_active()]
                                                        ["keyhash"],
                                      {"from": dev})
    

        
                                                        
                                   
        