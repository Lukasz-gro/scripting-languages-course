from typing import Text, List, Any, Dict

from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.types import DomainDict
import json


class ActionCheckMenuItem(Action):
    def name(self) -> Text:
        return "action_check_menu_items"

    def __init__(self):
        with open('./config_files/menu.json') as json_file:
            self.data = json.load(json_file)['items']

    def product_exist(self, product_name):
        if product_name is None:
            return False
        for product in self.data:
            if product['name'].strip().lower() == product_name.strip().lower():
                return True
        return False

    async def run(
        self,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict,
    ) -> List[Dict[Text, Any]]:
        entities = tracker.latest_message['entities']

        user_product = next(
            (entity['value'] for entity in entities if entity['entity'] == 'product'),
            None
        )
        user_preferences = next(
            (entity['value'] for entity in entities if entity['entity'] == 'custom_dish'),
            None
        )

        if self.product_exist(user_product):
            if user_preferences is not None:
                response = f'{user_product} was added to your order and will be made according to your preferences!'
            else:
                response = f'{user_product} was added to your order.'
        else:
            response = (f'I cannot find it in our menu, please make sure that the item does not contain '
                        f'spelling errors.')

        dispatcher.utter_message(text=response)
        return []
