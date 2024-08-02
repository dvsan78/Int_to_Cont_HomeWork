# Int_to_Cont_HomeWork
Скрипт создания контейнера LXC astralinux-se c установленным php  для разработки web приложений

Скрипт тестировался на системе  AstraLinux 1.7.3

Содержание файла /etc/apt/sources.list:

>deb http://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-base/     1.7_x86-64 main contrib non-free
>
>deb http://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-extended/ 1.7_x86-64 main contrib non-free

**Сценарий**

 Выполняем скрипт на хосте скрипт создает контейнер myapp c установленным php и nginx.

 
 Далее необходимо выполнить следующие действия:

**Cоздаем в домашней папке user директорию develop (в которой будем писать код),пробрасываем ее в контейнер:**
   
 добавляем в  /var/lib/lxc/myapp/config строчку
 
 >lxc.mount.entry = /home/user/develop **var/www/html** none bind, create-dir ,rw 0 0 
   
 запускаем контейнер
 
  >sudo lxc-start myapp
   
**Настраиваем  пользователя в контейнере таким образом чтобы его uid и gid  соответсвовал пользователю на хостовой машине**

  Определяем id текущего пользователя на хостовой машине
  
  >user@astra:~$ id
>
  >uid=1000(user) gid=1000(user) группы=1000(user),
  
  Выполняем в контейнере
  
> sudo lxc-attach myapp -- userdel -r admin
> 
> sudo lxc-attach myapp -- groupadd -g 1000 user
> 
> sudo lxc-attach myapp -- useradd -s /bin/bash --gid  1000 -G user --uid 1000 -m user
> 

**настраиваем nginx**
   
 >sudo lxc-attach -n myapp  nano /etc/nginx/sites-available/default
 
 раскоментируем строки    
 
>#location ~ \.php$ {
>#fastcgi_pass unix:/run/php/php7.3-fpm.sock;
>#}

проверяем конфигурацию  nginx , делаем reload

>sudo lxc-attach -n myapp  nginx -s reload

**настраиваем PHP**
  
>sudo lxc-attach -n myapp nano /etc/php/7.3/fpm/pool.d/www.conf
    
изменяем  в строчках пользователя
  
>user = www-data
>
>group = www-data
>
 на 
>user = user
>
>group = user

Делам рестарт systemctl restart php7.3-fpm

**Проверка написанного кода**
  
Пишем код в папке develop/index.php на хостовой машине и проверяем его работу в LXS контейнере, предварительн уточнив адрес

>user@astra:~$ sudo lxc-ls -f

| NAME |  STATE | AUTOSTART | GROUPS | IPV4 | IPV6 | UNPRIVILEGED |
| --- | --- | --- | --- | --- | --- | --- |
myapp | RUNNING | 0  |       -  |    10.0.3.35| - |   false |

**Проверка открыть в браузере хоста url http://10.0.3.35/index.php**


