nohup java -jar -Dtrillium_logger_path=/appl/trilapi/logs -Dserver.ssl.enabled-protocols=TLSv1.2 -Djasypt.encryptor.password=TRILLIUM_JASYPT_TOKEN -Dspring.profiles.active=qa trillium-api-1.0.0-SNAPSHOT.jar &