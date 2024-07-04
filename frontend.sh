source common.sh
app_dir=/usr/share/nginx/html
component=frontend

print_Task_Heading "Install Nginx"
dnf install nginx -y &>>$LOG
Check_Status $?


print_Task_Heading "copy Nginx configuration"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$LOG
Check_Status $?

App_PreReq

print_Task_Heading "start Nginx service"

systemctl enable nginx &>>$LOG
systemctl restart nginx &>>$LOG
Check_Status $?
#