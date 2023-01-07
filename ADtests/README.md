(Rev date: 06-01-2023 22:38)

# ROBOT FRAMEWORK
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

## Installation - Getting Started with Robot Framework
Here are the prerequisites for running this acceptance testing framework

- Python with PIP
- Robot Framework
- wxPython
- RIDE
- Installed RF libraries and other required staff (see details below) 

##### Step 1: Install Python
Visit the following website to download Python software: https://www.python.org/downloads/

Download the version for your operating system (eg: Windows). Double-click the Python software to begin the installation. click on �Install Now' to install the default package. It comes with pip, IDLE, and documentation. 
- Note that pip gets installed along with python by default.

To check if Python and pip are correctly installed, open the command prompt, and run the version cmd command: python --version or pip --version

##### Step 2: Set Python in environment variables
After installing Python and pip, you should configure environment variables by adding the path. To do so, Go to System - > My Computer > Properties > Advanced System Settings > Environment Variables or run systempropertiesadvanced - to see env variables

Add the path of the folder where Python is installed to the system variables section and user variables section. Here, you see that path is already updated as this option is selected while installing Python. For example, C:\Python27;C:\Python27\Scripts and check its version by cmd: python --version

##### Step 3: Install Robot Framework
Open the command prompt and navigate to the python folder and type the following command: pip install robotframework
Robot Framework should be successfully installed. You can check it using the version command: robot --version

##### Step 6: Download and install wxPython
Open the command prompt and type the following command: Pip install �u wxPython
You can check its version by using the command: pip freeze (wxPython should be available in a list)

##### Step 7: Install RIDE
To install RIDE, open the command prompt and type the following command: pip install robotframework-ride
Now, RIDE is ready for use

##### Step 8: On cmd goto folder where ride.py is (for example C:\Python27\Scripts)
To open RIDE, open the command prompt and type the following command: ride.py
This should open RIDE

##### Step 9: Install required library(s)
On cmd use next commands (use similar for other libraries):
pip install robotframework-excellibrary
pip install robotframework-JSONLibrary
pip install robotframework-seleniumlibrary
pip install robotframework-JSONLibrary
pip install strings
pip install DateTime
pip install robotframework-pabot
pip install robotframework-FtpLibrary
pip install openpyxl
pip install collection
pip install robotframework-imaplibrary
pip install jsonlib
pip install requests
pip install os-sys
pip install robotframework-openpyxllib

pip install -U robotframework-pabot==1.13
pip install robotframework-ride==1.7.4.2

Check the library in your python path (Ex. C:\Python27\Lib\site-packages\ExcelLibrary)

##### Step 10: Install browser drivers
Download browser driver and unpack it to your Python folder (root)

BROWSER/DOWNLOAD LOCATION
Firefox - https://github.com/mozilla/geckodriver/releases
Chrome - http://chromedriver.chromium.org/downloads
Internet Explorer - https://github.com/SeleniumHQ/selenium/wiki/InternetExplorerDriver (2023 End of support)
Microsoft Edge - IS NOT SUPPORTED!!! - https://blogs.windows.com/msedgedev/2015/07/23/bringing-automated-testing-to-microsoft-edge-through-webdriver/
Opera - https://github.com/operasoftware/operachromiumdriver/releases


## UNINSTALLATION
To uninstall Ride use next cmd command: pip uninstall robotframework-ride
To uninstall robotframework use next cmd command: pip uninstall robotframework

## Helpful TIPS:

1. Always install wxPython before installing RIDE. wxPython is a wrapper for getting the GUI of RIDE. So it is important to install wxPython before you install RIDE
2. Always check your python version and install wxPython for the same version. ***32 bit - check your python ver by running command python and install same bit wxpython

|Prerequisites|RCMD version|
|------|------|
|Python|2.7.14|
|pip|20.3.4|
|Robot Framework|4.1.1|
|robotframework-ride|1.7.4.2|
|wxPython|4.0.7.post2|

You can check its versions using the command: pip freeze or pip list

## Pabot - A parallel executor for Robot Framework tests. With Pabot you can split one execution into multiple and save test execution time.

Install: pip install robotframework-pabot
To run pabot --processes in parallel open ${CURDIR} folder (c:\Python27\ROBOT_TESTS\RobotTests2021\ADtests>) and run cmd command (each next command will run diff tests!):

pabot --processes 2 0.TRANSLATION.robot
pabot --processes 2 ADtests\*.robot
pabot --processes 5 --include Critical --exclude (FIX?) ADtests\*.robot
pabot --processes 4 --include Critical --exclude (FIX?) --outputdir Results ADtests\0*.robot
pabot --processes 3 --outputdir Results ADtests\0*.robot
pabot --processes 4 --outputdir Results --include Critical --exclude (FIX?) ADtests\*.robot


# JENKINS
---------
Steps to Install Jenkins on Windows:
1. Install Java Development Kit (JDK) - https://www.oracle.com/java/technologies/downloads/
2. Set the Path for the Environmental Variable for JDK - set path=C:\Program Files\Java\jdk1.6.0_23\bin and check it using cmd: java -version
3. Download and Install Jenkins - https://www.jenkins.io/download/

IMPORTANT: When installing a service to run under a domain user account, the account must have the right to logon as a service. This logon permission applies strictly to the local computer and must be granted in the Local Security Policy. Perform the following to edit the Local Security Policy of the computer you want to define the �logon as a service� permission:
Logon to the computer with administrative privileges.
Open the �Administrative Tools� and open the �Local Security Policy�
Expand �Local Policy� and click on �User Rights Assignment�
In the right pane, right-click �Log on as a service� and select properties.
Click on the �Add User or Group�� button to add the new user.
In the �Select Users or Groups� dialogue, find the user you wish to enter and click �OK�
Click �OK� in the �Log on as a service Properties� to save changes.
Then try again with the added user.

4. Run Jenkins on Localhost 8080 - at http://localhost:8080/script
5. Create project, configure Build and Run a Job on Jenkins

Run via CMD: services.msc - to see services list where Jenkins can be found after successful installation

To stop:
jenkins.exe stop

To start:
jenkins.exe start

To restart:
jenkins.exe restart

#### Jenkins TIPS:
To fix log issue run next command in Jenkins console:
************************************************************

System.setProperty("hudson.model.DirectoryBrowserSupport.CSP","sandbox allow-scripts; default-src 'none'; img-src 'self' data: ; style-src 'self' 'unsafe-inline' data: ; script-src 'self' 'unsafe-inline' 'unsafe-eval' ;")


To clear builds history run next command in Jenkins console:
****************************************************************

item = Jenkins.instance.getItemByFullName("your-job-name-here")
//THIS WILL REMOVE ALL BUILD HISTORY
item.builds.each() { build ->
  build.delete()
}
item.updateNextBuildNumber(1)

CRON - https://crontab.guru/
********************************************

0 12 * * 1 - �At 12:00 on Monday.�
H 0 */10 * * - �At 00:00 on every 10th day-of-month.�
H 12 * * 1-5 - �At every minute past hour 12 on every day-of-week from Monday through Friday.�
H * 12 * 1 - �At every minute past hour 12 on Monday.�
H 12 * * 1,3,5 - �At every minute past hour 12 on Monday, Wednesday, and Friday.�
H */24 * * * - �Once on every 24 hours�

#### Build details
Set 
1. GitHub project=YES; Project URL=https://github.com/Ok2015/CheckerRFTests.gi
2. This project is parameterized=YES; Name=TestURLS; DEFAULT=This project is parameterized
3. Source Code Management = GIT; Repository URL? = https://github.com/Ok2015/CheckerRFTests.git; Credentials?=PUT GITLAB CREDENTIALS HERE
4. Branches to build = */main
5. Build periodically = H 0 15 * *
6. Build Environment = Abort the build if it's stuck = Yes; Absolute = 300
7. Build: pabot --processes 2 --outputdir G:\Jenkins_Logs\Results-jenkins-chrome-checker-git --include Smoke -v Browser:chrome -v TestURLs:%TestURLs% ADtests\*.robot
8. Post-build Actions: Publish Robot Framework test results; Directory of Robot output = G:\Jenkins_Logs\Results-jenkins-chrome-checker-git
9. Post-build Actions: E-mail Notification (Jenkins Mailer Plugin)


If Build Problem 1 occurs: No files found in path with configured filemask: output.xml --> to fix manually copy log, report and output.xml into logfile folder
If Build Problem 2 occurs: ERROR: Couldn't find any revision to build. Verify the repository and branch configuration for this job --> check branch name that is used in GITLAB, usually it is */main (by default master in Jenkins)


#### Useful JENKINS plug-ins
1. Config AutoRefresh - Provide a way to configure the auto-refresh rate from the Jenkins UI. https://plugins.jenkins.io/config-autorefresh-plugin/
2. Restart Safely
3. Purge Builds History
4. Office 365 Connector
5. RobotFramework plugin
6. HTML Audio Notifier
7. Notify.Events


#### Useful CMD commands
Run --> systempropertiesadvanced - to see env variables
Run --> services.msc - to see services list
Run --> mstsc - to access remote PC