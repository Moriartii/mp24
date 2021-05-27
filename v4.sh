#!/bin/bash

echo ======================================================
sudo echo -e 'Здравствуйте!\nВы запустили планировщик изменения config.json в определенное время.'
echo ======================================================

if [ $(/usr/bin/whoami) == "wterminal" ]; then
	echo $(/usr/bin/date) >> /opt/host_changer_log
	echo -e "Запускайте скрипт только под пользователем root или kiosk.\nПрограмма завершена!"| /usr/bin/tee >> /opt/host_changer_log
	echo -e "Запускайте скрипт только под пользователем root или kiosk.\nПрограмма завершена!";
	exit 2;
fi

JSON_PATH="/opt/pp-terminal/conf/config.json"

function check_config_json() {
		cat $JSON_PATH |grep "terminalId" > /dev/null
		id_status1=$? # 0 если есть
		cat $JSON_PATH |grep "organizationId" > /dev/null
		id_status2=$? # 1 если нет
		if [ $id_status1 == 0 ] && ! [ $id_status2 == 0 ]; then
        		echo $(/usr/bin/date) >> /opt/host_changer_log
        		echo "terminalId найден в конфиге..."| /usr/bin/tee >> /opt/host_changer_log
        		echo "terminalId найден в конфиге..."
        		echo ======================================================
		fi

		if ! [ $id_status1 == 0 ] && [ $id_status2 == 1 ]; then
			echo $(/usr/bin/date) >> /opt/host_changer_log
        		echo "organizationId найден в конфиге..."| /usr/bin/tee >> /opt/host_changer_log
        		echo "organizationId найден в конфиге..."
        		echo ======================================================
		fi

		if ! [ $id_status1 == 0 ] && ! [ $id_status2 == 0 ]; then
			echo $(/usr/bin/date) >> /opt/host_changer_log
			echo "Ошибка при парсинге config.json"
        		echo "Ошибка при парсинге config.json"| /usr/bin/tee >> /opt/host_changer_log
        		echo "Проверьте путь до файла и сам файл конфигурации!"
        		echo "Проверьте путь до файла и сам файл конфигурации!"| /usr/bin/tee >> /opt/host_changer_log
        		exit 2;
        	echo ======================================================
		fi
		if [ $id_status1 == 0 ] && [ $id_status2 == 0 ]; then
        		echo $(/usr/bin/date) >> /opt/host_changer_log
        		echo "Ошибка при парсинге config.json"
        		echo "Ошибка при парсинге config.json"| /usr/bin/tee >> /opt/host_changer_log
        		echo "Проверьте путь до файла и сам файл конфигурации!"
        		echo "Проверьте путь до файла и сам файл конфигурации!"| /usr/bin/tee >> /opt/host_changer_log
        		exit 2;
        	echo ======================================================
		fi
echo "Конфиг на комплексе в порядке, начинаем запуск скрипта..."
echo $(/usr/bin/date) >> /opt/host_changer_log
echo -e "Бэкапим config.json..."| /usr/bin/tee >> /opt/host_changer_log
/usr/bin/cp $JSON_PATH /opt/config.json.bak
}
check_config_json

CRON_FILE_ORIG="/opt/cron_job_file_original"
CRON_FILE_MODIF="/opt/cron_job_file_modified"
PATH="/opt/new_hostname_and_id_DO_NOT_DELETE.txt"
CHANGER_PATH="/opt/host_changer.sh"
TODAY=$(/usr/bin/date +%Y.%m.%d)
FORMATTED_TODAY=$(echo $TODAY | /usr/bin/tr -d ".")
YEAR='2021'

echo "Введите новый хостнейм (просто нажмите ENTER если хостнейм менять не нужно):"
read HOSTNAME
echo ======================================================
echo $(/usr/bin/date) >> /opt/host_changer_log
echo "Новый хостнейм: \"$HOSTNAME\""
echo "Новый хостнейм: \"$HOSTNAME\""| /usr/bin/tee >> /opt/host_changer_log
echo ======================================================
echo "Введите новый ID организации на терминале (просто нажмите ENTER если ID менять не нужно):"
read ID_ORG
echo ======================================================
echo $(/usr/bin/date) >> /opt/host_changer_log
echo "Новый ID организации: \"$ID_ORG\""
echo "Новый ID организации: \"$ID_ORG\""| /usr/bin/tee >> /opt/host_changer_log
echo ======================================================

if [ -z "$HOSTNAME" ] && [ -z "$ID_ORG" ]; then
	echo $(/usr/bin/date) >> /opt/host_changer_log
	echo -e "Вы не указали данные для изменения.\nПрограмма завершена!"| /usr/bin/tee >> /opt/host_changer_log
	echo -e "Вы не указали данные для изменения.\nПрограмма завершена!"
	exit 2;
fi

echo "Введите дату именения данных в формате ГГГГ.ММ.ДД"
read CH_DATE
FORMATTED_CH_DATE=$(echo $CH_DATE | /usr/bin/tr -d ".")
echo ======================================================

if [[ $FORMATTED_CH_DATE == $YEAR* ]] ; then
	echo "Обработка..." > /dev/null
else
	echo -e "Дата изменения: $CH_DATE\nВы уверены? (y/N)"
	read YES_NO
	if [ $YES_NO == 'n' ] || [ $YES_NO == 'N' ]; then
		echo $(/usr/bin/date) >> /opt/host_changer_log
		echo -e "Пользователь прервал ввод данных (ошибка при вводе?).\nПрограмма завершена!"| /usr/bin/tee >> /opt/host_changer_log
		echo "Программа завершена!"
		exit 2;
	fi
fi

re='^[0-9]+$'
if ! [[ $FORMATTED_CH_DATE =~ $re ]] ; then
   echo $(/usr/bin/date) >> /opt/host_changer_log
   echo -e "Вы неверно указали дату изменения данных.\nПрограмма завершена!"| /usr/bin/tee >> /opt/host_changer_log
   echo -e 'Вы неверно указали дату изменения данных.\nПрограмма завершена!' >&2; 
   exit 2;
fi

if [ $FORMATTED_TODAY -ge $FORMATTED_CH_DATE ] ; then
	echo $(/usr/bin/date) >> /opt/host_changer_log
		echo -e 'Вы неверно указали дату изменения данных.\nПрограмма завершена!'| /usr/bin/tee >> /opt/host_changer_log
	echo -e 'Вы неверно указали дату изменения данных.\nПрограмма завершена!';
	exit 2;
else
	echo 'Устанавливаем крон...' > /dev/null
fi

echo $(/usr/bin/date) >> /opt/host_changer_log
echo -e "* * *\nДата изменения: \"$CH_DATE\"\nНовый хостнейм: \"$HOSTNAME\"\nНовый terminalId: \"$ID_ORG\"\n* * *"| /usr/bin/tee >> /opt/host_changer_log
echo -e "* * *\nДата изменения: \"$CH_DATE\"\nНовый хостнейм: \"$HOSTNAME\"\nНовый terminalId: \"$ID_ORG\"\n* * *"

function new_hostname_and_id_to_file() {
	if [ -f "$PATH" ]; then
		/usr/bin/rm -f $PATH
	fi
	/usr/bin/touch $PATH
	echo $HOSTNAME > $PATH
	echo $ID_ORG >> $PATH
	echo $CH_DATE >> $PATH
}
new_hostname_and_id_to_file

function change_config_script() {
	if [ -f "$CHANGER_PATH" ]; then
		/usr/bin/rm -f $CHANGER_PATH
	fi
	
	/usr/bin/touch $CHANGER_PATH
	echo "#!/bin/bash" >> $CHANGER_PATH
	echo "" >> $CHANGER_PATH
	echo "SCRIPT_CH_DATE=$FORMATTED_CH_DATE" >> $CHANGER_PATH
	
	if [ -z "$HOSTNAME" ]; then
		echo $(/usr/bin/date) >> /opt/host_changer_log
	   	echo -e "Новый хостнейм не задан и не будет изменен"| /usr/bin/tee >> /opt/host_changer_log
		echo "ПУСТО, пропускаем!" > /dev/null
	else
		echo "SCRIPT_HOSTNAME=\"$HOSTNAME\"" >> $CHANGER_PATH;
	fi
	
	if [ -z "$ID_ORG" ]; then
		echo $(/usr/bin/date) >> /opt/host_changer_log
	   	echo -e "Новый ID организации не задан и не будет изменен"| /usr/bin/tee >> /opt/host_changer_log
		echo "ПУСТО, пропускаем!" > /dev/null
	else	
		echo "SCRIPT_ID_ORG=$ID_ORG" >> $CHANGER_PATH;
	fi	
	/usr/bin/cat <<'EOF' >> $CHANGER_PATH
TODAY=$(/usr/bin/date +%Y.%m.%d)
FORMATTED_TODAY=$(echo $TODAY | /usr/bin/tr -d ".")
CALCULATED=$(expr $SCRIPT_CH_DATE - $FORMATTED_TODAY)
PATH="/opt/pp-terminal/conf/config.json"
CRON_FILE_ORIG="/opt/cron_job_file_original"
PATH_HOST="/opt/new_hostname_and_id_DO_NOT_DELETE.txt"
CHANGER_PATH="/opt/host_changer.sh"
if [ $CALCULATED -le 0 ]; then
	echo $(/usr/bin/date) >> /opt/host_changer_log
	echo -e "Время пришло! Меняем конфиг...\n* * *"| /usr/bin/tee >> /opt/host_changer_log
	echo "Время пришло!";
	
	if [ -z "$SCRIPT_ID_ORG" ]; then 
		echo 'VAR DO NOT EXIST';
	else
		GREP_TERMINAL_ID=$(/usr/bin/cat $PATH |/usr/bin/grep -P terminalId)
		if [ $? == 0 ]; then
			/usr/bin/sed -i "s/$GREP_TERMINAL_ID/\"terminalId\":\"$SCRIPT_ID_ORG\",/g" "$PATH"
		fi
		GREP_ORG_ID=$(/usr/bin/cat $PATH |/usr/bin/grep -P terminalId)
		if [ $? == 0 ]; then
			/usr/bin/sed -i "s/$GREP_ORG_ID/\"terminalId\":\"$SCRIPT_ID_ORG\",/g" "$PATH"
		fi
	fi
	
	if [ -z "$SCRIPT_HOSTNAME" ]; then 
		echo 'VAR DO NOT EXIST'; 
	else
		GREP_HOSTNAME=$(/usr/bin/cat $PATH |/usr/bin/grep -P hostname)
		if [ $? == 0 ]; then
			/usr/bin/sed -i "s/$GREP_HOSTNAME/\"hostname\":\"$SCRIPT_HOSTNAME\",/g" "$PATH"
		fi
	fi
	
	echo $(/usr/bin/date) >> /opt/host_changer_log
	echo -e "Очищаем cron и удаляем файлы...\n* * *"| /usr/bin/tee >> /opt/host_changer_log
	
	/usr/bin/crontab -r
	/usr/bin/crontab $CRON_FILE_ORIG
	/usr/bin/rm -f $CRON_FILE_ORIG
	/usr/bin/rm -f $PATH_HOST
	/usr/bin/rm -f $CHANGER_PATH

	/usr/bin/mv -f /opt/profile.bak /etc/profile
	
	echo $(/usr/bin/date) >> /opt/host_changer_log

	echo -e "Правка config.json произведена. Cron-job удален. * * *"| /usr/bin/tee >> /opt/host_changer_log
	echo "Правка config.json произведена. Cron-job удален!"
	/usr/bin/systemctl restart pp-terminal.service
	/usr/bin/systemctl restart sshd.service
else 
	echo $(/usr/bin/date) >> /opt/host_changer_log
	echo -e "Еще не время для запуска скрипта!\n* * *"| /usr/bin/tee >> /opt/host_changer_log
	echo "Еще не время для запуска скрипта!";
	exit 0;
fi
EOF
/usr/bin/chmod +x $CHANGER_PATH
}
change_config_script

status1=$?
if [ $status1 == 0 ]; then
	echo $(/usr/bin/date) >> /opt/host_changer_log
	echo -e "Данные для изменений сохранены..."| /usr/bin/tee >> /opt/host_changer_log
	echo "Данные для изменений сохранены..."
	echo ====================================================== > /dev/null
else
	echo $(/usr/bin/date) >> /opt/host_changer_log
	echo -e "Что-то пошло не так.\nПрограмма завершена!"| /usr/bin/tee >> /opt/host_changer_log
	echo -e "Что-то пошло не так.\nПрограмма завершена!"
	exit 2;
fi

echo ======================================================
/usr/bin/crontab -l > $CRON_FILE_ORIG
/usr/bin/cp $CRON_FILE_ORIG $CRON_FILE_MODIF


echo $(/usr/bin/date) >> /opt/host_changer_log
echo -e "Бэкапим bashrc..."| /usr/bin/tee >> /opt/host_changer_log
echo -e "Бэкапим bashrc..."
	
/usr/bin/cp /etc/profile /opt/profile.bak


echo $(/usr/bin/date) >> /opt/host_changer_log

echo -e "Правим нотификацию в bash..."
echo -e "Правим нотификацию в bash..."| /usr/bin/tee >> /opt/host_changer_log

/usr/bin/cat << EOF >> /etc/profile
echo -e "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo -e "  Внимание!" 						  
echo -e '  \E[37;44m'"\033[1m$CH_DATE\033[0m на данном ПАК будут изменены следующие данные:"				  
echo -e '  Новый хостнейм - \E[37;44m'"\033[1m$HOSTNAME\033[0m"
echo -e '  Новый id организации - \E[37;44m'"\033[1m$ID_ORG\033[0m"			  
echo -e "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
EOF


echo $(/usr/bin/date) >> /opt/host_changer_log
echo -e "Нотификация для bash-сессий установлена..."| /usr/bin/tee >> /opt/host_changer_log
echo -e "Нотификация для bash-сессий установлена..."
echo ======================================================

echo $(/usr/bin/date) >> /opt/host_changer_log
echo -e "Записываем задачу в cron..."| /usr/bin/tee >> /opt/host_changer_log
echo "*/1 * * * * /opt/host_changer.sh" >> $CRON_FILE_MODIF;
/usr/bin/crontab $CRON_FILE_MODIF
/usr/bin/rm -f $CRON_FILE_MODIF
echo $(/usr/bin/date) >> /opt/host_changer_log
echo -e 'Крон успешно настроен!\n* * *'| /usr/bin/tee >> /opt/host_changer_log
echo -e 'Крон успешно настроен! Скрипт завершен. Дата изменения:'
echo $CH_DATE

