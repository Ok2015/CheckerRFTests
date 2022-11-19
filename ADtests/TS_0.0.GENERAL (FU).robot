*** Settings ***
Suite Setup
Suite Teardown    Close All Browsers
Library           SeleniumLibrary
Library           DateTime
Library           Collections
Library           String
Library           DateTime
Library           pabot.PabotLib
Resource          ${CURDIR}/Resources/CheckerLibUI.txt
Resource          ${CURDIR}/Resources/EDITORMSGs.txt
Resource          ${CURDIR}/Resources/Settings.txt
Library           RequestsLibrary
Library           Collections
Library           OpenPyxlLibrary

*** Test Cases ***
Update TRANSLATION
    [Tags]    Translation    Skip
    ${1}=    set variable    1
    @{urls}=    String.Split String    ${TestURLs}    ,    #    ${TestURLs}    ${TestURLs ALL systems}
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    ${loop length}=    Get length    ${urls}
    log TO CONSOLE    ${\n}Total test URL(s) number = "${loop length}"
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${userpass}=    set variable    n4i5ne9dfh3
        Run keyword if    '${URLIndex}'=='TESTING'    Change password
        Upload translation file    oksana    ${userpass}    # n4i5ne9dfh3    # oksana123456
        Run Keyword If    ${testing?} or ${preprod?} or ${demo?}    Check translation version.AD    21    32
        Run Keyword If    ${testing?} or ${preprod?} or ${demo?}    go to    ${URL}/c_login.php
        Run Keyword If    ${testing?} or ${preprod?} or ${demo?}    Wait Until Page Contains Element    name=username
        Run Keyword If    ${testing?} or ${preprod?} or ${demo?}    Input Text    name=username    ${RobotTestShopper 02}
        Run Keyword If    ${testing?} or ${preprod?} or ${demo?}    Input Text    name=password    ${RobotTestShopper 02}
        Run Keyword If    ${testing?} or ${preprod?} or ${demo?}    Click button    ${id=submit_button}
        Run Keyword If    ${testing?} or ${preprod?} or ${demo?}    Switch language.SD    21
        Run Keyword If    ${testing?} or ${preprod?} or ${demo?}    Check UI language box    21    32
    END
    Close Browser
    [Teardown]    Close Browser.AD

Check System Availability
    [Tags]    Skip    Availability
    [Timeout]    10 minutes    #timeout=10 minutes
    ${1}=    set variable    1
    @{urls}=    String.Split String    ${TestUrls-UpTime}    ,    #    ${TestURLs}    ${TestURLs ALL systems}
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    ${loop length}=    Get length    ${urls}
    log TO CONSOLE    ${\n}Total test URL(s) number = "${loop length}"
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        go to.AD    ${URL}/login.php
        Page should contain element    //input[@id='do_login']
        Log to console    ${URL} admin login form is available (+)
        #    go to.AD    ${URL}/c_login.php
        #    Page should contain element    //input[@id='do_login']
        #    Log to console    ${URL} shopper login form is available (+)
        ${1}=    evaluate    ${1}+1
    END
    Close Browser
    [Teardown]    Close Browser.AD

Check System Uptime
    [Tags]    Skip    Uptime
    [Timeout]    30 minutes
    ${1}=    set variable    1
    @{urls}=    String.Split String    ${TestUrls-UpTime}    ,    #    ${TestURLs}    ${TestURLs ALL systems}    ${TestUrls-UpTime}
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    ${loop length}=    Get length    ${urls}
    log TO CONSOLE    ${\n}Total test URL(s) number = "${loop length}"
    ${MM.DD.YY.Kyiv+Israel}    Get Current Date    result_format=%m.%d.%Y %H:%M
    ${MM.DD.YY.UTC}    Get Current Date    UTC    result_format=%H:%M
    ${MM.DD.YY.Japan}    Get Current Date    UTC    +9 hours    result_format=%H:%M
    ${MM.DD.YY.India}    Get Current Date    UTC    +5 hours 30 minutes    result_format=%H:%M
    ${start} =    Get Current Date
    log to console    ${MM.DD.YY.Kyiv+Israel} (Kyiv+Israel) ${MM.DD.YY.UTC} (UTC) ${MM.DD.YY.Japan} (Japan) ${MM.DD.YY.India} (India)
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        #    SET UP
        log to console    --- System №${1}: ${URL}
        Check System UP-Time    /login.php    SystemUPTime (08.2022).xlsx    ${1}    1    # № of sheet
        Check System UP-Time    /c_login.php    SystemUPTime (08.2022).xlsx    ${1}    2    # № of sheet
        ${1}=    evaluate    ${1}+1
        Log    UpTime: "${Dictionary}"
    END
    Close Browser
    [Teardown]    Close Browser.AD

DEMO TEST
    [Tags]    DEMO    Skip
    #Set Selenium speed    0.5
    ${1}=    set variable    1
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    https://www.checker-soft.com/    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    Run keyword if    1==2    Log to console    the secret message
    ...    ELSE    Log to console    not secret message
    ${loop length}=    Get length    ${urls}
    log    ${\n}Total test URL(s) number = "${loop length}"
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Wait Until Page Contains Element    //span[@class='elementor-button-text']
        Element text should be    //span[@class='elementor-button-text']    REQUEST A DEMO
        ${text}    get text    //*[@id="main"]/div/div/div/section[1]/div[2]/div/div[1]/div/div/div[1]/div/h1
        Log to console    I am a DEMO test :)
        Log to console    --- Task:${\n}1. Open URL = "https://www.checker-soft.com/" using browser="${BROWSER}" ${\n}2. Check if button title text is //span[@class='elementor-button-text'] === "REQUEST A DEMO" ?${\n}3. Get H1 text from page
        Log to console    --- Results:${\n}1. (+);${\n}2. Element text is //span[@class='elementor-button-text'] === "REQUEST A DEMO";${\n}3. H1 text = "${text}"
    END
    Close Browser
    [Teardown]    Close Browser.AD
