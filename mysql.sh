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
mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG
Check_Status $?