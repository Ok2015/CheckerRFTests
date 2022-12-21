*** Settings ***
Suite Setup
Suite Teardown
Library           ExcelLibrary
Library           openpyxl
Library           DateTime
Library           SeleniumLibrary
Library           xlrd
Library           xlwt
Library           OperatingSystem
Library           robot.api.logger
Library           pabot.PabotLib
Resource          ${CURDIR}/Resources/CheckerLibUI.txt
Resource          ${CURDIR}/Resources/EDITORMSGs.txt
Resource          ${CURDIR}/Resources/Settings.txt
Library           OpenPyxlLibrary

*** Test Cases ***
Custom export: check header with hidden columns (EXCEL2007)
    [Tags]    Export
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        Prepare download folder.AD
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search the Q-ry (via search bar).AD    ${RobotQ-ry SHOPPERS}
        Get question ID
        Search Client.AD    ${RobotTestClient}
        ${RF custom profile name}    set variable    RF.CustomExport
        set global variable    ${RF custom profile name}
        ${RF export file name}    set variable    RF.CExport_without_2_header_columns[${URLIndex}]
        set global variable    ${RF export file name}
        Search CE profile.AD
        Edit CE profile.AD    ${RobotQ-ry SHOPPERS}    1    excel2007    ${RF export file name}    Name    Reviews    ;
        Edit Column Settings.AD    CritID    true    0
        Edit Column Settings.AD    Result    None    1
        Edit Column Settings.AD    FinishTime    None    2
        Perform custom export and download file    True    True    ${DD.MM.YY}    ${DD.MM.YY}
        Excel: process file.AD    ${CURDIR}\\Resources\\Downloads\\${RF export file name}.xlsx    Worksheet    2
        Dictionary Should Not Contain Key    ${Dictionary}    Result
        Dictionary Should Not Contain Key    ${Dictionary}    FinishTime
        Dictionary Should Contain Key    ${Dictionary}    CritID    msg=CritID is not found
        Log to console    Test Result: OK (+)
        Log to console    Dictionary does Not Contain Keys: "Result" and "FinishTime"
        Log to console    Dictionary does Not Contain Key: "CritID"
    END
    Close all browsers
    [Teardown]    Enable required columns.AD

Custom export: Base of export=Reviews (EXCEL2007) check file only
    [Tags]    Export
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        Prepare download folder.AD
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search the Q-ry (via search bar).AD    ${RobotQ-ry SHOPPERS}
        Get question ID
        Search Client.AD    ${RobotTestClient}
        ${RF custom profile name}    set variable
        set global variable    ${RF custom profile name}    RF.CustomExport
        ${RF export file name}    set variable    RF.CustomExport(BaseOfExport=Reviews)[${URLIndex}]
        set global variable    ${RF export file name}
        Search CE profile.AD
        Edit CE profile.AD    ${RobotQ-ry SHOPPERS}    1    excel2007    ${RF export file name}    Name    Reviews    ;;
        Perform custom export and download file    True    True    ${DD.MM.YY}    ${DD.MM.YY}
        Excel: process file.AD    C:\\Python27\\ROBOT_TESTS\\RobotTests2022\\ADtests\\Resources\\Downloads\\${RF export file name}.xlsx    Worksheet    2
        Check file HEADER.AD    ${RF export file name}
        Check REVIEW data.AD
        Run Keyword And Ignore Error    Empty Directory    ${global_downloadDir}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: check export file email.AD
    END
    close all browsers
    [Teardown]    Close Browser.AD

Custom export: Base of export=Reviews (EXCEL2007) compare data with sys pages
    [Tags]    Export
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        Prepare download folder.AD
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/company-display.php
        Wait Until Page Contains Element    //input[@id='field_ShowWeights']
        Set checkbox.AD    //input[@id='field_ShowWeights']    true
        Set checkbox.AD    //input[@id='field_ShowCheckerNames']    true
        Set checkbox.AD    //input[@id='field_ShowCountriesInDD']    true
        Click Save/Add/Delete/Cancel button.AD
        Wait Until Page Contains    Display settings saved successfully
    #
        Search the Q-ry (via search bar).AD    RF Questionnaire [Shoppers]
        Get question ID
        Search Client.AD    ${RobotTestClient}
        ${RF custom profile name}    set variable
        set global variable    ${RF custom profile name}    RF.CustomExport
        ${RF export file name}    set variable    RF.CustomExport(BaseOfExport=Reviews)[${URLIndex}]
        set global variable    ${RF export file name}
        Search CE profile.AD
        Edit CE profile.AD    ${RobotQ-ry SHOPPERS}    1    excel2007    ${RF export file name}    Name    Reviews    ;
        Perform custom export and download file    True    True    ${date minus 1 day}    ${DD.MM.YY}
        Excel: process file.AD    ${CURDIR}\\Resources\\Downloads\\${RF export file name}.xlsx    Worksheet    2
        GET CF IDS.AD
        Compare REVIEW (full report and code pages) and CE file.AD
        Compare SHOPPER and CE file.AD
        Compare CLIENT and CE file.AD
        Compare BRANCH and CE file.AD
    END
    close all browsers
    [Teardown]    Close Browser.AD

draft
    [Tags]    Export    (FIX?)    SKIP
    [Setup]
    ${numeric value}    Get Substring    Numeric review start time: 1658908999    -10
    Should Match Regexp    ${numeric value}    \\d{10}
    Log to console    ${numeric value}
    ${matches}=    get regexp matches    Numeric review start time: 1658908999    \\d{5}
    Should Match Regexp    1234567890    \\d{5}
    Log to console    ----> ${matches}
    ${numeric value}    Get Regexp Matches    Numeric review start time: 1658908999 івпвапвапвапвап    Numeric review start time: \\d{5}
    Log to console    ${numeric value}
    ${string1}=    Set variable    Robot 02 [Full Name] (Robot 02 [Short Name]) p:100
    @{Shopper full name}    split string    ${string1}    (
    Log to console    Shopper full name: ${Shopper full name}[0]
    ${Shopper short name}    Fetch From Left    ${Shopper full name}[1]    )
    Log to console    Shopper short name: ${Shopper short name}
    [Teardown]    Close Browser.AD
