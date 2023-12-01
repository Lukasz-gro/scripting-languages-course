game_board=(" " " " " " " " " " " " " " " " " ")
player1_name=""
player2_name=""
count=0
initialize_whole_game() {
  echo "Insert player 1 name"
  read name
  player1_name=$name
  echo "Insert player 2 name"
  read name
  player2_name=$name
}

initialize_game() {
  game_board=(" " " " " " " " " " " " " " " " " ")
  count=0
}

display_game_board() {
  for i in 0 3 6; do
    echo " ${game_board[$((i))]} | ${game_board[$((i+1))]} | ${game_board[$((i+2))]} "
    if [[ $i -ne 6 ]]; then
      echo "---|---|---"
    fi
  done
}

display_turn_information() {
  local player_name=$1
  local marker=$2
  display_game_board
  echo
  echo "$player_name's turn. Enter the number from 1-9 to place $marker"
  echo "In order to save the game and quit type s"
}

place_marker() {
  while true; do
    read position
    if [ "$position" == "s" ]; then
      return 1
    fi
    if [[ ! "$position" =~ ^[1-9]$ ]]; then
      echo "Please input number from 1 to 9"
    elif [ "${game_board[$((position - 1))]}" != " " ]; then
      echo "Select not empty postion"
    else
      game_board[$((position - 1))]=$1
      break
    fi
  done
  return 0
}

check_win_condition() {
  local marker=$1
  for i in 0 1 2; do
    if [ "${game_board[$((i))]}" == "$marker" ] && [ "${game_board[$((i+3))]}" == "$marker" ] && [ "${game_board[$((i+6))]}" == "$marker" ]; then
      return 1
    fi
    if [ "${game_board[$((3*i))]}" == "$marker" ] && [ "${game_board[$((3*i+1))]}" == "$marker" ] && [ "${game_board[$((3*i+2))]}" == "$marker" ]; then
      return 1
    fi

    if [ "${game_board[0]}" == "$marker" ] && [ "${game_board[4]}" == "$marker" ] && [ "${game_board[8]}" == "$marker" ]; then
      return 1
    fi
    if [ "${game_board[2]}" == "$marker" ] && [ "${game_board[4]}" == "$marker" ] && [ "${game_board[6]}" == "$marker" ]; then
      return 1
    fi

  done
  return 0
}

save_game_state() {
  echo "Saving the game"
  printf "" > game_state.txt
  printf "%s\n" "$1" >> game_state.txt
  printf "%s\n" "$player1_name" >> game_state.txt
  printf "%s\n" "$player2_name" >> game_state.txt
  printf "%s," "${game_board[@]}" >> game_state.txt
  printf "\n" >> game_state.txt
  echo "Thanks for playing"
}

game_loop() {
  local current_marker=$1
  local current_player=$2
  while true; do
    display_turn_information "$current_player" "$current_marker"
    place_marker "$current_marker"
    player_action=$?
    if [[ "$player_action" -eq 1 ]]; then
      save_game_state "$current_marker"
      return 1
    fi
    count=$((count+1))
    check_win_condition "$current_marker"
    res=$?

    if [[ $res -eq 1 ]]; then
      display_game_board
      echo -e "$current_player won!\n\n"
      break
    fi
    if [ ${count} == 9 ]; then
      echo -e "Game ended in a draw.\n\n"
      break
    fi
    if [ "$current_marker" != "O" ]; then
      current_marker="O"
      current_player="$player1_name"
    else
      current_marker="X"
      current_player="$player2_name"
    fi
  done
  return 0
}

main() {
  while true; do
    echo -e "Select how you want to play:\n s - starts the game\n l - loads saved game \n q - quits the game"
    local mode=""
    while true; do
      read temp
      if [ "$temp" == "s" ]; then
        mode=$temp
        break
      fi
      if [ "$temp" == "q" ]; then
        mode=$temp
        break
      fi
      if [ "$temp" == "l" ]; then
        mode=$temp
        break
      fi
      echo "Choose correct mode" 
    done
    if [ "$mode" == "q" ]; then
      echo "Thanks for playing!"
      break
    fi
    local current_marker="O"
    local current_player=$player1_name
    if [ "$mode" == "s" ]; then
      if [ "$player1_name" != "" ]; then
        initialize_game
      else
        initialize_whole_game
      fi
    fi
    if [ "$mode" == "l" ]; then
      iter=0
      count=0
      while read -r line;
      do
        if [[ $iter -eq 0 ]]; then
          current_marker=$line
        elif [[ $iter -eq 1 ]]; then
          player1_name=$line
        elif [[ $iter -eq 2 ]]; then
          player2_name=$line
        else
          IFS=', ' read -ra game_board <<< $line
          for i in "${!game_board[@]}"; do
            if [ -z "${game_board[$i]}" ]; then
              game_board[$i]=" "
            else 
              count=$((count+1))
            fi
          done
        fi
        iter=$((iter+1))
      done < game_state.txt
     fi
    if [ "$current_marker" == "O" ]; then
      current_player="$player1_name"
    else
      current_player="$player2_name"
    fi
    game_loop "$current_marker" "$current_player"
    game_res=$?
    if [[ $game_res -eq 1 ]]; then
      return 0
    fi
  done
}

main

