import json


def get_opening_hours_intent():
    now_options = [
        'are you open {//:hour}?',
        'is the restaurant open {//:hour}?',
        'can I come by {//:hour}?'
    ]
    time_options = [
        'are you open at {//:hour}?',
        'are you operating at {//:hour}?',
        'will you be available at {//:hour}?',
        'are you open at {//:hour} on {//:day}?',
        'will you be open at {//:hour} on {//:day}?',
        'can i come by on {//:day}, {//:hour}?'
    ]
    days = [
        'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ]

    result = []
    for i in now_options:
        result.append(i.replace('{//:hour}', '[now](hour)'))

    for i in time_options:
        for hour in range(1, 24):
            if '{//:day}' in i:
                for day in days:
                    result.append(i.replace('{//:hour}', f'[{hour}:00](hour)').replace('{//:day}', f'[{day}](day)'))
            else:
                result.append(i.replace('{//:hour}', f'[{hour}:00](hour)'))

    with open('opening_hours_intents.txt', 'a') as f:
        for intent in result:
            f.write(f'- {intent}\n')


def order_food_intent():
    product_options = [
        "I'd like to order {//:product}.",
        "I want to order {//:product}.",
        "Please order {//:product}.",
        "I wnat to order {//:product}.",
        "Let's order {//:product} from your menu, but without [meat](custom_dish).",
        "Let's order {//:product} without [chicken](custom_dish) for lunch.",
        "I'd like to order {//:product}, no [pork](custom_dish) now.",
        "Add {//:product} to my order that's is [not spicy](custom_dish), please."
    ]

    result = []
    with open('./chatbot/config_files/menu.json') as json_file:
        data = json.load(json_file)
        for i in product_options:
            for product in data['items']:
                result.append(i.replace('{//:product}', f'[{product["name"]}](product)'))
    with open('menu_intents.txt', 'a') as f:
        for intent in result:
            f.write(f'- {intent}\n')


order_food_intent()
