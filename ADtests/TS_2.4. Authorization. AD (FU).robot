*** Settings ***
Suite Setup
Suite Teardown    Close All Browsers
Library           DateTime
Library           Collections
Library           RequestsLibrary
Library           OperatingSystem
Library           SeleniumLibrary
Library           ImapLibrary
Library           pabot.PabotLib
Resource          ${CURDIR}/Resources/CheckerLibUI.txt
Resource          ${CURDIR}/Resources/EDITORMSGs.txt
Resource          ${CURDIR}/Resources/Settings.txt

*** Test Cases ***
TC_004. Successful login/logout.AD
    [Tags]    Selfregis+Auth
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Check Log In page.AD
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Check Main Page.AD    ${URL}
        go to.AD    ${URL}/company-info.php
        Input text    //input[@id='field_DefaultExitAddress']    https://www.checker-soft.com/
        Click Save/Add/Delete/Cancel button.AD
        Wait Until Page Contains    Company information saved successfully
        Click element    //*[@id="menu_top_level"]/tbody/tr/td[19]/a
        ${Pageurl} =    Execute Javascript    return window.location.href
        Should be equal    ${Pageurl}    https://www.checker-soft.com/
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/company-info.php
        Input text    //input[@id='field_DefaultExitAddress']    ${empty}
        Click Save/Add/Delete/Cancel button.AD
        Wait Until Page Contains    Company information saved successfully
        Click element    //*[@id="menu_top_level"]/tbody/tr/td[19]/a
        ${Pageurl} =    Execute Javascript    return window.location.href
        Should be equal    ${Pageurl}    ${URL}/login.php?css=RobotAdminCSS.css&LangOverride=en_AU
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/company-info.php
        Input text    //input[@id='field_DefaultExitAddress']    ${URL}/login.php
        Click Save/Add/Delete/Cancel button.AD
        Wait Until Page Contains    Company information saved successfully
        Click element    //*[@id="menu_top_level"]/tbody/tr/td[19]/a
        ${Pageurl} =    Execute Javascript    return window.location.href
        Should be equal    ${Pageurl}    ${URL}/login.php
    END
    Close Browser
    [Teardown]    Close Browser.AD

Not successful login (wrong credentials).AD
    [Tags]    Selfregis+Auth
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Check Log In page.AD
        Log to console    Let`s try to log into system as manager using username="not registered username"and password "not registered password"
        Enter existing login and password.AD    not registered username    not registered password
        ${status1}    ${value1}=    Run Keyword And Ignore Error    Page Should Contain    has been blocked. Please contact the administrator () to unblock it.
        Run Keyword If    '${status1}'=='PASS'    Log to console    Result: has been blocked. Please contact the administrator () to unblock it.
        ${status2}    ${value2}=    Run Keyword And Ignore Error    Page Should Contain    You have used an invalid username and/or password.
        Run Keyword If    '${status2}'=='PASS'    Log to console    Result: You have used an invalid username and/or password.
    END
    Close Browser
    [Teardown]    Close Browser.AD

Not registered manager email tries to reset the password.AD
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
        Go to    ${URL}/login.php
        Log to console    Go to ${URL}/login.php and click reset password link
        Click element    //table[@id='side_menu']/tbody/tr/td[@class='middle-right']/div[@id='FiltersArea']/div/p[5]/a[3]
        Check default reset password elements.AD
        Log to console    Enter not registered email and submit form
        Wait until page contains element    //*[@id="side_menu"]/tbody/tr/td/div/form/table/tbody/tr[1]/td[2]/input
        Input text    //*[@id="side_menu"]/tbody/tr/td/div/form/table/tbody/tr[1]/td[2]/input    ${email}
        Click element    //*[@id="go"]
        Check default reset password elements.AD
        Page should contain    Details Mismatch
        Page should contain    The submitted user name or email address does not exist:
        Log to console    Page contains error text: "The submitted user name or email address does not exist" and "Details Mismatch"
    END
    Close Browser
    [Teardown]    Close Browser.AD
