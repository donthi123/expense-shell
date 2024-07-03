source common.sh
mysql_root_password=$1
# If password is not provided then we will exit
if [ -z "${mysql_root_password}" ]; then
  echo Input Password is missing
  exit 1

fi

print_Task_Heading "Disable default NodeJS version module"
dnf module disable nodejs -y &>>$LOG
check_status $?

print_Task_Heading "enable NodeJS module for v20"
dnf module enable nodejs:20 -y &>>$LOG
check_status $?

print_Task_Heading "install NodeJS"
dnf install nodejs -y &>>$LOG
check_status $?

print_Task_Heading "Adding Application User"
useradd expense &>>$LOG
check_status $?

print_Task_Heading "Copy Backend Service file"

cp backend.service /etc/systemd/system/backend.service &>>$LOG
check_status $?

print_Task_Heading "Clean the old Content"
rm -rf /app &>>$LOG
check_status $?

print_Task_Heading "Create App Directory"
mkdir /app &>>$LOG
check_status $?

print_Task_Heading "Download App Content"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip &>>$LOG
check_status $?

print_Task_Heading "Extract App Content"
cd /app &>>$LOG
unzip /tmp/backend.zip &>>$LOG
check_status $?

print_Task_Heading "Download NodeJS Dependencies"
cd /app &>>$LOG
npm install &>>$LOG
check_status $?
print_Task_Heading "start Backend Service"
systemctl daemon-reload &>>$LOG
systemctl enable backend &>>$LOG
systemctl start backend &>>$LOG
check_status $?
print_Task_Heading "Install MySQL Client"
dnf install mysql -y &>>$LOG
check_status $?
print_Task_Heading "Load Schema"
mysql -h 172.31.82.154 -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOG
check_status $?