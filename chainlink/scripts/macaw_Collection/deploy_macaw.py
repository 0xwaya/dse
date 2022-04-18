from brownie import AdvancedCollectible, accounts, network, config  # import the MacawCollection library from the brownie package and the accounts, network and config libraries from brownie-cli package 
def main(): # main function
    dev = accounts.add(config["wallets"]["from_key"]) # add the dev account to the accounts list
    print(network.current_network)  # prints "local" to the console to confirm that the network is local   
    print(dev.address)  # prints the address of the dev account  
    print("Welcome to wayalabs Macaw Collection") # prints welcome message to the user
    pass # prints nothing   # pass is a placeholder for a function that does nothing    

