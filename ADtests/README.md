(Rev date: 10-08-2022 12:38)

#  Robot Framework
### _Robot Framework is a generic test automation framework for acceptance testing and acceptance test-driven development (ATDD)._

###### Robot Overview
Robot Framework is a test automation framework that makes it easy for QA teams to manage acceptance testing and acceptance test-driven development (ATDD) environments. The tool was first designed by Pekka Klarck in 2005 and developed at Nokia Networks the same year. It was offered as open-source in 2008. Written in Python language, Robot offers a rich ecosystem of libraries and tools while allowing you to integrate it with virtually any test automation solution. The framework also runs on IronPython (.NET) and Jython (JVM). It is platform-agnostic and application-agnostic as well. The tool comes with easy syntax and uses a keyword-driven test approach. The keywords are human-readable. You can use the built-in keywords or create one from scratch. Currently, Robot Framework Foundation now takes care of the development of the tool.

###### What is Acceptance Testing?
Acceptance testing is a part of a testing project that checks if the software complies with functional specifications and business requirements before pushing it into production. In a typical testing pipeline, unit tests run first. They are followed by integration testing and system testing. Finally, acceptance testing is done to ensure that the software meets all business requirements before it is delivered to end-users. Acceptance testing is normally performed by running Black Box testing.
###### What is Acceptance Test-Driven Development (ATDD)?
Acceptance Test-Driven Development (ATDD) is a user-centric approach to test automation. In a Test-driven Development (BDD) environment, developers write tests from their perspective. ATDD works the other way round. Here, different teams such as Developers, QA, and customers collaborate on preparing acceptance test cases before incorporating the functionality into the application. With a user-centric approach and seamless collaboration between development teams and functional experts, developed applications have a higher chance of meeting acceptance criteria. With ATDD, functional testing becomes easy and effective.
[Read more](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#rules-for-parsing-the-data)

## Features
- Table-based test cases: The tool enables you to write test cases using keywords in a simple tabular format.
- Keywords: The tool offers built-in keywords to write test cases. You can also import keywords from open-source libraries or create your own keywords.
- Libraries: The tool supports a range of libraries such as Selenium library, iOS library, Debug library, FTP library, etc.
- Resources: The tool allows you to import robot files with keywords from external sources.
Variables: The tool supports three types of variables; scalar variable, dictionary variable, and list variable.
- Tags: The tool allows you to tag test cases so that you can add or omit them while running test suites.
- Reports and Logs: The tool provides the details of the tests in the form of HTML and log files.

## Installation
Getting Started with Robot Framework
Here are the prerequisites for running this acceptance testing framework.

- Python with PIP
- Robot Framework
- wxPython
- RIDE

##### Step 1: Install Python
Visit the following website to download Python software: https://www.python.org/downloads/

Download the version for your operating system (eg: Windows). Double-click the Python software to begin the installation. click on ‘Install Now' to install the default package. It comes with pip, IDLE, and documentation. 
- Notice that the Setup offers an option ‘Add Python to PATH. When you check this box, the tool will automatically update the path of Python in environment variables.
- Note that pip gets installed along with python by default.

To check if Python and pip are correctly installed, open the command prompt, and run the version command.
- Check on cmd:
```sh
python --version
```
```sh
pip --version
```
##### Step 2: Set Python in environment variables
After installing Python and pip, you should configure environment variables by adding the path. To do so, Go to System - > My Computer > Properties > Advanced System Settings > Environment Variables.

Add the path of the folder where Python is installed to the system variables section and user variables section. Here, you see that path is already updated as this option is selected while installing Python.
```sh
C:\Python27;C:\Python27\Scripts;
``` 
- Check on cmd:
```sh
python --version
```
##### Step 3: Install Robot Framework
Open the command prompt and navigate to the python folder and type the following command:
```sh
pip install robotframework
```
Robot Framework should be successfully installed. You can check it using the version command:

```sh
robot --version
```

##### Step 6: Download and install wxPython
Open the command prompt and type the following command:
```sh
Pip install –u wxPython
```
You can check it using the command:
```sh
pip freeze  
```
wxPython should be available

##### Step 7: Install RIDE
To install RIDE, open the command prompt and type the following command.
```sh
pip install robotframework-ride  
```
Now, RIDE is ready for use.

##### Step 8: On cmd goto folder where ride.py is (for example C:\Python27\Scripts)
To open RIDE, open the command prompt and type the following command:
```sh
ride.py
```
This should open RIDE
##### Step 9: Install required library(s)
On cmd use next commands (use similar for other libraries):
```sh
pip install robotframework-excellibrary
```
```sh
pip install robotframework-JSONLibrary
```
```sh
pip install robotframework-excellibrary
```

pip install -U robotframework-pabot==1.13
pip install robotframework-ride==3.0.4

Check the library in your python path (Ex. C:\Python27\Lib\site-packages\ExcelLibrary)
Import the library in your test.
| Library name  | Docu/URL/Keywords |
| ------ | ------ |
| SeleniumLibrary | https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html |
| String | https://robotframework.org/robotframework/latest/libraries/String.html |
| Collections | https://robotframework.org/robotframework/latest/libraries/Collections.html |
| ExcelLibrary | http://navinet.github.io/robotframework-excellibrary/ExcelLibrary-KeywordDocumentation.html |
| DateTime | https://robotframework.org/robotframework/latest/libraries/DateTime.html |
| ImapLibrary | https://rickypc.github.io/robotframework-imaplibrary/doc/ImapLibrary.html |
|json|https://robotframework-thailand.github.io/robotframework-jsonlibrary/JSONLibrary.html|
|RequestsLibrary|https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html|
|OperatingSystem|https://robotframework.org/robotframework/latest/libraries/OperatingSystem.html|
|BuiltIn|https://robotframework.org/robotframework/latest/libraries/BuiltIn.html|
|openpyxl|https://openpyxl.readthedocs.io/en/stable/|
pabot.PabotLib

##### Step 10: Install browser drivers

BROWSER/DOWNLOAD LOCATION
Firefox
https://github.com/mozilla/geckodriver/releases
Chrome
http://chromedriver.chromium.org/downloads
Internet Explorer
https://github.com/SeleniumHQ/selenium/wiki/InternetExplorerDriver
Microsoft Edge - IS NOT SUPPORTED!!!
https://blogs.windows.com/msedgedev/2015/07/23/bringing-automated-testing-to-microsoft-edge-through-webdriver/
Opera
https://github.com/operasoftware/operachromiumdriver/releases


## UNINSTALLATION
To uninstall Ride use next cmd command:
```sh
pip uninstall robotframework-ride
```
```sh
pip uninstall robotframework
```
## Helpful TIPS:

1. Always install wxPython before installing RIDE. wxPython is a wrapper for getting the GUI of RIDE. So it is important to install wxPython before you install RIDE

2. Always check your python version and install wxPython for the same version
     ***32 bit - check your python ver by running command python and install same bit wxpython

|Prerequisites|RCMD version|
|------|------|
|Python|2.7.14|
|pip|20.3.4|
|Robot Framework|4.1.1|
|robotframework-ride|1.7.4.2|
|wxPython|4.0.7.post2|
You can check it using the command:
```sh
pip freeze  
```

or

```sh
pip list  
```

**Other RCMD versions:**
certifi==2021.5.30
chardet==3.0.4
coverage==5.5
decorator==4.4.2
et-xmlfile==1.0.1
future==0.18.2
helper==2.5.0
idna==2.6
jdcal==1.4.1
jsonpath-rw==1.4.0
jsonpath-rw-ext==1.2.2
natsort==6.2.1
numpy==1.16.6
olefile==0.42.1
openpyxl==2.6.4
pandas==0.24.2
pbr==4.0.2
Pillow==6.2.2
pluggy==0.6.0
ply==3.11
py==1.5.3
Pygments==2.5.2
PyPubSub==3.3.0
python-dateutil==2.8.1
pytz==2021.1
pywin32==228
PyYAML==5.4.1
requests==2.18.4
robotframework==4.1.1
robotframework-datadriver==0.2.7
robotframework-excellib==2.0.1
robotframework-excellibrary==0.0.2
robotframework-httplibrary==0.4.2
robotframework-imaplibrary==0.3.0
robotframework-jsonlibrary==0.3.1
robotframework-openpyxllib==0.7
robotframework-requests==0.4.7
robotframework-requestschecker==2.0.0
robotframework-ride==1.7.4.2
robotframework-selenium2library==3.0.0
robotframework-seleniumlibrary==3.2.0
selenium==3.8.1
six==1.11.0
soupsieve==1.9.1
tox==3.0.0
tzlocal==2.1
urllib3==1.22
virtualenv==15.2.0
waitress==1.2.1
WebOb==1.8.5
WebTest==2.0.33
wxPython==4.0.7.post2
xlrd==1.2.0
xlutils==2.0.0
xlwt==1.3.0|

To run pabot --processes in parallel open ${CURDIR} folder (c:\Python27\ROBOT_TESTS\RobotTests2021\ADtests>) and run cmd (each next command will run diff tests!):

pabot --processes 2 0.TRANSLATION.robot
pabot --processes 2 ADtests\*.robot
pabot --processes 5 --include Critical --exclude (FIX?) ADtests\*.robot
pabot --processes 4 --include Critical --exclude (FIX?) --outputdir Results ADtests\0*.robot
pabot --processes 3 --outputdir Results ADtests\0*.robot
pabot --processes 4 --outputdir Results --include Critical --exclude (FIX?) ADtests\*.robot


JENKINS
---------
RUN at http://localhost:8080/script

To stop:
jenkins.exe stop

To start:
jenkins.exe start

To restart:
jenkins.exe restart

To fix log issue
********************

System.setProperty("hudson.model.DirectoryBrowserSupport.CSP","sandbox allow-scripts; default-src 'none'; img-src 'self' data: ; style-src 'self' 'unsafe-inline' data: ; script-src 'self' 'unsafe-inline' 'unsafe-eval' ;")


To clear builds history
************************

item = Jenkins.instance.getItemByFullName("your-job-name-here")
//THIS WILL REMOVE ALL BUILD HISTORY
item.builds.each() { build ->
  build.delete()
}
item.updateNextBuildNumber(1)

CRON - https://crontab.guru/
****

0 12 * * 1 - “At 12:00 on Monday.”
H 0 */10 * * - “At 00:00 on every 10th day-of-month.”
H 12 * * 1-5 - “At every minute past hour 12 on every day-of-week from Monday through Friday.”
H * 12 * 1 - “At every minute past hour 12 on Monday.”
H 12 * * 1,3,5 - “At every minute past hour 12 on Monday, Wednesday, and Friday.”
H */24 * * * - “Once on every 24 hours”

ADMIN: oksanasoiko/2Qds4Cr9ggvpHbB9SwE6
USER: RFRobot/qfTAhNFBJCgRugacp7bM
gmail windows mail pass: kyruclbieavfqegs


Useful JENKINS plugins
1. Config AutoRefresh - Provide a way to configure the auto-refresh rate from the Jenkins UI. https://plugins.jenkins.io/config-autorefresh-plugin/


