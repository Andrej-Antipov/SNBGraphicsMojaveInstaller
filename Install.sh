#!/bin/sh

clear

osascript -e "tell application \"Terminal\" to set the font size of window 1 to 12"
osascript -e "tell application \"Terminal\" to set background color of window 1 to {1028, 12850, 65535}"
osascript -e "tell application \"Terminal\" to set normal text color of window 1 to {65535, 65535, 65535}"

clear && printf '\e[3J'

printf '\n\n*****  Программа установки поддержки встроенной графики SandyBridge  ******\n'
printf '*****                            Версия 3.5                          ******\n'
printf '*****  Только для операционной системы  MacOS 10.14 "Mojave"         ******\n'


sleep 1

printf '\n    !!!   Ваша система '
printf "`sw_vers -productName`"
printf ': '; printf "`sw_vers -productVersion`" 
printf '('
printf "`sw_vers -buildVersion`"
printf ') '

#printf '\n'
string=`sw_vers -productVersion` 
string1=`echo ${string//[^0-9]/}`
string=${string1:0:4}
fstring=${string1:0:5}
vbuild=`sw_vers -buildVersion`
hsbuild=17G6030


if [ "$string" != "1014" ]

     then

     printf ' - неправильно !!!'
     sleep 3
     printf '\n !!! Программа не предназначена для этой версии операционной системы !!!\n'
     
     printf '\nЗавершение программы. Выход ... \n\n\n\n'
     sleep 5
     clear
     osascript -e 'tell application "Terminal" to close first window' & exit
fi

printf '  - OK                !!!\n\n' 


cd $(dirname $0)


FILE="/System/Library/Extensions/AppleIntelSNBGraphicsFB.kext/Contents/Info.plist"
sfbstat=0


if [ ! -f "$FILE" ]; then
        sfbstat=0
    else 
        sfbstat=1
fi

gvastat=0
hsdef=$hsbuild

unzip  -o -qq AppleGVA.zip 
unzip  -o -qq SandyB.zip 

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


if  cmp -s AppleGVA/17G4015/AppleGVA.framework/Resources/version.plist /System/Library/PrivateFrameworks/AppleGVA.framework/Resources/version.plist
    then
        gvastat=1
       hsdef=17G6030
fi

if  cmp -s AppleGVA/17G5019/AppleGVA.framework/Resources/version.plist /System/Library/PrivateFrameworks/AppleGVA.framework/Resources/version.plist
     then 
         gvastat=1
         hsdef=17G5019
fi 
   
new=0

FILE="AppleGVA/$vbuild/AppleGVA.framework/Resources/version.plist"
     if [ ! -f "$FILE" ]; then
         new=1
         printf '    !!! Результат этой инсталляции на новых версиях MacOS непредсказуем !!!\n'
         printf '    !!! Бэкап AppleGVA.framework для этой сборки Мак ОС еще не сделан   !!!\n\n'
fi

if [[ $sfbstat = 1  ]]; then
printf '    !!! Расширения ядра для SandyBridge уже установлены в эту систему   !!!\n'
printf '    !!!         Продолжите чтобы перезаписать их еще раз.               !!!\n\n'
fi

if [[ $gvastat = 1  ]]; then
printf '    !!! Сценарий AppleGVA от 10.13.6 ('
printf $hsdef
printf ') найден в этой системе    !!!\n'
printf '    !!!          Продолжите чтобы переустановить его                    !!!\n\n'
fi

Ask_Operation(){ echo ${Message}"Выберите номер билда 10.13.6  для установки его AppleGVA.framework?"${Blank}
printf '\nИли нажмите клавишу Enter для выбора по умолчанию номера билда - '
printf $hsbuild
printf '\n'
echo ""
#echo ${Message}"1 - 17G65\n2 - 17G2208\n3 - 17G3025\n4 - 17G4015\n5 - 17G5019"${Blank}
echo ${Message}"1 - 17G65\n2 - 17G2208\n3 - 17G3025\n4 - 17G5019\n5 - 17G6030"${Blank}
echo ""

read -e operation

if [[ $operation == "1" ]];then
hsbuild=17G65
fi
if [[ $operation == "2" ]];then
hsbuild=17G2208
fi
if [[ $operation == "3" ]];then
hsbuild=17G3025
fi
if [[ $operation == "4" ]];then
hsbuild=17G5019
fi

if [[ $operation == "5" ]];then
hsbuild=17G6030
fi
 }

Ask_Operation
printf '\nВы выбрали - '
printf $hsbuild
printf '\n'

printf '\n*****   Если вы понимаете что делаете нажмите клавишу "Y" (Англ.)     *****\n\n'

read -p "Желаете продолжить установку? (y/N) " -n 1 -r

if [[ ! $REPLY =~ ^[yY]$ ]]

then
    
    printf '\n\nМудрый выбор. Завершение  программы. Выход ... !\n'
    sleep 2
    rm -R ./AppleGVA
    rm -R ./SandyB
    rm -R -f ./_MACOSX
    clear
    osascript -e 'tell application "Terminal" to close first window' & exit
fi


sleep 0.3

printf '\n\n\n*****  Вы точно знаете что делаете!  *****\n\n'
printf '\nДля продолжения введите ваш пароль\n\n'

sudo printf '\n\nУстанавливаем расширения ядра для SandyBridge Graphics\n'
printf '\nи сценарий поддержки аппаратного ускорения графики\n\n'


if [[ $new = 1 && $gvastat = 0 ]]; then
     FILE="AppleGVA/$vbuild/AppleGVA.framework/Resources/version.plist"
     if [ ! -f "$FILE" ]; then
     printf 'Копию системного AppleGVA.framework сохраним в папку AppleGVA\n'
     printf 'в корневой директории этой установочной программы \n\n'
     fi
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

number=30
ProgressBar ${number} ${_end}


sudo cp -R SandyB/AppleIntelHD3000Graphics.kext /System/Library/Extensions/

number=35
ProgressBar ${number} ${_end}

sudo cp -R SandyB/AppleIntelHD3000GraphicsGA.plugin /System/Library/Extensions/

number=40
ProgressBar ${number} ${_end}

sudo cp -R SandyB/AppleIntelHD3000GraphicsGLDriver.bundle /System/Library/Extensions/

number=45
ProgressBar ${number} ${_end}

sudo cp -R SandyB/AppleIntelHD3000GraphicsVADriver.bundle /System/Library/Extensions/

number=50
ProgressBar ${number} ${_end}

sudo cp -R SandyB/AppleIntelSNBGraphicsFB.kext /System/Library/Extensions/

number=55
ProgressBar ${number} ${_end}

sudo cp -R SandyB/AppleIntelSNBVA.bundle /System/Library/Extensions/

number=60
ProgressBar ${number} ${_end}

sleep 0.2

number=65
ProgressBar ${number} ${_end}


if [[ $new = 1 && $gvastat = 0 ]]; then
    FILE="AppleGVA/$vbuild/AppleGVA.framework/Resources/version.plist"
    if [ ! -f "$FILE" ]; then
      mkdir AppleGVA/$vbuild
      cp -R /System/Library/PrivateFrameworks/AppleGVA.framework AppleGVA/$vbuild/
      rm AppleGVA.zip
      zip -rX -qq AppleGVA.zip ./AppleGVA
    fi  
fi

number=70
ProgressBar ${number} ${_end}

sudo rm -R -f  /System/Library/PrivateFrameworks/AppleGVA.framework

number=75
ProgressBar ${number} ${_end}

sudo cp -R AppleGVA/$hsbuild/AppleGVA.framework /System/Library/PrivateFrameworks/

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

number=100
ProgressBar ${number} ${_end}

printf '\n\nCистемные кексты установлены\n'
sleep 2



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
sleep 0.1
ProgressBar ${number} ${_end}
done

printf '\n\nОбновляем кэш системных сценариев. Это занимает несколько минут\n'
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
sleep 0.3
ProgressBar ${number} ${_end}
done

sleep 1

printf '\n\nПрограмма завершена. Инициирована перезагрузка.\n'
printf '\nНа HDD перезагрузка может занять несколько минут.\n\n'


sudo reboot now

osascript -e 'tell application "Terminal" to close first window' & exit

exit 


