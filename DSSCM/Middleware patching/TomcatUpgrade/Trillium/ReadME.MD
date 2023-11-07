Trillium Tomcat Upgrade
Below are the changes listed for the tomcat upgrade.

Folder/File Changes
1. Retain TrilliumCountry.csv, trillium_postal.properties, trillium_projects.properties, trillium_soapadminconfig.properties, trillium_webaccess.properties
2. webapps folder
3. conf/server.xml
Edit Connector Port for HTTP/1.1
Add org.apache.coyote.http11.Http11NioProtocol Connector element and its attributes
