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
Reports. Check report page elements
    [Tags]    Report
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
    #    Final score report: check elements
        Reports: Final score - chart
    END
    Close Browser
    [Teardown]    Close Browser.AD

Finall score report. Compare report values vs OP
    [Tags]    Report
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Grab values from OP
        Reports: Final score - table
        Reports: Final score - chart
    END
    Close Browser
    [Teardown]    Close Browser.AD
