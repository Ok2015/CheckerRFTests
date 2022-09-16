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

*** Test Cases ***
Roles > create new role and edit access
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Create/update role.AD    ${RF role name}
    END
    Close Browser
    [Teardown]    Close Browser.AD

Types of QA stages > add QA stage
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    #Set Selenium speed    0.5
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${QAQ name2}    set variable    Stage 2 - Attachment validation [RF]
        ${QAQ name1}    set variable    Stage 1 - Spellcheck&content validation [RF]
        Set global variable    ${QAQ name2}
        Set global variable    ${QAQ name1}
        Log to console    Let`s add QA stage
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search QA stage.AD    ${QAQ name1}
        Search QA stage.AD    ${QAQ name2}
    END
    Close Browser
    [Teardown]    Close Browser.AD

Currencies > add RF currency
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    #Set Selenium speed    0.5
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${name}    set variable    RF points
        Set global variable    ${name}
        Log to console    Let`s add "${name}" as a currency
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search currency.AD    ${name}
    END
    Close Browser
    [Teardown]    Close Browser.AD

Edit credit card types > add RF credit card type
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    #Set Selenium speed    0.5
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${name}    set variable    Credit Account [RF]
        Set global variable    ${name}
        Log to console    Let`s add "${name}"
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Add record.AD    ${name}    Credit card for RF tests - Mod date: ${DD.MM.YY}    /settings-creditcard-types.php
    END
    Close Browser
    [Teardown]    Close Browser.AD

Edit bank names > add RF bank
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    #Set Selenium speed    0.5
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${name}    set variable    Auto Bank [RF]
        Set global variable    ${name}
        Log to console    Let`s add "${name}"
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Add record.AD    ${name}    RF Auto Bank - Mod date: ${DD.MM.YY}    /settings-bank-names.php
    END
    Close Browser
    [Teardown]    Close Browser.AD

Edit cash flow types > add cash flow types
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    #Set Selenium speed    0.5
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${name}    set variable    General visit cost [RF]
        Set global variable    ${name}
        Log to console    Let`s add "${name}"
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Add record.AD    ${name}    ${name} - Mod date: ${DD.MM.YY}    /cash-flow-types.php
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client cash flow types > add client cash flow types
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    #Set Selenium speed    0.5
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${name}    set variable    Payment to SP [RF]
        Set global variable    ${name}
        Log to console    Let`s add "${name}"
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Add record.AD    ${name}    Payments given to service provider - Mod date: ${DD.MM.YY}    /client-cash-flow-types.php
    END
    Close Browser
    [Teardown]    Close Browser.AD

Edit credit cards > add credit card
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    #Set Selenium speed    0.5
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${name}    set variable    00112233445566
        Set global variable    ${name}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Add record.AD    ${name}    Credit Card for Robot tests - Mod date: ${DD.MM.YY}    /settings-creditcards.php
    END
    Close Browser
    [Teardown]    Close Browser.AD

Special days definitions > add special day
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    #Set Selenium speed    0.5
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${name}    set variable    Special day [RF]
        Set global variable    ${name}
        Log to console    Let`s add "${name}"
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Add record(ID).AD    ${name}    /settings-special-days.php    01-01-2022
    END
    Close Browser
    [Teardown]    Close Browser.AD

Holidays definitions > add Holiday
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    #Set Selenium speed    0.5
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${name}    set variable    Holiday [RF]
        Set global variable    ${name}
        Log to console    Let`s add "${name}"
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Add record(ID).AD    ${name}    /settings-holidays.php    01-01-2022
    END
    Close Browser
    [Teardown]    Close Browser.AD

Alternative languages > add alt language
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${name1}    set variable    Robot language [RTL]
        ${name2}    set variable    Robot language [LTR]
        Set global variable    ${name1}
        Set global variable    ${name2}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}//alt-langs.php?page_var_filter_IsActive=&page_var_sorting_column=AltLangName&page_var_sorting_order=up&page_var_divide_recordsPerPage=500&page_var_divide_curPage=1
        Wait until page contains element    //button[@class='btn-input']
        ${element visible?}=    Run keyword and return status    Page should contain    ${name1}
        Run Keyword If    "${element visible?}"=="True"    Click link    default=${name1}
        Run Keyword If    "${element visible?}"=="False"    Click element    //button[@class='btn-input']
        Wait Until Page Contains element    //input[@id='field_AltLangName']
        Input text    //input[@id='field_AltLangName']    ${name1}
        Select dropdown.AD    //*[@id="idAltLangDirectionEditbox"]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'Right to left')]
        Set checkbox.AD    //input[@id='field_IsActive']    true
        Select dropdown.AD    //*[@id="idInterfaceLanguageEditbox"]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'English Australia')]
        Click Save/Add/Delete/Cancel button.AD
        Wait Until Page Contains    successfully
        go to.AD    ${URL}//alt-langs.php?page_var_filter_IsActive=&page_var_sorting_column=AltLangName&page_var_sorting_order=up&page_var_divide_recordsPerPage=500&page_var_divide_curPage=1
        Wait until page contains element    //button[@class='btn-input']
        ${element visible?}=    Run keyword and return status    Page should contain    ${name2}
        Run Keyword If    "${element visible?}"=="True"    Click link    default=${name2}
        Run Keyword If    "${element visible?}"=="False"    Click element    //button[@class='btn-input']
        Wait Until Page Contains element    //input[@id='field_AltLangName']
        Input text    //input[@id='field_AltLangName']    ${name2}
        Select dropdown.AD    //*[@id="idAltLangDirectionEditbox"]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'Left to right')]
        Set checkbox.AD    //input[@id='field_IsActive']    true
        Select dropdown.AD    //*[@id="idInterfaceLanguageEditbox"]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'English Australia')]
        Click Save/Add/Delete/Cancel button.AD
        Wait Until Page Contains    successfully
        GET alt lang ID.AD    ${name1}
        GET alt lang ID.AD    ${name2}
        Log to console    Added/updated 2 alt languages: "${name1}" and "${name2}"
    END
    Close Browser
    [Teardown]    Close Browser.AD
