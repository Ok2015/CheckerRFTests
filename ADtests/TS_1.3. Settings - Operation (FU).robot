*** Settings ***
Suite Setup
Suite Teardown    Close All Browsers
Library           DateTime
Library           Collections
Library           String
Library           pabot.PabotLib
Library           DateTime
Resource          ${CURDIR}/Resources/CheckerLibUI.txt
Resource          ${CURDIR}/Resources/EDITORMSGs.txt
Resource          ${CURDIR}/Resources/Settings.txt

*** Test Cases ***
Operational settings > Set Operation settings
    [Tags]    Editor    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Set Operation messages.AD
        Set Operation settings.AD
    END
    Close Browser
    [Teardown]    Close Browser.AD

Operation settings > Edit text messages. FU
    [Tags]    Editor    NotCritical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Edit text messages. AD
    END
    Close Browser
    [Teardown]    Close Browser.AD

Job board settings > Job panel columns are enabled
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Make visible Job columns.AD    true    on
        Set Job board settings.AD    true
    END
    Close Browser
    [Teardown]    Close Browser.AD

Shopper characteristics > create options and delete shopper property
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${Property name 1}    set variable    RF Property to be deleted by Robot - ${DD.MM.YY}
        Set global variable    ${Property name 1}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search shopper property.AD    ${Property name 1}    Option 1    Option 2
        Add/Update Shopper property.AD    ${Property name 1}    true    1    1=1    true    true    true    true    1
        Open registration page and check agreement box(es)
        Wait until page contains element    id=tr_prop${found ID}
        Element text should be    //tr[@id='tr_prop${found ID}']/td[@class='tedit-mandatory']/label/b    ${Property name 1}
        set focus to element    //*[@id="parentprop${found ID}"]/button
        ${class}=    Get Element Attribute    //*[@id="tr_prop${found ID}"]/td[1]    class
        Should Contain    ${class}    tedit-mandatory
        ${labels} =    Get List Items    id=prop${found ID}
        Log    ${labels}
        click element    //*[@id="parentprop${found ID}"]/button
        ${list}    Get value    //*[@id="tr_prop${found ID}"]
        #    Should be equal    ${list}    Option 1, Option 2, Other
        Element text should be    //div[2]/ul/li[1]/label    Option 1
        Element text should be    //div[2]/ul/li[2]/label    Option 2
        Element text should be    //div[2]/ul/li[3]/label    Other
        click element    //div[2]/ul/li[1]/label
        click element    //div[2]/ul/li[2]/label
        click element    //div[2]/ul/li[3]/label
        Page should not contain    //div[2]/ul/li[4]/label
        Element text should be    //*[@id="parentprop${found ID}"]/button/span[2]    Option 1, Option 2, Other
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Add/Update Shopper property.AD    ${Property name 1}    none    1    1=1    true    none    none    none    200
        Open registration page and check agreement box(es)
        Wait until page contains element    id=tr_prop${found ID}
        click element    //*[@id="parentprop${found ID}"]/button
        Element text should be    //div[2]/ul/li[1]/label    (Not selected)
        Element text should be    //div[2]/ul/li[2]/label    Option 1
        Element text should be    //div[2]/ul/li[3]/label    Option 2
        Page should not contain element    //div[2]/ul/li[4]/label
        click element    //div[2]/ul/li[2]/label
        Element text should be    //*[@id="parentprop${found ID}"]/button/span[2]    Option 1
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Add/Update Shopper property.AD    ${Property name 1}    none    1    1=2    true    true    true    true    20
        Open registration page and check agreement box(es)
        Element Should Not Be Visible    id=tr_prop${found ID}
        Delete SD property    ${Property name 1}
    END
    Close Browser
    [Teardown]    Close Browser.AD

Agreements > add agreement (Shoppers)
    [Tags]    Editor    NotCritical
    [Template]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${Agreement name}    Set variable    RF Agreement (required) [Shoppers]
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Enable shopper registration
        Enable shopper login
        Search agreement by name.AD    ${Agreement name}    ${AGREEMENT REQ}${RF REVN DT}
        go to.AD    ${URL}/c_register-new-checker.php?addnew=1
        Log to console    Let`s open registration page and check if agreement is visible
        Wait until page contains    ${Agreement name}
        Page should contain element    //form[@id='agreement']/div[@class='regCenterAgree']/div/div[1]
        Page should contain element    //input[@id='iAgree']
        Page should contain element    //a[@class='linkClass']
        Page should contain element    //a[@id='set-language']/span[@class='ui-button-text']
        Page should contain    ${Agreement name}
        Page should contain    The parties to this contract for services are
        Page should contain    who uses the site. The Mystery Shopper may only use the site in accordance with this Contract for Services. By accessing and using the site, the shopper accepts, without limitation or qualification, this Contract for Services. If the Mystery Shopper does not agree to these terms and conditions, they should not use the site.
        Page should contain    Checker Software, Inc
        Page should contain    RF REVN DT
        Log to console    Status: OK. The "${Agreement name}" agreement is seen on preregistration page!
    END
    Close Browser
    [Teardown]    Close Browser.AD

Agreements > add all types of agreement (optional)
    [Tags]    Editor    NotCritical
    [Template]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${Agreement name}    set variable    RF AGREEMENT (optional) [Shoppers]
        Set global variable    ${Agreement name}
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Enable shopper login
        Enable shopper registration
        Search agreement by name.AD    RF AGREEMENT (optional) [Users]    ${AGREEMENT OPT}${RF REVN DT}
        Search agreement by name.AD    RF AGREEMENT (optional) [Panelists]    ${AGREEMENT OPT}${RF REVN DT}
        Search agreement by name.AD    RF AGREEMENT (optional) [Survey subject]    ${AGREEMENT OPT}${RF REVN DT}
        Search agreement by name.AD    ${Agreement name}    ${AGREEMENT OPT}${RF REVN DT}
        go to.AD    ${URL}/c_register-new-checker.php?addnew=1
        Log to console    Let`s open registration page and check if agreement is visible
        Wait until page contains    ${Agreement name}
        Page should contain element    //form[@id='agreement']/div[@class='regCenterAgree']/div/div[1]
        Page should contain element    //input[@id='iAgree']
        Page should contain element    //a[@class='linkClass']
        Page should contain element    //a[@id='set-language']/span[@class='ui-button-text']
        Page should contain    ${Agreement name}
        Page should contain    The parties to this contract for services are
        Page should contain    who uses the site. The Mystery Shopper may only use the site in accordance with this Contract for Services. By accessing and using the site, the shopper accepts, without limitation or qualification, this Contract for Services. If the Mystery Shopper does not agree to these terms and conditions, they should not use the site............
        Page should contain    Checker Software, Inc
        Page should contain    ${DD.MM.YY}
        Page should contain    RF REVN DT
        Page should contain element    //input[@id='Agree${ReviewID}']
        Log to console    Status: OK. The "${Agreement name}" agreement is seen on preregistration page!
        Element text should be    //a[@class='linkClass']    Go back
        Page should contain element    //input[@id='iAgree']
        go to.AD    ${URL}/p_register-new-panelist.php?addnew=1
        Log to console    Let`s open registration page and check if agreement is visible
        Wait until page contains    RF AGREEMENT (optional) [Panelists]
        Wait until page contains    who uses the site. The Mystery Shopper may only use the site in accordance with this Contract for Services. By accessing and using the site, the shopper accepts, without limitation or qualification, this Contract for Services. If the Mystery Shopper does not agree to these terms and conditions, they should not use the site...........
        Wait until page contains    The parties to this contract for services are
        Wait until page contains    RF REVN DT:
        Wait until page contains    Please enter name and e-mail address here to accept agreements:
        Page should contain element    //input[@id='FullLegalName_fullname']
        Page should contain element    //input[@id='emailOnLegal']
        Page should contain element    //input[@id='iAgree']
        Wait until page contains    Panelist registration
    END
    Close Browser
    [Teardown]    Close Browser.AD

Agreements > add agreement and delete it
    [Tags]    NotCritical
    [Template]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${Agreement name}=    set variable    RF Agreement (to be deleted by RF)
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Search agreement by name.AD    ${Agreement name}    ${AGREEMENT OPT}
        go to.AD    ${URL}/company-agreements.php
        Page should contain    ${Agreement name}
        click link    default=${Agreement name}
        Wait until page contains element    //input[@id='delete']
        click element    //input[@id='delete']
        Wait until page contains element    //input[@id='sure_delete']
        click element    //input[@id='sure_delete']
        go to.AD    ${URL}/company-agreements.php
        Page should not contain    ${Agreement name}
        Log to console    "${Agreement name}" has been deleted
    END
    Close Browser
    [Teardown]    Close Browser.AD

Operation settings > Assessor display settings > Show columns in the "Scorecard history" screen
    [Tags]    NotCritical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Show these columns in the "Scorecard history" screen.AD    None
        Login as a Shopper
        go to.AD    ${URL}/c_crit-history.php
        Wait until page contains element    //*[@id="show"]
        click element    //*[@id="show"]
        Page should not contain    Review number
        Page should not contain    Finish time
        Page should not contain    Scorecard filling time
        Page should not contain    Client name
        Page should not contain    Short branch name
        Page should not contain    Questionnaire name
        #Page should not contain    Status
        Page should not contain    Score
        Page should not contain    Quality assurance grade, adjusted
        Page should not contain    Quality assurance done by user
        Page should not contain    Quality assurance note
        Page should not contain    Linked money sum
        Page should contain link    default=Main menu
        Log to console    ${URL}/c_crit-history.php does not contain disabled columns
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Show these columns in the "Scorecard history" screen.AD    true    # true - to enable, None - to disable
        Login as a Shopper
        go to.AD    ${URL}/c_crit-history.php
        Wait until page contains element    //*[@id="show"]
        click element    //*[@id="show"]
        Page should contain    Review number
        Page should contain    Finish time
        Page should contain    Review filling time
        Page should contain    Client name
        Page should contain    Short branch name
        Page should contain    Questionnaire name
        Page should contain    Result
        Page should contain    Status
        Page should contain    Quality assurance grade, adjusted
        Page should contain    Quality assurance done by user
        Page should contain    Quality assurance note
        Page should contain    Linked money sum
        Log to console    ${URL}/c_crit-history.php does contain enabled columns
        Page should contain link    default=Main menu
    END
    Close Browser
    [Teardown]    Close Browser.AD

Operation settings > Assessor display settings > Define default options for new assessors
    [Tags]    NotCritical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Log to console    CASE 1--------------------------
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Define default options for new assessors.AD    None
        go to.AD    ${URL}/company_shopper_reg.php
        Wait until page contains element    //*[@id="idAvoidDuplicatesFieldsEditbox"]/table/tbody/tr/td/span/button
        Select dropdown.AD    //*[@id="idPostRegistrationCertificationEditbox"]/table/tbody/tr/td/span/button    //div[3]/ul/li[1]/label
        Click element    //*[@id="idAvoidDuplicatesFieldsEditbox"]/table/tbody/tr/td/span/button
        Click element    //body/div[2]/div/ul/li[2]/a/span[2]
        Click Save/Add/Delete/Cancel button.AD
    #
        Register random shopper.SD
        Enter login and password.SD    RF-${random string}    RF-${random string}
        Enable agreements.SD
        go to.AD    ${URL}/c_main.php
        Page should contain    Welcome, RF-${random string}
        Page should not contain    Assigned orders
        Page should not contain    Show job board
        Page should not contain    Initiate review
        Page should not contain    Surveys selection
        #Page should not contain    Files library
        Page should not contain    Show questionnaire
        Page should not contain    Survey history
        Page should not contain    Personal refund report
        Page should not contain    Add refund record
        Page should not contain    Preferred regions
        Page should not contain    Edit personal information
        Page should not contain    You have completed
        Page should not contain    Edit work hours
        Page should contain link    default=Log off
        Log to console    User "RF-${random string}" can not see disabled menus
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Assessor self registration.AD
        Log to console    CASE 2--------------------------
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Define default options for new assessors.AD    true
        Register random shopper.SD
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Assessor self registration.AD
        Enter login and password.SD    RF-${random string}    RF-${random string}
        Enable agreements.SD
        go to.AD    ${URL}/c_main.php
        Page should contain    Welcome, RF-${random string}
        Page should contain    Assigned orders
        Page should contain    Show job board
        Page should contain    Initiate review
        Page should contain    Surveys selection
        Page should contain    Files library
        Page should contain    Show questionnaire
        Page should contain    Survey history
        Page should contain    Personal refund report
        Page should contain    Add refund record
        Page should contain    Preferred regions
        Page should contain    Edit personal information
        Page should contain    You have completed
        Page should contain    Edit work hours
        Page should contain link    default=Log off
        Log to console    User "RF-${random string}" can see enabled menus
    END
    Close Browser
    [Teardown]    Close Browser.AD

Operation settings > Assessor display settings > Allow assessor to modify these fields about himself
    [Tags]    NotCritical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Allow assessor to modify these fields about himself.AD    None
        Search shopper by AD    ${RobotTestShopper 02}
        Set shoppers settings.AD    None
        Login as a Shopper
        go to.AD    ${URL}/checkers.php?edit=y&auth_mode=2
        Page should not contain    Full name
        #Page should not contain    Password    ???
        Page should not contain    Picture
        Page should not contain    City
        Page should not contain    Address
        Page should not contain    House number
        Page should not contain    Postcode
        Page should not contain    Additional postcodes
        Page should not contain    Availability Radius
        #Page should not contain    Phone    ???
        Page should not contain    Day time phone (inc int. code)
        Page should not contain    Evening phone (inc int. code)
        Page should not contain    Phone for VOIP calls
        #Page should not contain    Email    ???
        Page should not contain    Birth date:
        Page should not contain    IdNumber
        Page should not contain    SSN
        Page should not contain    Skype
        #Page should not contain    ICQ    ???
        Page should not contain    Messenger
        Page should contain    you are not allowed to edit your info
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Allow assessor to modify these fields about himself.AD    true
        Search shopper by AD    ${RobotTestShopper 02}
        Set shoppers settings.AD    true
        Login as a Shopper
        go to    ${URL}/checkers.php?edit=y&auth_mode=2
        Log to console    Open ${URL}/checkers.php?edit=y&auth_mode=2 and check options
        Page should contain    Full name
        Page should contain    Password
        #Page should contain    City    ???
        Page should contain    Address
        Page should contain    House number
        Page should contain    Postcode
        Page should contain    Additional postcodes
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        Page should contain    Availability Radius
        Page should contain    Mobile (with country code)
        Page should contain    Evening phone (inc int. code)
        Page should contain    Day time phone (inc int. code)
        #Page should contain    Phone for VOIP calls    ???
        Page should contain    Email
        Page should contain    Birth date:
        Page should contain    IdNumber
        Page should contain    SSN
        #Page should contain    Skype    ???
        Page should contain    ICQ
        #Page should contain    Messenger    ???
        Page should contain link    default=Remove yourself from the system
        Page should contain element    //*[@id="save"]
        Page should contain link    default=Cancel
    END
    Close Browser
    [Teardown]    Close Browser.AD

Operation settings > Enable/Disable "Allow shopper self registration" hides a registration link on log in page. FU
    [Tags]    NotCritical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Disable shopper registration
        go to.AD    ${URL}/c_login.php
        Log to console    Open ${URL}/c_login.php
        Page should not contain element    xpath=//a[@href="c_register-new-checker.php?addnew=1"]
        Log to console    Page ${URL}/c_login.php does not contain "Shopper self registration" link
        Enable shopper registration
        go to.AD    ${URL}/c_login.php
        Log to console    Open ${URL}/c_login.php and check if "shoper registration" link is available
        Page should contain element    xpath=//a[@href="c_register-new-checker.php?addnew=1"]
        Log to console    "Shoper registration" link is available
    END
    Close Browser
    [Teardown]    Close Browser.AD

Quality assurance questions > add/delete questions and answers
    [Tags]    Critical    NotCritical
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    #Set Selenium speed    0.5
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${QAQ name1}    set variable    RF QAQ 01: Consistency of answers?
        ${QAQ name2}    set variable    RF QAQ 02: Quality of attachments?
        ${QAQ name3}    set variable    RF QAQ 03: "Will be deleted by Robot"
        ${QAQ answer1}    set variable    YES
        ${QAQ answer2}    set variable    NO
        ${QAQ answer3}    set variable    Low quality (or no attachments)
        ${QAQ answer4}    set variable    Average quality
        ${QAQ answer5}    set variable    High Quality
        ${QAQ answer6}    set variable    RF QAnswer: Will be deleted by Robot
        Set global variable    ${QAQ name1}
        Set global variable    ${QAQ name2}
        Set global variable    ${QAQ answer1}
        Set global variable    ${QAQ answer2}
        Set global variable    ${QAQ answer3}
        Set global variable    ${QAQ answer4}
        Set global variable    ${QAQ answer5}
        Set global variable    ${QAQ answer6}
        Set global variable    ${QAQ name3}
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Log to console    Let`s add QA question
        Search QA question.AD    ${QAQ name1}    ${QAQ name1}(Mod date: ${DD.MM.YY})
        Add QAQ answer.AD    ${QAQ answer1}    100    0    10
        Add QAQ answer.AD    ${QAQ answer2}    0    0    -10
        Search QA question.AD    ${QAQ name2}    ${QAQ name2}(Mod date: ${DD.MM.YY})
        Add QAQ answer.AD    ${QAQ answer3}    0    0    -10
        Add QAQ answer.AD    ${QAQ answer4}    0    0    0
        Add QAQ answer.AD    ${QAQ answer5}    100    0    +10
        Search QA question.AD    ${QAQ name3}    ${QAQ name3}(Mod date: ${DD.MM.YY})
        Add QAQ answer.AD    ${QAQ answer6}    100    0    10
        go to.AD    ${URL}/qa-answers.php?QaQuestionID=${QAQID}
        Log to console    Adding/Updating the answer
        Wait until page contains element    //button[@class='btn-input']
        Click link    default=${QAQ answer6}
        Click element    //input[@id='delete']
        Click element    //input[@id='sure_delete']
        Wait until page contains    Answer ${QAQ answer6} deleted successfully
        go to.AD    ${URL}/qa-questions.php?page_var_divide_recordsPerPage=600
        Log to console    ${URL}/qa-questions.php?page_var_divide_recordsPerPage=600
        Wait until page contains element    //button[@class='btn-input']
        Click link    default=${QAQ name3}
        Click element    //input[@id='delete']
        Click element    //input[@id='sure_delete']
        Wait until page contains    Question ${QAQ name3} deleted successfully
        Log to console    Question ${QAQ name3} has been deleted by Robot successfully
    END
    Close Browser
    [Teardown]    Close Browser.AD

Shoppers automatic notifications settings > Add notification. FU
    [Tags]    Editor    NotCritical
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}    Set variable    RF Order: M029 [Check AUTO SHOPPER NOTIFICATION ${DD.MM.YY}]
        Set global variable    ${test order description}
        ${Message title 1}    set variable    Reviews: assigned, awaiting acceptance [RF]
        ${Message title 2}    set variable    Reviews: accepted, awaiting implementation [RF]
        ${Message title 3}    set variable    Reviews: in progress [RF]
        ${Message to shopper 1}    set variable    <p>Dear $[202]$ $[212]$,</p> <p>We remind you that You have %s ${Message title 1}</p> <p>Please check it out at your&nbsp;<a href="${URL}/c_login.php"><span style="color:#000000">Personal Panel</span></a></p> <p>${RF REVN DT}</p>
        ${Message to shopper 2}    set variable    <p>Dear $[202]$ $[212]$,</p> <p>We remind you that You have %s ${Message title 2}</p> <p>Please check it out at your&nbsp;<a href="${URL}/c_login.php"><span style="color:#000000">Personal Panel</span></a></p> <p>${RF REVN DT}</p>
        ${Message to shopper 3}    set variable    <p>Dear $[202]$ $[212]$,</p> <p>We remind you that You have %s ${Message title 3}</p> <p>Please check it out at your&nbsp;<a href="${URL}/c_login.php"><span style="color:#000000">Personal Panel</span></a></p> <p>${RF REVN DT}</p>
        Set global variable    ${Message title 1}
        Set global variable    ${Message title 2}
        Set global variable    ${Message title 3}
    #
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Add shopper notification.AD    ${Message title 1}    ${Message to shopper 1}    /company-checker-automatic-notifications.php
        Add shopper notification.AD    ${Message title 2}    ${Message to shopper 2}    /company-checker-automatic-notifications.php
        Add shopper notification.AD    ${Message title 3}    ${Message to shopper 3}    /company-checker-automatic-notifications.php
        Add shopper notification.AD    Notif to be deleted [RF]    <p><span style="color:#e74c3c">MOD DATE: 18.11.2021,</p>    /company-checker-automatic-notifications.php
    #
        Create test order (MASS) - BASIC    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Assign order (via orders-management.php).AD    ${test order description}
        go to.AD    ${URL}/company-checker-automatic-notifications.php
        Get ID    id="table_rows"    ${Message title 1}    8    1
        Click element    //*[@id="table_rows"]/tbody/tr[${final index}]/td[8]/a
        Wait until page contains    Completed runnnig notification
        GMAIL: Check EMAIL.SD    ${Message title 1}    RF Shopper
        Login as a Shopper
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Check job details.SD
        Accept job
    #
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/company-checker-automatic-notifications.php
        Get ID    id="table_rows"    ${Message title 2}    8    1
        Click element    //*[@id="table_rows"]/tbody/tr[${final index}]/td[8]/a
        Wait until page contains    Completed runnnig notification
        GMAIL: Check EMAIL.SD    ${Message title 2}    RF Shopper
    #
        Login as a Shopper
        go to.AD    ${URL}/c_ordered-crits.php
        Wait until page contains    ${test order description}
        Click element    //tr[${index}]/td[${Begin scorecard ID}]/form/input[1]
        Wait until page contains element    //*[@id="begin"]
        Click element    //*[@id="begin"]
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/company-checker-automatic-notifications.php
        Get ID    id="table_rows"    ${Message title 3}    8    1
        Click element    //*[@id="table_rows"]/tbody/tr[${final index}]/td[8]/a
        Wait until page contains    Completed runnnig notification
        GMAIL: Check EMAIL.SD    ${Message title 3}    RF Shopper
    #
        Delete notification.AD    Notif to be deleted [RF]    /company-checker-automatic-notifications.php
    END
    Close Browser
    [Teardown]    Close Browser.AD

User automatic notifications settings > Add notification. FU
    [Tags]    Editor    NotCritical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${Message to shopper 1}    set variable    Customized message: $[201]$, $[214]$ Review: $[203]$ Finish time: $[311]$ Numeric finish time: $[313]$ ${RF REVN DT}
        ${Message to shopper 2}    set variable    <p>${RF REVN DT}</p>
        ${Message to shopper 3}    set variable    <p>${RF REVN DT}</p>
        ${Message to shopper 4}    set variable    <p>${RF REVN DT}</p>
        ${Message title 1}    set variable    Stages: E-mail [RF]
        ${Message title 2}    set variable    Stages: SMS [RF]
        ${Message title 3}    set variable    Stages: Approve scorecard [RF]
        ${Message title 4}    set variable    Stages: Disapprove scorecard [RF]
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Add user notification.AD    ${Message title 1}    ${Message to shopper 1}    /company-user-automatic-notifications.php
        Add user notification.AD    ${Message title 2}    ${Message to shopper 1}    /company-user-automatic-notifications.php
        Add user notification.AD    ${Message title 3}    ${Message to shopper 1}    /company-user-automatic-notifications.php
        Add user notification.AD    ${Message title 4}    ${Message to shopper 1}    /company-user-automatic-notifications.php
        Add user notification.AD    to be deleted [RF]    <p>${RF REVN DT}</p>    /company-user-automatic-notifications.php
        Delete notification.AD    to be deleted [RF]    /company-user-automatic-notifications.php
    END
    Close Browser
    [Teardown]    Close Browser.AD

Operation messages > Add message. FU
    [Tags]    Editor    NotCritical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${Message title 1}    set variable    Operation message [RF]
        Set global variable    ${Message title 1}
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/company-operation-messages.php
        Wait until page contains element    //button[@class='btn-input']
        ${1}=    Run keyword and return status    Page should contain    ${Message title 1}
        Run keyword if    "${1}"=="False"    Click element    //*[@id="big_tedit_wrapping_table"]/tbody/tr[1]/td/table/tbody/tr/td/button
        Run keyword if    "${1}"=="True"    Check if sorting is visible.AD    id="table_rows"
        Run keyword if    "${1}"=="True"    Get ID    id="table_rows"    ${Message title 1}    1    2
        Run keyword if    "${1}"=="True"    Click link    default=${found ID}
    ###
        sleep    1
        click element    //table/tbody/tr/td/table/tbody/tr[4]/td[2]/table/tbody/tr/td/span/button
        scroll element into view    xpath=//li[contains(.,'${ManagerUsername}')]
        sleep    2
        #Run keyword and ignore error    Click element    xpath=//li[contains(.,'${ManagerUsername}')]
        set focus to element    mru
        sleep    1
        Select From List By Label    mru    ${ManagerUsername}
        #Validate value (text)    //table/tbody/tr/td/table/tbody/tr[4]/td[2]/table/tbody/tr/td/span/button    ROBOT [MANAGER]
        click element    //input[@id='field_Title']
    ###
        Wait until element is visible    //table/tbody/tr/td/table/tbody/tr[6]/td[2]/table/tbody/tr/td/span/button
        click element    //table/tbody/tr/td/table/tbody/tr[6]/td[2]/table/tbody/tr/td/span/button
        scroll element into view    xpath=//li[contains(.,'Robot region 01')]
        Click element    //div[10]/div/ul/li[2]/a/span[2]
        Click element    xpath=//li[contains(.,'Robot region 01')]
        Validate value (text)    //table/tbody/tr/td/table/tbody/tr[6]/td[2]/table/tbody/tr/td/span/button    Robot region 01
        click element    //input[@id='field_Title']
    ##
        Input text    //input[@id='field_Title']    ${Message title 1}
        Wait until page contains element    //*[@id="idRejectedAssignmentsEditbox"]/table/tbody/tr/td/span/button
        click element    //*[@id="idRejectedAssignmentsEditbox"]/table/tbody/tr/td/span/button
        scroll element into view    xpath=//li[contains(.,'e-mail')]
        click element    xpath=//li[contains(.,'e-mail')]
        Validate value (text)    //*[@id="idRejectedAssignmentsEditbox"]/table/tbody/tr/td/span/button    e-mail
    ###
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        click element    //*[@id="idQANotificationsEditbox"]/table/tbody/tr/td/span/button
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        scroll element into view    xpath=//li[contains(.,'e-mail')]
        set focus to element    xpath=//li[contains(.,'e-mail')]
        click element    //div[4]/ul/li[2]/label
        Validate value (text)    //*[@id="idQANotificationsEditbox"]/table/tbody/tr/td/span/button    e-mail
    ###
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        click element    //*[@id="idCertificationNotificationsEditbox"]/table/tbody/tr/td/span/button
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        scroll element into view    xpath=//li[contains(.,'e-mail')]
        set focus to element    xpath=//li[contains(.,'e-mail')]
        click element    //div[6]/ul/li[2]/label/span
        Validate value (text)    //*[@id="idCertificationNotificationsEditbox"]/table/tbody/tr/td/span/button    e-mail
    ###
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        click element    //*[@id="idCompletedAssignmentsEditbox"]/table/tbody/tr/td/span/button
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        scroll element into view    xpath=//li[contains(.,'e-mail')]
        set focus to element    xpath=//li[contains(.,'e-mail')]
        click element    //div[3]/ul/li[2]/label
        Validate value (text)    //*[@id="idCompletedAssignmentsEditbox"]/table/tbody/tr/td/span/button    e-mail
    ###
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        click element    //*[@id="idRegistrationNotificationsEditbox"]/table/tbody/tr/td/span/button
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        scroll element into view    xpath=//li[contains(.,'e-mail')]
        set focus to element    xpath=//li[contains(.,'e-mail')]
        click element    //div[5]/ul/li[2]/label
        Validate value (text)    //*[@id="idRegistrationNotificationsEditbox"]/table/tbody/tr/td/span/button    e-mail
    ###
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        click element    //*[@id="idAcceptedOrdersEditbox"]/table/tbody/tr/td/span/button
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        scroll element into view    xpath=//li[contains(.,'e-mail')]
        set focus to element    xpath=//li[contains(.,'e-mail')]
        click element    //div[7]/ul/li[2]/label
        Validate value (text)    //*[@id="idAcceptedOrdersEditbox"]/table/tbody/tr/td/span/button    e-mail
    ###
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        click element    //*[@id="idJobBoardApplicationsEditbox"]/table/tbody/tr/td/span/button
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        scroll element into view    xpath=//li[contains(.,'e-mail')]
        set focus to element    xpath=//li[contains(.,'e-mail')]
        click element    //div[8]/ul/li[2]/label
        Validate value (text)    //*[@id="idJobBoardApplicationsEditbox"]/table/tbody/tr/td/span/button    e-mail
    ###
        Run Keyword If    ${check env?}    Enter editor text.AD    //*[@id="cke_57_label"]    ${OP Message to shopper}${RF REVN DT}
        Run Keyword If    '${check env?}'=='False'    Enter editor text.AD    //*[@id="cke_51_label"]    ${OP Message to shopper}${RF REVN DT}
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    successfully
        Log to console    "${Message title 1}" is created/updated. Reopening the page to validate the saved values
        Wait until page contains element    //button[@class='btn-input']
        ${1}=    Run keyword and return status    Page should contain    ${Message title 1}
        Run keyword if    "${1}"=="True"    Get ID    id="table_rows"    ${Message title 1}    1    2
    #
        go to.AD    ${URL}/company-operation-messages.php?edit=${found ID}
        Wait until page contains element    //input[@id='field_Title']
        Validate value (text)    //table/tbody/tr/td/table/tbody/tr[4]/td[2]/table/tbody/tr/td/span/button    ROBOT [MANAGER]
        Validate value (text)    //table/tbody/tr/td/table/tbody/tr[6]/td[2]/table/tbody/tr/td/span/button    Robot region 01
        Validate value (text)    //*[@id="idRejectedAssignmentsEditbox"]/table/tbody/tr/td/span/button    e-mail
        Validate value (text)    //*[@id="idJobBoardApplicationsEditbox"]/table/tbody/tr/td/span/button    e-mail
        Validate value (text)    //*[@id="idAcceptedOrdersEditbox"]/table/tbody/tr/td/span/button    e-mail
        Validate value (text)    //*[@id="idRegistrationNotificationsEditbox"]/table/tbody/tr/td/span/button    e-mail
        Validate value (text)    //*[@id="idCertificationNotificationsEditbox"]/table/tbody/tr/td/span/button    e-mail
        Validate value (text)    //*[@id="idCompletedAssignmentsEditbox"]/table/tbody/tr/td/span/button    e-mail
        Validate value (text)    //*[@id="idQANotificationsEditbox"]/table/tbody/tr/td/span/button    e-mail
        Log to console    "${Message title 1}" is validated=saved properly +
    END
    Close Browser
    [Teardown]    Close Browser.AD

Files > Add and delete user\shopper folder+file. FU
    [Tags]    Editor    NotCritical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Search user file.AD    /users-files.php?page_var_divide_recordsPerPage=500    Parent folder for users [RF]    Directory
        Search user file.AD    /users-files.php?DirectoryLink=${found ID}    Sub folder for users [RF]    Directory
        Search user file.AD    /users-files.php?DirectoryLink=${found ID}    File for users [RF]    File
        Search shopper file.AD    /checkers-files-settings.php?page_var_divide_recordsPerPage=500    Parent folder for shoppers [RF]    Directory
        Search shopper file.AD    /checkers-files-settings.php?ContainingFolderLink=${found ID}    Sub folder for shoppers [RF]    Directory
        Search shopper file.AD    /checkers-files-settings.php?ContainingFolderLink=${found ID}    File for shoppers 02 [RF]    File
        Search shopper file.AD    /checkers-files-settings.php?page_var_divide_recordsPerPage=500    File for shoppers 01 [RF]    File
        go to.AD    ${URL}/c_login.php
        Enter login and password.SD    ${RobotTestShopper 02}    ${RobotTestShopper 02}
        Enable agreements.SD
        go to.AD    ${URL}/c_file-library.php
        Wait until page contains    Files library
        Page should contain    Parent folder for shoppers [RF]
        Page should contain    File for shoppers 01 [RF]
        Page should contain    - for RF shoppers!!!
        Page should contain    RF REVN DT
        Click link    default=File for shoppers 01 [RF]
        Page should contain    -RF12.png
        go to.AD    ${URL}/c_file-library.php
        Wait until page contains    Files library
        Click link    default=Parent folder for shoppers [RF]
        Page should contain    - for RF shoppers!!!
        Click link    default=Sub folder for shoppers [RF]
        Click link    default=File for shoppers 02 [RF]
        Page should contain    -RF12.png
    #
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/checkers-files-settings.php?page_var_divide_recordsPerPage=500
        Click link    default=Parent folder for shoppers [RF]
        Wait until page contains element    //input[@id='delete']
        Click element    //input[@id='delete']
        Wait until page contains    Are you sure you want to erase the record Parent folder for shoppers [RF]?
        Click element    //input[@id='sure_delete']
        Wait until page contains    Item Parent folder for shoppers [RF] deleted successfully
        go to.AD    ${URL}/checkers-files-settings.php?page_var_divide_recordsPerPage=500
        Page should not contain    Parent folder for shoppers [RF]
        go to.AD    ${URL}/users-files.php?page_var_divide_recordsPerPage=500
        Get ID    id="table_rows"    Parent folder for users [RF]    1    2
        Click link    default=${found ID}
        Wait until page contains element    //input[@id='delete']
        Click element    //input[@id='delete']
        Wait until page contains    Are you sure you want to erase the record ${found ID}?
        Click element    //input[@id='sure_delete']
        Wait until page contains    Item ${found ID} deleted successfully
    #
        go to.AD    ${URL}/users-files.php?page_var_divide_recordsPerPage=500
        Page should not contain    Parent folder for users [RF]
        Click element    //*[@id="table_rows"]/tbody/tr[1]/td[1]/a
        Wait until page contains element    //input[@id='delete']
        Click element    //input[@id='delete']
        Wait until page contains    You are not authorized to delete this object
        Log to console    Status: PASS 1. Created folders for shoppers and users were deleted; 2. You are not authorized to delete this object is seen if try delete not allowed item (+)
    END
    Close Browser
    [Teardown]    Close Browser.AD
