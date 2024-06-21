import google.generativeai as genai
import os
import dotenv
from dotenv import load_dotenv

load_dotenv()

input="Enter your message: "

genai.configure(api_key=os.environ["API_KEY"])

model = genai.GenerativeModel('gemini-1.5-flash')

response = model.generate_content(input)
print(response.text)
