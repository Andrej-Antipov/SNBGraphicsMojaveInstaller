#!/bin/sh
clear

osascript -e "tell application \"Terminal\" to set the font size of window 1 to 12"
osascript -e "tell application \"Terminal\" to set background color of window 1 to {1028, 12850, 65535}"
osascript -e "tell application \"Terminal\" to set normal text color of window 1 to {65535, 65535, 65535}"


clear && printf '\e[3J'

printf '\n\n*****  Программа удаления поддержки встроенной графики SandyBridge   ******\n'
printf '*****                            Версия 3.51                         ******\n'
printf '*****  Только для операционной системы  MacOS 10.14 "Mojave"         ******\n'

sleep 1

printf '\n    !!!   Ваша система '
printf "`sw_vers -productName`"
printf ': '; printf "`sw_vers -productVersion`" 
printf '('
printf "`sw_vers -buildVersion`"
printf ') '


string=`sw_vers -productVersion` 
string1=`echo ${string//[^0-9]/}`
string=${string1:0:4}
fstring=${string1:0:5}
vbuild=`sw_vers -buildVersion`


if [ "$string" != "1014" ]

     then

     printf ' - неправильно !!!'
     sleep 3
     printf '\n !!! Программа не предназначена для этой версии операционной системы !!!\n'
     
     printf '\nЗавершение программы. Выход ... \n\n\n\n'
     sleep 5
     killall Terminal
     
     exit 1
fi



printf '  - OK                !!!\n\n' 


cd $(dirname $0)

FILE="/System/Library/Extensions/AppleIntelSNBGraphicsFB.kext/Contents/Info.plist"
stat=0
sfbstat=0

printf '    !!!   Проверка наличия удаляемых кекстов SandyBridge графики:       !!!\n' 

if [ ! -f "$FILE" ]; then
    printf '    !!!          нет - не установлены в систему.                    !!!\n\n'
    sfbstat=0
    else 
    printf '    !!!          да -  они установлены в системе.                       !!!\n\n'
    stat=1
    sfbstat=1
fi
 


printf '    !!!   Проверка системной версии AppleGVA:                           !!!\n'

unzip  -o -qq AppleGVA.zip 
unzip  -o -qq SandyB.zip 

gvastat=0

if  cmp -s AppleGVA/17G3025/AppleGVA.framework/Resources/version.plist /System/Library/PrivateFrameworks/AppleGVA.framework/Resources/version.plist 
     then 
         gvastat=1
         hsdef=17G3025
fi 

if  cmp -s AppleGVA/17G2208/AppleGVA.framework/Resources/version.plist /System/Library/PrivateFrameworks/AppleGVA.framework/Resources/version.plist 
     then 
         gvastat=1
         hsdef=17G2208
fi


if  cmp -s AppleGVA/17G65/AppleGVA.framework/Resources/version.plist /System/Library/PrivateFrameworks/AppleGVA.framework/Resources/version.plist
    then
        gvastat=1
        hsdef=17G65
fi


#if  cmp -s AppleGVA/17G5019/AppleGVA.framework/Resources/version.plist /System/Library/PrivateFrameworks/AppleGVA.framework/Resources/version.plist
#     then 
#         gvastat=1
#         hsdef=17G5019
#fi 


if  cmp -s AppleGVA/17G6030/AppleGVA.framework/Resources/version.plist /System/Library/PrivateFrameworks/AppleGVA.framework/Resources/version.plist
    then
        gvastat=1
       hsdef=17G6030
fi


if [[ $gvastat = 1 ]]; then
         printf '    !!!   AppleGVA от 10.13.6 ('
         printf $hsdef
         printf ') установлен в системе.        !!!\n\n'
     else
         printf '    !!!   нет - AppleGVA от 10.13.6 не установлен в системе.           !!!\n\n'
fi
   
if [ $stat -eq 0 ]; then
          printf 'Программа не обнаружила изменений системы \n'
          printf '\nВосстанавливать нечего. Выход ... !\n\n\n'
          sleep 3
          rm -R ./AppleGVA
         rm -R ./SandyB
         rm -R -f ./_MACOSX
         sleep 5
         clear
         osascript -e 'tell application "Terminal" to close first window' & exit
          exit 1
fi

cd $(dirname $0)

FILE="AppleGVA/$vbuild/AppleGVA.framework/Resources/version.plist"
     if [ ! -f "$FILE" ]; then
     printf '\n\n    !!! "Программа не может сейчас восстановить эту сборку системы      !!!\n'
     printf '    !!! "Поскольку для нее не сделано сохранение оригинального сценария !!!\n'
     printf '    !!! "Который должен был быть сохранен автоматически при установке   !!!\n'
     printf '    !!! "патча для поддержки графики SandyBridge в мак ос Mojave.       !!!\n'
     printf '    !!! "Но этого не произошло или сценарий был потом удален вручную    !!!\n'
     printf '    !!! "Поместите оригинальный ApleGVA.framework в директорию AppleGVA !!!\n'
     printf '    !!! "корневой папки этой программы, в папку с номером билда мак ос  !!!\n'
     printf '    !!! "Образцы других версий уже находятся в этой папке для примера   !!!\n'
     printf '    !!! "И после восстановления бэкапа сценария перезапустите программу !!!\n\n'
     printf 'Завершение программы. Выход ... \n\n\n'
     sleep 3
     rm -R ./AppleGVA
     rm -R ./SandyB
     rm -R -f ./_MACOSX
     exit 1
fi

printf '\n\n*****   Если вы понимаете что делаете нажмите клавишу "Y" (Англ.)     *****\n\n'


read -p "Продолжать выполнение программы? (y/N) " -n 1 -r

if [[ ! $REPLY =~ ^[yY]$ ]]

then
    
    printf '\n\nЗавершение  программы. Выход ... !\n\n\n'
    sleep 2
    rm -R ./AppleGVA
    rm -R ./SandyB
    rm -R -f ./_MACOSX
    printf '\n'
    osascript -e 'tell application "Terminal" to close first window' & exit
fi

sleep 0.3



printf '\nВведите ваш пароль\n\n'

if [ $sfbstat -ne 0 ]; then
        sudo printf '\n\nУдаляем расширения ядра для SandyBridge Graphics\n'
fi

if [ $gvastat -ne 0 ]; then
sudo printf '\nКопию оригинального системного AppleGVA.framework восстанавливаем в системе\n\n'
fi

sleep 1

function ProgressBar {

let _progress=(${1}*100/${2}*100)/100
let _done=(${_progress}*4)/10
let _left=40-$_done

_fill=$(printf "%${_done}s")
_empty=$(printf "%${_left}s")

printf "\rВыполняется: ${_fill// /.}${_empty// / } ${_progress}%%"

}


_start=1

_end=100

cd $(dirname $0)

number=1
ProgressBar ${number} ${_end}

if [ $sfbstat -ne 0 ]
then
sudo rm -R -f /System/Library/Extensions/AppleIntelHD3000Graphics.kext

number=5
ProgressBar ${number} ${_end}

sudo rm -R -f /System/Library/Extensions/AppleIntelHD3000GraphicsGA.plugin

number=10
ProgressBar ${number} ${_end}

sudo rm -R -f /System/Library/Extensions/AppleIntelHD3000GraphicsGLDriver.bundle

number=15
ProgressBar ${number} ${_end}

sudo rm -R -f /System/Library/Extensions/AppleIntelHD3000GraphicsVADriver.bundle

number=20
ProgressBar ${number} ${_end}

sudo rm -R -f /System/Library/Extensions/AppleIntelSNBGraphicsFB.kext

number=25
ProgressBar ${number} ${_end}

sudo rm -R -f /System/Library/Extensions/AppleIntelSNBVA.bundle

fi

number=30
ProgressBar ${number} ${_end}


sleep 0.2
 
number=35
ProgressBar ${number} ${_end}

sleep 0.2

number=40
ProgressBar ${number} ${_end}

sleep 0.2

number=45
ProgressBar ${number} ${_end}

sleep 0.2

number=50
ProgressBar ${number} ${_end}

sleep 0.2

number=55
ProgressBar ${number} ${_end}

sleep 0.2

number=60
ProgressBar ${number} ${_end}

sleep 0.2

number=65
ProgressBar ${number} ${_end}

sleep 0.2

number=70
ProgressBar ${number} ${_end}

if [ $gvastat -ne 0 ]; then

sudo rm -R -f  /System/Library/PrivateFrameworks/AppleGVA.framework

number=75
ProgressBar ${number} ${_end}

sudo cp -R AppleGVA/$vbuild/AppleGVA.framework /System/Library/PrivateFrameworks/

number=80
ProgressBar ${number} ${_end}

sudo chmod -R 755 /System/Library/PrivateFrameworks/AppleGVA.framework

number=85
ProgressBar ${number} ${_end}

sudo chown -R 0:0 /System/Library/PrivateFrameworks/AppleGVA.framework

number=90
ProgressBar ${number} ${_end}

sudo chmod -R 755 /System/Library/Extensions/

number=95
ProgressBar ${number} ${_end}

sudo chown -R 0:0 /System/Library/Extensions/

fi

number=100
ProgressBar ${number} ${_end}

printf '\n\nЗапрошенные операции выполнены\n\n'

sleep 1

rm -R ./AppleGVA
rm -R ./SandyB
rm -R -f ./_MACOSX


printf '\nОбновляем системный кэш.\n'
printf '\nВыполняется: \n'

while :;do printf '.\n' ;sleep 7;done &
trap "kill $!" EXIT 
sudo touch /System/Library/Extensions 2>/dev/null
sudo kextcache -u /  2>/dev/null
kill $!
wait $! 2>/dev/null
trap " " EXIT



printf '\n\nСистемный кэш обновлен\n'
sleep 1

printf '\n\nТаймаут для системного урегулирования\n\n'

_start=1

_end=100


for number in $(seq ${_start} ${_end})
do
sleep 0.2
ProgressBar ${number} ${_end}
done

printf '\nОбновляем кэш системных сценариев. Это занимает несколько минут\n'
sleep 2
printf '\nВыполняется: '
while :;do printf '.';sleep 3;done &
trap "kill $!" EXIT 
 sudo update_dyld_shared_cache -debug -force -root / 2>/dev/null
kill $!
wait $! 2>/dev/null
trap " " EXIT

printf '\n\nКэш системных сценариев обновлен\n\n'

printf '\nВсе операции завершены\n'
sleep 1

printf '\nНеобходимый таймаут перед перезагрузкой операционной системы\n'

printf '\nНажмите CTRL + C для прерывания если не хотите перезагружать сейчас\n\n'
sleep 5


_start=1

_end=100


for number in $(seq ${_start} ${_end})
do
sleep 0.4
ProgressBar ${number} ${_end}
done

sleep 1

printf '\n\nПрограмма завершена. Инициирована перезагрузка.\n'
printf '\nНа HDD перезагрузка может занять пару минут.\n\n'

sudo reboot now

osascript -e 'tell application "Terminal" to close first window' & exit

exit 

