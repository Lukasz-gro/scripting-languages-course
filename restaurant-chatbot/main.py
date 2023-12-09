import discord
from discord.ext import commands
import requests

rasa_server_url = "http://localhost:5005/webhooks/rest/webhook"


def make_request(user_message):
    payload = {
        "message": user_message,
        "sender": "user"
    }
    response = requests.post(rasa_server_url, json=payload)

    try:
        if response.status_code == 200:
            rasa_response = response.json()
            to_return = rasa_response[0]['text']
            return to_return
    except:
        return "Sorry, I have problem understanding your intent :( Please try to phrase your message differently."


intents = discord.Intents.default()
intents.messages = True

bot = commands.Bot(command_prefix='!', intents=intents)


@bot.event
async def on_message(message):
    if message.author == bot.user:
        return

    if isinstance(message.channel, discord.DMChannel):
        await message.channel.send(f'{make_request(message.content)}')


bot.run('BOT_API_KEY')
