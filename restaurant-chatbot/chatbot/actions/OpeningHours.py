# https://rasa.com/docs/rasa/custom-actions
from datetime import datetime

from typing import Text, List, Any, Dict

from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.types import DomainDict
import json


class ActionCheckOpeningHours(Action):
    def name(self) -> Text:
        return "action_check_opening_hours"

    def __init__(self):
        with open('./config_files/opening_hours.json') as json_file:
            self.data = json.load(json_file)['items']

    def get_opening_time_for_day(self, day):
        if day is None:
            day = datetime.now().strftime("%A")

        opening_time = datetime.strptime(f'{self.data.get(day).get("open")}:00', "%H:%M").time()
        return opening_time

    def get_closing_time_for_day(self, day):
        if day is None:
            day = datetime.now().strftime("%A")

        closing_time = datetime.strptime(f'{self.data.get(day).get("close")}:00', "%H:%M").time()
        return closing_time

    async def run(
        self,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict,
    ) -> List[Dict[Text, Any]]:
        entities = tracker.latest_message['entities']
        user_time = next(
            (entity['value'] for entity in entities if entity['entity'] == 'hour'),
            None
        )
        user_day = next(
            (entity['value'] for entity in entities if entity['entity'] == 'day'),
            None
        )

        if user_time:
            try:
                if user_time == 'now':
                    user_datetime = datetime.now().time().strftime("%H:%M")
                    user_datetime = datetime.strptime(user_datetime, "%H:%M").time()
                else:
                    user_datetime = datetime.strptime(user_time, "%H:%M").time()

                opening_time = self.get_opening_time_for_day(user_day)
                closing_time = self.get_closing_time_for_day(user_day)
                print(opening_time, closing_time)

                if opening_time <= user_datetime <= closing_time:
                    response = "Yes, the shop is open at {}.".format(user_time)
                else:
                    response = "No, the shop is closed at {}.".format(user_time)

            except ValueError:
                response = ("Sorry, I couldn't understand the provided time, please make sure that th ehour is written "
                            "correctly.")

        else:
            response = "Sorry, I can't understand your message, please try to phrase it slightly different."

        dispatcher.utter_message(text=response)
        return []
