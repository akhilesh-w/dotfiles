#!/usr/bin/env python3

import requests
import json

def get_solana_price():
    try:
        response = requests.get('https://api.mobula.io/api/1/market/data?asset=Solana')
        response.raise_for_status()  # This will raise an HTTPError for bad responses
        data = response.json()
        solana_price = data['data']['price']
        return json.dumps({"text": f"SOL: ${solana_price:.2f}"})
    except requests.exceptions.RequestException as e:
        return json.dumps({"text": f"Error: Could not retrieve data"})
    except (ValueError, KeyError) as e:
        return json.dumps({"text": f"Error: Invalid data format"})

if __name__ == "__main__":
    print(get_solana_price())

