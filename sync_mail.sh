#!/bin/bash
function sync_mail {
read -p "Enter the path to file .csv: " file
read -p "Enter old SMTP server: " old_srv
read -p "Enter new SMTP server: " new_srv
while IFS=',' read -r e1 p1 e2 p2
do
        if imapsync \
        --nosyncacls --subscribe --syncinternaldates \
        --nofoldersizes --skipsize --fast \
        --host1 $old_srv --user1 $e1 --password1 $p1 --ssl1 \
        --host2 $new_srv --user2 $e2 --password2 $p2 --ssl2 >& /dev/null; then
                echo "Email $e1 has been synced successfully !!!"
        else
                echo "Can't sync email $e1 !!!"
        fi
done < $file
read -p "Press any button to return to menu ♥ " button
case $button in
*) menu;;
esac
}

function install_imapsync {
if which imapsync >& /dev/null; then
          echo "Package Imapsync was installed."
          sync_mail
else
         echo "Please wait a moment. The system is installing Imapsync."
         if yum makecache && yum -y install imapsync
         then
                 sync_mail
         else
                 echo "Can't install Imapsync. Please reinstall Imapsync."
         fi
fi

}

function create_email {
read -p "Enter the path to file .csv: " file
while IFS=',' read -r frist_name last_name email password
do
	if su - zimbra -c "zmprov createAccount $email $password displayName '$frist_name $last_name' givenName '$frist_name' sn '$last_name'" >& /dev/null
	then
		echo "Creating email $email is successfull!!!"
	else
		echo "Can't create email $email"
	fi
done < $file
read -p "Press any button to return to menu ♥ " button
case $button in 
*) menu;;
esac
}

function menu {
clear
echo "
░██████╗██╗░░░██╗███╗░░██╗░█████╗░  ███╗░░░███╗░█████╗░██╗██╗░░░░░  ████████╗░█████╗░░█████╗░██╗░░░░░
██╔════╝╚██╗░██╔╝████╗░██║██╔══██╗  ████╗░████║██╔══██╗██║██║░░░░░  ╚══██╔══╝██╔══██╗██╔══██╗██║░░░░░
╚█████╗░░╚████╔╝░██╔██╗██║██║░░╚═╝  ██╔████╔██║███████║██║██║░░░░░  ░░░██║░░░██║░░██║██║░░██║██║░░░░░
░╚═══██╗░░╚██╔╝░░██║╚████║██║░░██╗  ██║╚██╔╝██║██╔══██║██║██║░░░░░  ░░░██║░░░██║░░██║██║░░██║██║░░░░░
██████╔╝░░░██║░░░██║░╚███║╚█████╔╝  ██║░╚═╝░██║██║░░██║██║███████╗  ░░░██║░░░╚█████╔╝╚█████╔╝███████╗
╚═════╝░░░░╚═╝░░░╚═╝░░╚══╝░╚════╝░  ╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝╚══════╝  ░░░╚═╝░░░░╚════╝░░╚════╝░╚══════╝
"
echo "1) Create email"
echo "2) Sync mail"
echo "3) Exit"
read -p "Which is your choose?: " choose
case $choose in
1) create_email;;
2) install_imapsync;;
3) echo "Bye" && exit;;
esac
}

if ! which imapsync >& /dev/null; then
    echo "Check imapsync service"
    echo "Installing imapsync service"
    yum -y install epel-release
    yum -y install imapsync
    menu
else
    menu
fi
