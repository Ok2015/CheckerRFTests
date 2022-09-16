*** Settings ***
Suite Setup
Suite Teardown    Close All Browsers
Library           SeleniumLibrary
Library           DateTime
Library           pabot.PabotLib
Resource          ${CURDIR}/Resources/CheckerLibUI.txt
Resource          ${CURDIR}/Resources/EDITORMSGs.txt
Resource          ${CURDIR}/Resources/Settings.txt

*** Test Cases ***
TC_0001. Check creation of Manager user (edit profile)
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD
        Search user profile.AD    ${ManagerUsername}    Manager
    #
        go to.AD    ${URL}/users-generate-token.php?UserID=${found ID}
        go to    ${URL}/user-to-assignee.php?UserID=${found ID}
        go to.AD    ${URL}/users-restricted-columns.php?UserID=${found ID}
    #
        Add quick link.AD    MY PROFILE    ${URL}/users.php?edit=${found ID}&calledUsingJsFromPage=clients.php?edit=${client ID}    Edit user    Header    1
        Add quick link.AD    AUTO 01 [RF CLIENT]    ${URL}/clients.php?_&edit=${client ID}    Edit clients    Header    2
        Add quick link.AD    MY CLIENT    ${URL}/clients.php?_&edit=${client ID}    Edit clients    Main menu    3
        Add quick link.AD    RF INTERNET SURVEY(s)    ${URL}/internet-surveys.php?page_var_divide_recordsPerPage=100&page_var_divide_curPage=1&page_var_sorting_column=SurveyName&page_var_sorting_order=up&page_var_filter_IsActive=1&page_var_filter_ClientLink=${client ID}    Internet surveys    Header    4
        Add quick link.AD    HANDLE R    ${URL}/crit-handling-details.php?CritID=111111    Handle finished reviews    Header    5
        Add quick link.AD    RF ALERTS    ${URL}/alerts.php?ClientID=${client ID}    Alerts    Main menu    6
        Add quick link.AD    Edit    ${URL}/user-quick-links.php?UserID=${found ID}    Special permissions    Header    6
    END
    Close Browser
    [Teardown]    Close Browser.AD

TC_0002. Check creation of Analyst user (create new + edit profile)
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD
        Search user profile.AD    ${RobotAnalystUser 01}    Analyst
        Edit branch access
        go to.AD    ${URL}/login.php
        Enter existing login and password.AD    ${RobotAnalystUser 01}    ${RobotAnalystUser 01}
        go to.AD    ${URL}/main-menu.php
        Log To Console    Login to ${URL}/main-menu.php as "Analyst" user
        sleep    1
        Page should contain    Welcome, ${RobotAnalystUser 01}!
        Page should contain    Message to
        Page should contain    Analysts
        Page should contain    goes here
        #    Page should contain    ENV/SYS:
        #    Page should contain    RF REVN DT
        Page should contain element    //table[@id='menu_top_level']/tbody/tr/td[@class='top_menu'][1]
        Page should contain element    //table[@id='menu_top_level']/tbody/tr/td[@class='top_menu'][2]
        Page should contain element    //table[@id='menu_top_level']/tbody/tr/td[@class='top_menu'][3]
        #Page should contain element    //a[@id='setting_link']
        Log To Console    Page contains text: "Welcome, ${RobotAnalystUser 01}" and text message
    #Reports: Final scores analysis
    END
    Close Browser
    [Teardown]    Close Browser.AD

TC_0003. Check creation of SP user (test role and its permissions)
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${RF role}    Set variable    RF ROLE 01
        Set global variable    ${RF role}
        Search Client.AD
        Create/update role.AD    ${RF role}
        Search user profile.AD    ${RobotSPUser 01}    Special permissions
    #
        Go to2.AD    ${URL}/crits-handling.php
        Wait until page contains    Handle finished reviews
        Input text    //input[@id='rangeStart']    ${date minus 30 days}
        Select dropdown.AD    //*[@id="side_menu"]/tbody/tr/td[3]/form/table/tbody/tr[1]/td[3]/table/tbody/tr/td/span/button/span[2]    xpath=//li[contains(.,'${RobotTestClient}')]
        Click element    //input[@id='show']
        ${Review ID}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[2]/a[1]
    #
        Run keyword if    ${testing?}    Log To Console    Let`s log in using credentials of a SP user
        Run keyword if    ${testing?}    Enter existing login and password.AD    ${RobotSPUser 01}    ${RobotSPUser 01}
        Run keyword if    ${testing?}    Page should contain    Welcome, ${RobotSPUser 01}!
        Run keyword if    ${testing?}    Page should contain    Message to RF ROLE goes here
        Run keyword if    ${testing?}    Page should contain element    //a[@id='set-language']/span[@class='ui-button-text']
        Run keyword if    ${testing?}    Page should contain element    //a[@class='MainMenuLink']
        Run keyword if    ${testing?}    Page should contain element    //tr[@class='titleInsideMain']/td[@class='insideMain']
        Run keyword if    ${testing?}    Log To Console    Page contains text: "Welcome, ${RobotSPUser 01}!"
        Run keyword if    ${testing?}    Log To Console    Access for LOGIN and MAIN MENU is working properly
        Run keyword if    ${testing?}    go to2.AD    ${URL}/client-visit-reports.php?__t=1649154454&ClientID=${client ID}&page_var_sorting_column=VisitReportName&page_var_sorting_order=up&page_var_divide_recordsPerPage=100&page_var_divide_curPage=1
        Run keyword if    ${testing?}    Wait until page contains    Visit report templates
        Run keyword if    ${testing?}    Wait until page contains    Client name: ${RobotTestClient}    # fails here on preprod
        Run keyword if    ${testing?}    Wait until page contains    ${RF visit template}
        Run keyword if    ${testing?}    Click link    default=${RF visit template}
        Run keyword if    ${testing?}    Wait until page contains    Template name
        Run keyword if    ${testing?}    Wait until page contains    Download the template file
        Run keyword if    ${testing?}    Wait until page contains    Download
        Run keyword if    ${testing?}    Click link    default=Download
        Run keyword if    ${testing?}    Check errors on page [-1]
        Run keyword if    ${testing?}    go to2.AD    ${URL}/edit-multiple-orders.php?OrderIDs=${Review ID}
        Run keyword if    ${testing?}    Wait until page contains    Edit multiple orders
        Run keyword if    ${testing?}    Wait until page contains    Important: this is the order of actions:
    #
        Run keyword if    ${testing?}    Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Run keyword if    ${testing?}    Set role permissions.AD    0
        Run keyword if    ${testing?}    Log To Console    Let`s log in using credentials of a SP user
        Run keyword if    ${testing?}    Click link    default=Log off
        Run keyword if    ${testing?}    Wait until page contains element    //input[@id='do_login']
        Run keyword if    ${testing?}    close browser
        Run keyword if    ${testing?}    SeleniumLibrary.Open Browser    ${URL}    browser=${BROWSER}
        Run keyword if    ${testing?}    Wait Until Page Contains Element    ${id=login_email}
        Run keyword if    ${testing?}    Input Text    ${id=login_email}    ${RobotSPUser 01}
        Run keyword if    ${testing?}    Input Text    ${id=login_password}    ${RobotSPUser 01}
        Run keyword if    ${testing?}    Click Element    ${id=submit_button}
        Run keyword if    ${testing?}    Wait Until Page Contains    Session error
        Run keyword if    ${testing?}    Page should contain    ${RobotSPUser 01}: Access is blocked
        Run keyword if    ${testing?}    Page should contain    For authorization to this screen, please contact
        Run keyword if    ${testing?}    Page should contain    Page name: Main menu
        Run keyword if    ${testing?}    Log To Console    User is not logged in. Page contains text: "Session error. ${RobotSPUser 01}: Access is blocked'
        Run keyword if    ${testing?}    Go to    ${URL}/operation-panel.php
        Run keyword if    ${testing?}    Wait until page contains    ${RobotSPUser 01}: Access is blocked
        Run keyword if    ${testing?}    Wait until page contains    Page name: Operation panel
        Run keyword if    ${testing?}    Wait until page contains    Session error
        Run keyword if    ${testing?}    Go to    ${URL}/edit-multiple-orders.php?OrderIDs=${Review ID}
        Run keyword if    ${testing?}    Wait until page contains    ${RobotSPUser 01}: Access is blocked
        Run keyword if    ${testing?}    Wait until page contains    Page name: Edit multiple orders
        Run keyword if    ${testing?}    Go to    ${URL}/client-visit-reports.php?__t=1649154454&ClientID=${client ID}&page_var_sorting_column=VisitReportName&page_var_sorting_order=up&page_var_divide_recordsPerPage=100&page_var_divide_curPage=1
        Run keyword if    ${testing?}    Wait until page contains    Page name: Visit report templates
        Run keyword if    ${testing?}    Wait until page contains    ${RobotSPUser 01}: Access is blocked
        Run keyword if    ${testing?}    Wait until page contains    Session error
    END
    Close Browser
    [Teardown]    Close Browser.AD

Analyst User (create report category and delete)
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Set Records per page    300    # set number of records on page here
        Enter existing login and password.AD    ${RobotAnalystUser 01}    ${RobotAnalystUser 01}
        Create category (reports)    Final score report    Final score category (TABLE)
        #Create category (reports)    Question comparison report    Question comparison category (TABLE)
        #Create category (reports)    Characteristics breakdown report    Characteristics category (TABLE)
        #Create category (reports)    Performance score filter report    Performance score filter category (TABLE)
        #Create category (reports)    Goals achievement report    Goals achievement category (TABLE)
        #Create category (reports)    Goals achievement - by characteristic report    Goals achievement - by characteristic category (TABLE)
        #Create category (reports)    Combined report    Combined category (TABLE)
        #Create category (reports)    Point of sale analysis report    Point of sale analysis category (TABLE)
        #Create category (reports)    Client action summary report    Client action summary category (TABLE)
        #Create category (reports)    Branch relative position report    Branch relative position category (TABLE)
        #Create category (reports)    Sub-section comparison report    Sub-section comparison category (TABLE)
        #Create category (reports)    Answers frequencies report    Answers frequencies category (TABLE)
        #Create category (reports)    Grade by question report    Grade by question category (TABLE)
        #Create category (reports)    Performance index report    Performance index category (TABLE)
        #Create category (reports)    Goals achievement – new report    Goals achievement – new category (TABLE)
        #Create category (reports)    Performance levels report    Performance levels category (TABLE)
        #Create category (reports)    Question passing rate report    Question passing rate category (TABLE)
        #Create category (reports)    Product questions report    Product questions category (TABLE)
        #Create category (reports)    Client comments management report    Client comments management category (TABLE)
        #Create category (reports)    Sections analysis report    Sections analysis category (TABLE)
        #Create category (reports)    Branch cross-tabulation report    Branch cross-tabulation category (TABLE)
        #Create category (reports)    Report investigator report    Report investigator category (TABLE)
        #Create category (reports)    Questions cross-reference report    Questions cross-reference category (TABLE)
        #Create category (reports)    Show scorecard/order by reference number report    Show scorecard/order by reference number category (TABLE)
        #Create category (reports)    Branch goal achievement - per question report    Branch goal achievement - per question category (TABLE)
        #Create category (reports)    Questions groups report    Questions groups category (TABLE)
        #Create category (reports)    Survey status report report    Survey status report category (TABLE)
        #Create category (reports)    Client actions report    Client actions category (TABLE)
        Delete all report(s)
        Delete all report categories
    END
    Close Browser
    [Teardown]    Close Browser.AD

Analyst User (create reports)
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${RobotAnalystUser 01}    ${RobotAnalystUser 01}
        Delete all report(s)
        Delete all report categories
        Reports: Final scores analysis    Final score report    Final score category (TABLE)
    END
    Close Browser
    [Teardown]    Close Browser.AD
