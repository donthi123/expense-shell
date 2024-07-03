source common.sh
if [ -z "${mysql_root_password}" ]; then
    echo input password missing
    exit 1
fi
print_Task_Heading "install MySQL server"
dnf install mysql-server -y &>>$LOG
Check_Status $?

print_Task_Heading "start MySQL service"
systemctl enable mysqld &>>$LOG
systemctl start mysqld &>>$LOG
Check_Status $?

print_Task_Heading "setup MySQL password"
echo 'show databases' |mysql -h 172.31.82.154 -uroot -p${mysql_root_password} &>>$LOG
if [ $? -ne 0 ]; then
    mysql_secure_installation --set-root-pass {mysql_root_password} &>>$LOG
fi

Check_Status $?