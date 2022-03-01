#!/bin/bash


echo "Программа для определения изменения файла после указанной даты"
echo "Автор: Кривошеин Илья, группа 748" 
echo "Хотите ли вы узнать текущий каталог [Y/N]?"
read response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
	echo $PWD
else
	echo "Хорошо, сейчас вам будут предложены дальнейшие действия"
fi
echo "Продолжить или выйти [C/E]?"
read response
if [[ "$response" =~ ^([cC])$ ]]
then
	echo "Продолжаем"
else
	echo usrdenied >&2
	exit 0
fi
echo "Введите файл для проверки его существования в текущей директории"
read file
filecorrect=0
until [ $filecorrect -gt 0 ]
do
	if [[ -f "$file" ]]
	then
		echo "Существует"
		((filecorrect++))
	elif find -- "$PWD" -prune -type d -empty | grep -q '^'
	then
		echo "Директория $PWD пуста, выходим"
		echo dirempty >&2
		exit 0
	else
		echo "Не существует, введите повторно"
		echo filenf >&2
	fi
done
echo "Продолжить или выйти [C/E]?"
read response
if [[ "$response" =~ ^([cC])$ ]]
then
        echo "Продолжаем"
else
		echo usrdenied >&2
        exit 0
fi
datecorrect=0
until [ $datecorrect -gt 0 ]
do
	echo "Введите дату в формате bash, например YYYYMMDD"
	read date
	if date -d "$date" >/dev/null
	then
		echo "Вы ввели дату $date, она корректна"
		((datecorrect++))
	else
		echo "Введите дату повторно, дата $date некорректна"
		echo incdate >&2
	fi
done
echo "Продолжить или выйти [C/E]?"
read response
if [[ "$response" =~ ^([cC])$ ]]
then
        echo "Продолжаем"
else
		echo usrdenied >&2
        exit 0
fi
echo "Проверяем, был ли доступ к файлу $file после даты $date"
accdate=$(stat -c %x "$file")
accdate=${accdate//-/}
if [[ $accdate > $date ]]
then
	echo "Файл $file открывали после даты $date"
else
	echo "Файл $file не открывали после даты $date"
	echo fileno >&2
	exit 120
fi
