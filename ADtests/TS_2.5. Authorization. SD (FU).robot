*** Settings ***
Suite Setup
Suite Teardown    Close All Browsers
Library           SeleniumLibrary
Library           pabot.PabotLib
Resource          ${CURDIR}/Resources/CheckerLibUI.txt
Resource          ${CURDIR}/Resources/EDITORMSGs.txt
Resource          ${CURDIR}/Resources/Settings.txt

*** Test Cases ***
Successful login (check text message).SD
    [Tags]    Selfregis+Auth
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Go to    ${URL}/c_login.php
        Log to console    Let`s try to log in as a shopper with not registered credentials...
        Enter login and password.SD    ${RobotTestShopper 02}    ${RobotTestShopper 02}
        go to.AD    ${URL}/c_main.php
        Check shopper message.SD
    END
    Close Browser
    [Teardown]    Close Browser.AD

Manager can disable/enable main menu elements for shopper.SD
    [Tags]    Selfregis+Auth
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Make visible Job columns.AD    None    on
        Set Job board settings.AD    None
        Define default options for new assessors.AD    None
        Search shopper by AD    ${RobotTestShopper 02}
        Get ID    id="checkers_table"    ${RobotTestShopper 02}    1    2
        Set shoppers settings.AD    none
        Cancel all order assignation
        Enter login and password.SD    ${RobotTestShopper 02}    ${RobotTestShopper 02}
        Enable agreements.SD
        go to.AD    ${URL}/c_main.php
        Page should contain    Welcome,
        #Page should not contain    Assigned orders    #fails because still find the term on page (even if hidden)
        Page should not contain    Show job board
        Page should not contain    Initiate review
        Page should not contain    Surveys selection
        #Page should not contain    Files library    #fails because still find the term on page (even if hidden)
        Page should not contain    Show questionnaire
        Page should not contain    Survey history
        Page should not contain    Personal refund report
        Page should not contain    Add refund record
        Page should not contain    Preferred regions
        Page should not contain    Edit personal information
        Page should not contain    You have completed
        Page should not contain    Edit work hours
        Page should contain    CheckerTificate
        Page should contain    Agreements
        Log to console    Shopper can not see main menu elements (only CheckerTificate and Agreements)
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Make visible Job columns.AD    true    on
        Set Job board settings.AD    true
        Search shopper by AD    ${RobotTestShopper 02}
        Set shoppers settings.AD    true
        Enter login and password.SD    ${RobotTestShopper 02}    ${RobotTestShopper 02}
        Enable agreements.SD
        go to.AD    ${URL}/c_main.php
        Page should contain    Welcome,
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
        Page should contain    CheckerTificate
        Page should contain    Agreements
        Check Shoppers Main Page page
        Log to console    Shopper can see main menu elements
    END
    Close Browser
    [Teardown]    Close Browser.AD

Not successful login (wrong credentials).SD
    [Tags]    Selfregis+Auth
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Go to    ${URL}/c_login.php
        Log to console    Let`s try to log in as a shopper with not registered credentials...
        Enter login and password.SD    Robot test shopper [01]    12
        Page should not contain    Orders
        Page should not contain    Assigned orders
        Page should not contain    Welcome,
        Check errors on page [-1]
        Log to console    Status: OK - shopper is not logged in
        ${status1}    ${value1}=    Run Keyword And Ignore Error    Page Should Contain    has been blocked. Please contact the administrator () to unblock it.
        Run Keyword If    '${status1}'=='PASS'    Log to console    Result: has been blocked. Please contact the administrator () to unblock it.
        ${status2}    ${value2}=    Run Keyword And Ignore Error    Page Should Contain    You have used an invalid username and/or password.
        Run Keyword If    '${status2}'=='PASS'    Log to console    Result: You have used an invalid username and/or password.
    END
    Close Browser
    [Teardown]    Close Browser.AD

Deactivated shopper can not login.SD
    [Tags]    Selfregis+Auth
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search shopper.AD
        Search shopper by AD    ${RobotTestShopper 02}
        go to    ${URL}/c_login.php
        Check LogIn page.SD
        Log To Console    ${\n}Login to account: username:${RobotTestShopper 01}/pass:${RobotTestShopper 01}
        Check errors on page [-1]
        Wait Until Page Contains Element    name=username
        Input Text    name=username    ${RobotTestShopper 01}
        Input Text    name=password    ${RobotTestShopper 01}
        Click Element    ${id=submit_button}
        Check errors on page [-1]
        Page should contain    You are inactive, and currently you can not log into the system. Please contact us by using the details at the bottom of the page.
        Log to console    Result: "${RobotTestShopper 01}" is inactive, and currently you can not log into the system.
        Check errors on page [-1]
        Search Element.AD    ${RobotTestShopper 01}    ${Checker Table ID}
        Log to console    Let`s activate the shopper
        Run Keyword If    ${ItemIsVisible}    Activate shopper
        ...    ELSE    Log to console    Shopper is not found in a system.
        Log To Console    ${\n}Login to account: username:${RobotTestShopper 01}/pass:${RobotTestShopper 01}
        Check errors on page [-1]
        go to    ${URL}/c_login.php
        Wait Until Page Contains Element    name=username
        Input Text    name=username    ${RobotTestShopper 01}
        Input Text    name=password    ${RobotTestShopper 01}
        Click Element    ${id=submit_button}
        Check errors on page [-1]
        Enable agreements.SD
        Wait Until Page Contains    Welcome,
    END
    Close Browser
    [Teardown]    Close Browser.AD

Shopper can not be deactivated due to assigned job(s).SD
    [Tags]    Selfregis+Auth
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}=    Set variable    Order: 023 To be canceled by a manager (RF: ${DD.MM.YY})
        Set global variable    ${test order description}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/company-display.php
        Input text    //input[@id='field_FractionDigitsToShow']    2
        Click Save/Add/Delete/Cancel button.AD
        Create test order (MASS) - BASIC    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Assign order (via orders-management.php).AD    ${test order description}
        Deactivate shopper.AD
        Cancel order assignation
    END
    Close Browser
    [Teardown]    Close Browser.AD

SD user can remove own profile.SD
    [Tags]    Selfregis+Auth
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search shopper by AD    ${RobotTestShopper 05}
        Search shopper by AD    ${RobotTestShopper 05}
        Get ID    id="checkers_table"    ${RobotTestShopper 05}    1    2
        Set shoppers settings.AD    true
        Go to    ${URL}/company-checker-disp.php
        Set checkbox.AD    //input[@id='field_CheckerSEF_Remove_me']    true
        Set checkbox.AD    //input[@id='field_CheckerCanDeletePersonalData']    true
        Set checkbox.AD    //input[@id='field_CheckerDEF_CanEditSelfInfo']    true
        Click element    //input[@id='save']
        Go to    ${URL}/c_login.php
        Check errors on page [-1]
        Check LogIn page.SD
        Enter login and password.SD    ${RobotTestShopper 05}    ${RobotTestShopper 05}
        Remove yourself from the system.SD
        Go to    ${URL}/c_login.php
        Check LogIn page.SD
        Enter login and password.SD    ${RobotTestShopper 05}    ${RobotTestShopper 05}
        ${status1}    ${value1}=    Run Keyword And Ignore Error    Page Should Contain    has been blocked. Please contact the administrator () to unblock it.
        Run Keyword If    '${status1}'=='PASS'    Log to console    Result: has been blocked. Please contact the administrator () to unblock it.
        ${status2}    ${value2}=    Run Keyword And Ignore Error    Page Should Contain    You have used an invalid username and/or password.
        Run Keyword If    '${status2}'=='PASS'    Log to console    Result: You have used an invalid username and/or password.
        Check errors on page [-1]
    END
    Close Browser
    [Teardown]    Close Browser.AD

SD user can not remove own profile.SD
    [Tags]    Selfregis+Auth
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search shopper by AD    ${RobotTestShopper 05}
        go to.AD    ${URL}/company-checker-disp.php
        Set checkbox.AD    //input[@id='field_CheckerSEF_Remove_me']    None
        Set checkbox.AD    //input[@id='field_CheckerCanDeletePersonalData']    None
        Set checkbox.AD    //input[@id='field_CheckerDEF_CanEditSelfInfo']    true
        Click Save/Add/Delete/Cancel button.AD
        go to.AD    ${URL}/company-display.php
        Set checkbox.AD    //input[@id='field_ShowCountriesInDD']    true
        Click Save/Add/Delete/Cancel button.AD
        go to.AD    ${URL}/c_login.php
        Check LogIn page.SD
        Enter login and password.SD    ${RobotTestShopper 05}    ${RobotTestShopper 05}
        Log To Console    Shopper can not see element //input[@id='remove']
        go to.AD    ${URL}/checkers.php?edit=y&auth_mode=2
        Page should contain    Edit personal information
        Page should not contain element    //input[@id='remove']
    END
    Close Browser
    [Teardown]    Close Browser.AD

Not registered shopper email tries to reset the password.SD
    [Tags]    Selfregis+Auth
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        ${email}=    Set variable    notregisteredemail@gmail.com
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Remove Captcha.AD
        Go to.AD    ${URL}/c_login.php
        Element text should be    //a[@class='linkClass'][1]    Forgot your password?
        Element text should be    //a[@class='linkClass'][3]    Forgot UserID?
        Log to console    Go to ${URL}/c_login.php and click reset password link
        Click link    //div[2]/form/p[1]/a[1]
        Check default reset password elements.SD
        Log to console    Enter not registered email (${email}) and submit form
        Wait until page contains element    //div[2]/form/table/tbody/tr/td[2]/input
        Input text    //div[2]/form/table/tbody/tr/td[2]/input    ${email}
        Click element    //*[@id="go"]
        Check default reset password elements.SD
        Page should contain    Details Mismatch
        Page should contain    The submitted user name or email address does not exist:
        Log to console    Page contains error text: "The submitted user name or email address does not exist" and "Details Mismatch"
    END
    Close Browser
    [Teardown]    Close Browser.AD

Registered shopper email resets the password.SD
    [Tags]    Selfregis+Auth
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        ${email}=    Set variable    robotmailbox01@gmail.com
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Allow assessor to modify these fields about himself.AD    true
        Remove Captcha.AD
        Go to.AD    ${URL}/c_login.php
        Element text should be    //a[@class='linkClass'][1]    Forgot your password?
        Element text should be    //a[@class='linkClass'][3]    Forgot UserID?
        Log to console    Go to ${URL}/c_login.php and click reset password link
        Click link    //div[2]/form/p[1]/a[1]
        Check default reset password elements.SD
        Log to console    Enter registered email (${email}) and submit form
        Wait until page contains element    //div[2]/form/table/tbody/tr/td[2]/input
        Input text    //div[2]/form/table/tbody/tr/td[2]/input    ${email}
        Click element    //*[@id="go"]
        Page should contain    Recover password
        Page should contain    Password reminder sent.
        Log to console    Password reminder reset and sent (+)
        Run Keyword If    '${check emails?}'=='False'    Log to console    Pls enable email check to test pass reset email (-)
        Run Keyword If    '${check emails?}'=='False'    Search profile.AD    ${RobotTestShopper 02}
        Run Keyword If    '${check emails?}'=='False'    Edit shopper profile.AD    ${RobotTestShopper 02}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Recover password.SD
    END
    Close Browser
    [Teardown]    Close Browser.AD

Shopper can recover UserID.SD
    [Tags]    CritSelfregis+Authical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Enable shopper registration
        Go to.AD    ${URL}/c_login.php
        Element text should be    //a[@class='linkClass'][3]    Forgot UserID?
        Log to console    "Forgot UserID?" link is visible (+)
        Click link    default=Forgot UserID?
        Wait until page contains element    //input[@id='submit']
        Wait until page contains    Recover your username
        Click element    //input[@id='submit']
        Element text should be    //form/table/tbody/tr[1]/td[1]    Email*
        Element text should be    //form/table/tbody/tr[2]/td[1]    Birthdate*
        Element text should be    //form/table/tbody/tr[3]/td[1]    Phone*
        Element text should be    //a[@class='linkClass']    Login again
        Fill in the recover form.SD    sdf    01-02-2022    234
        Wait until page contains    Enter a valid phone number minimum 10 digits
        Log to console    Response: "Enter a valid phone number minimum 10 digits" (+)
        Fill in the recover form.SD    sdf    01-02-2022    0546544565
        Wait until page contains    No matching user name found
        Log to console    Response: "No matching user name found" (+)
        Fill in the recover form.SD    RFChecker01Emailimported@gmail.com    01-01-10    1234567890
        Wait until page contains    System has duplicate accounts with the details that you entered. Contact Checker Software Systems LTD [${URLIndex} system] Email: info-${URL1index}-system@checker-soft.com, Phone: +972 4 622 81 49 to deactivate duplicate accounts.
        Log to console    Response: "System has duplicate accounts with the details that you entered. Contact Checker Software Systems LTD [TESTING system] Email: info-${URL1index}-system@checker-soft.com, Phone: +972 4 622 81 49 to deactivate duplicate accounts." (+)
        Fill in the recover form.SD    ${RFShopperEmail}    ${Shopper birthdate}    +380670118780
        Wait until page contains    User detail sent to email: ${RFShopperEmail}
        Log to console    Response: "User detail sent to email: ${RFShopperEmail}" (+)
        GMAIL: Recover UserID.SD
    END
    Close Browser
    [Teardown]    Close Browser.AD
