source common.sh
print_Task_Heading "Install Nginx"
dnf install nginx -y &>>$LOG
Check_Status $?


print_Task_Heading "copy Nginx configuration"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$LOG
Check_Status $?

print_Task_Heading "clean old content"
rm -rf /usr/share/nginx/html/* &>>$LOG
Check_Status $?

print_Task_Heading "Download App Contet"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>$LOG
Check_Status $?

print_Task_Heading "Extract App Content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$LOG
Check_Status $?

print_Task_Heading "start Nginx service"

systemctl enable nginx &>>$LOG
systemctl restart nginx &>>$LOG
Check_Status $?
#