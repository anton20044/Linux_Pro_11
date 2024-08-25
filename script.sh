#! /bin/bash
(
flock -n 9 || exit 1
  tmp=""
  tmp1=""
  tmp2=""
  tmp3=""

  tm=`date +"%d/"%m/%Y:%H`  

  tmp=`grep "\$tm" access.log | awk '{print \$1}' | sort | uniq -c | sort -nr | head -1`

#echo "Список IP адресов с наибольшим количеством запросов: IP - `echo $tmp | cut -f2 -d ' '`, количество обращений - `echo $tmp | cut -f 1 -d ' '`" 

  tmp1=`grep "\$tm" access.log | awk -F '"' '{print \$3}' | cut -f 2 -d ' ' | sort | uniq -c | sort -rn`

#echo -e "Список всех кодов HTTP ответа с указанием их количества: \n $tmp1"

  tmp2=`grep "\$tm" access.log | awk -F '"' '{print \$3}' | cut -f 2 -d ' ' | awk '{t = \$1 > 200;sum+=t;print sum}' | tail -1`

#echo -e "Ошибки веб-сервера/приложения: $tmp2"

  tmp3=`grep "\$tm" access.log | awk -F '"' '\$4!="-" {print \$4}' | sort | uniq -c | sort -nr`

#echo -e "Список запрашиваемых URL: \n $tmp3"

#mail -s "Status Web Server"

echo -e "Врменной диапозон: $tm часов \n
Список IP адресов с наибольшим количеством запросов: IP - `echo $tmp | cut -f2 -d ' '`, количество обращений - `echo $tmp | cut -f 1 -d ' '` \n  

Список всех кодов HTTP ответа с указанием их количества: \n $tmp1
\n
Ошибки веб-сервера/приложения: $tmp2
\n
Список запрашиваемых URL: \n $tmp3
" | mail -s "Status Web Server" -a "Smtp: mymailserver.ru:25" anton@mymail.ru
	

) 9>/var/lock/script_lock
