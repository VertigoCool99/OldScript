import os
import requests
import json
from discord_webhook import DiscordWebhook, DiscordEmbed
import time
  
response_API = requests.get('https://rest-bf.blox.land/chat/history')
data = response_API.text
json.loads(data)
parse_json = json.loads(data)
active = parse_json['rain']['active']
prize = parse_json['rain']['prize']
players = parse_json['rain']['players']
webhookurl = my_secret = os.environ['webhook']

webhook = DiscordWebhook(url=webhookurl, username="Rain")

embed = DiscordEmbed(title='Rain Time!', color='03b2f8',)
embed.set_author(name='VertigoCool')

sent = False
while True:
  time.sleep(2)
  if sent == False:
    if active == True:
      host = parse_json['rain']['host']
      duration = parse_json['rain']['duration']
      embed.add_embed_field(name="Prize:", value=prize)
      embed.add_embed_field(name="Duration:", value=duration)
      embed.add_embed_field(name="Host:", value=host)
      webhook.add_embed(embed)
      response = webhook.execute()
      sent = True
    else:
      print("No Rains :(")
      sent = False
