#!/usr/bin/env python3

import requests

def get_solana_price():
    try:
        response = requests.get('https://api.mobula.io/api/1/market/data?asset=Solana')
        data = response.json()
        solana_price = data['data']['price']
        return f"{solana_price:.2f}"
    except Exception as e:
        return f"Error: {e}"

if __name__ == "__main__":
    print(f"SOL: ${get_solana_price()}")

