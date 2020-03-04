#!/bin/bash
callspringbatch()
{
while true
do 
echo "Batch job start"
BATCH_EXEC="java -cp ./spring-batch-core-2.2.0.RELEASE.jar:./target/dependency-jars/*:./target/spring-batch.jar org.springframework.batch.core.launch.support.CommandLineJobRunner spring/batch/jobs/job-read-files.xml readMultiFileJob"
echo $BATCH_EXEC
eval $BATCH_EXEC
exitIfError $? "Error running batch program." 100
echo "Batch job before sleep"
sleep 120
echo "Batch job after sleep"
done
}

exitIfError()
{
  if [ $1 -ne 0 ]
    then
      echo "$2 Code: $3"
      exit $3
  else
   echo "Before email sending......"
	  topicARN=arn:aws:sns:us-east-1:700953544126:eb-batch-topic
	  textm="batch jon failed, please look into this issue."
	  subj="Batch Job issue"
	  aws configure set aws_access_key_id AKIAIBZKMS32E7J4ANAQ
	  aws configure set aws_secret_access_key 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
	  aws configure set default.region us-east-1
	  touch message.txt
	 # echo "batch job issue occured." > message.txt
	  curl http://169.254.169.254/latest/meta-data/instance-id > message.txt
	  msg=$(cat message.txt)
	  AWS_ACCESS_KEY=AKIAIBZKMS32E7J4ANAQ AWS_SECRET_KEY=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 aws sns publish --topic-arn $topicARN --subject "${subj}" --message "${msg}"
	  echo "After email sending......"
	echo "Batch job successfully executed...."
  fi
}


callspringbatch

