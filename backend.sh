mysql_root_password=$1

echo diable default NodeJS version module
dnf module disable nodejs -y &>>/tmp/expense.log
echo $?
echo enable NodeJS module for v20
dnf module enable nodejs:20 -y &>>/tmp/expense.log
echo $?
echo install NodeJS
dnf install nodejs -y &>>/tmp/expense.log
echo $?
echo Adding Application User
useradd expense &>>/tmp/expense.log
echo $?
echo copy Backend Service file

cp backend.service /etc/systemd/system/backend.service &>>/tmp/expense.log
echo $?
echo Clean the old Content
rm -rf /app &>>/tmp/expense.log
echo $?
echo Create App Directory
mkdir /app &>>/tmp/expense.log
echo $?
echo Download App Content
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip &>>/tmp/expense.log
echo $?
echo Extract App Content
cd /app &>>/tmp/expense.log
unzip /tmp/backend.zip &>>/tmp/expense.log
echo $?
echo Download NodeJS Dependencies
cd /app &>>/tmp/expense.log
npm install &>>/tmp/expense.log
echo $?
echo Start Backend Service
systemctl daemon-reload &>>/tmp/expense.log
systemctl enable backend &>>/tmp/expense.log
systemctl start backend &>>/tmp/expense.log
echo $?
echo Install MySQL Client
dnf install mysql -y &>>/tmp/expense.log
echo $?
echo Load Schema
mysql -h 172.31.82.154 -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>/tmp/expense.log
echo $?