import google.generativeai as genai
import os
from dotenv import load_dotenv
import json
import requests
import textwrap

load_dotenv()

while True:
  rofi_input = "Enter your message: "
  user_input = os.popen('rofi -dmenu -p "{}"'.format(rofi_input)).read().strip()

  genai.configure(api_key=os.environ["API_KEY"])
  model = genai.GenerativeModel('gemini-1.5-flash')
  chat = model.start_chat(history=[])

  # Send HTTP request
  # response = model.generate_content(user_input)
  response = chat.send_message(user_input)

  # Display the response using rofi
  output = response.text
  wrapper_output = textwrap.fill(output, width=50)
  rofi_output = os.popen('echo "{}" | rofi -dmenu -p'.format(wrapper_output)).read().strip()
  print(output)
