#!/usr/bin/env python3

import requests
import json

def get_solana_price():
    try:
        response = requests.get(
            'https://api.coingecko.com/api/v3/simple/price',
            params={'ids': 'solana', 'vs_currencies': 'usd'},
            timeout=10,
        )
        response.raise_for_status()
        solana_price = response.json()['solana']['usd']
        return json.dumps({"text": f"SOL: ${solana_price:.2f}"})
    except requests.exceptions.RequestException as e:
        return json.dumps({"text": f"Error: Could not retrieve data"})
    except (ValueError, KeyError) as e:
        return json.dumps({"text": f"Error: Invalid data format"})

if __name__ == "__main__":
    print(get_solana_price())

