source ./venv/bin/activate
nohup python3 main.py &
echo "discord bot running"
cd bot2
nohup rasa run &
echo "rasa is running"
nohup rasa run actions &
echo "rasa actions is running"
