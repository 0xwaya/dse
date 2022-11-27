import os
from webbrowser import MacOSX

def main():
    dev = accounts.add(os.getenv(config["wallets"]["from_key"]))
    macaw_collectible = MacawCollectible[len(MacawCollectible)-1]
    transaction = macaw_collectible.create_collectible(
        "None", STATIC_SEED, {'from': dev})
    print("waiting on second transactions...")
    time.sleep(30)
    requestId = transaction.events["RequestCollectible"]["requestId"]
    token_id = macaw_collectible.get_token_id(requestId)
    genus = get_genus(macaw_collectible.token_id_to_genus(token_id))
    print("Macaw genus of tokenId {}".format(token_id, genus))
    print("Macaw collectible deployed to {}".format(macaw_collectible.address))
    
    