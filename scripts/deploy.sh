PROJECT_ROOT="/home/ubuntu/app"
JAR_FILE="$PROJECT_ROOT/cicdtest-0.0.1-SNAPSHOT.jar"

APP_LOG="$PROJECT_ROOT/application.log"
ERROR_LOG="$PROJECT_ROOT/error.log"
DEPLOY_LOG="$PROJECT_ROOT/deploy.log"

TIME_NOW=$(date +%c)

# 현재 실행 중인 애플리케이션 종료
CURRENT_PID=$(pgrep -f $JAR_FILE)

if [ -z "$CURRENT_PID" ]; then
  echo "$TIME_NOW : No application running" >> $DEPLOY_LOG
else
  echo "$TIME_NOW : Kill process $CURRENT_PID" >> $DEPLOY_LOG
  kill -9 $CURRENT_PID
fi

echo "$TIME_NOW : copy $JAR_FILE" >> $DEPLOY_LOG
cp $PROJECT_ROOT/build/libs/*.jar $PROJECT_ROOT

echo "$TIME_NOW : run $JAR_FILE" >> $DEPLOY_LOG
chmod +x $JAR_FILE
nohup java -jar $JAR_FILE > $APP_LOG 2> $ERROR_LOG &

NEW_PID=$(pgrep -f $JAR_FILE)
echo "$TIME_NOW : New process id is $NEW_PID" >> $DEPLOY_LOG