#!/usr/bin/env bash

sleep .5
cor=$(DISPLAY=:0 grabc)

if [[ "$cor" =~ '#' ]] && [[ ${#cor} == 7 ]]; then
	echo $cor | xclip -sel clipboard
	notify-send "cor copiada $cor"
else
	notify-send "erro"
fi