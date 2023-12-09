from typing import Text, List, Any, Dict

from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.types import DomainDict
import json


class ActionShowMenu(Action):
    def name(self) -> Text:
        return "action_show_menu"

    def __init__(self):
        with open('./config_files/menu.json') as json_file:
            self.data = json.load(json_file)['items']

    async def run(
        self,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict,
    ) -> List[Dict[Text, Any]]:
        dishes_list = []
        for i in self.data:
            dishes_list.append(i['name'])
        dishes = ", ".join(dishes_list)
        response = f'You can order {dishes}. I hope that you will find something that suits you.'
        dispatcher.utter_message(text=response)
        return []
