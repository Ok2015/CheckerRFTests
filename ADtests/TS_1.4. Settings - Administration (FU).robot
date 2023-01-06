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
    [Tags]    Administration
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
    [Tags]    Administration
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
    [Tags]    Administration
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
    [Tags]    Administration
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
        Add record.AD    ${name}    Credit card for RF tests    /settings-creditcard-types.php
    END
    Close Browser
    [Teardown]    Close Browser.AD

Edit bank names > add RF bank and delete it (Manual)
    [Tags]    Administration
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    #Set Selenium speed    0.5
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${bank_name}    set variable    RF BANK (M)
        ${bank_code}    set variable    RFBC-02
        Set global variable    ${bank_name}
        Set global variable    ${bank_code}
        ${bank_br_name}    set variable    RF Branch Name
        ${bank_br_code}    set variable    RFBrCode
        Set global variable    ${bank_br_name}
        Set global variable    ${bank_br_code}
        Log to console    Let`s create "${bank_name}" bank
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Enable NewShopperInt.AD    None
        #    Run Keyword If    ${preprod?}    Exit forloop
        Add/update bank.AD    ${bank_name}    ${bank_code}    /settings-bank-names.php
        Search profile.AD    ${RobotTestShopper 02}
        Assign bank.AD    ${RobotTestShopper 02}    ${bank_name}-${bank_code}    ${bank_br_name}-01-${bank_br_code}-01
        Delete bank.AD    ${bank_name}    ${bank_code}    Cannot delete:
        Assign bank.AD    ${RobotTestShopper 02}    (SelectBank)    (SelectBank)
    # CASE 2 [SHOPPER SIDE]
        Enter login and password.SD    ${RobotTestShopper 02}    ${RobotTestShopper 02}
        go to.AD    ${URL}/checkers.php?edit=y&auth_mode=2
        Wait until page contains element    //select[@id='BankLink']
        Select dropdown.AD    //select[@id='BankLink']    xpath=//option[contains(.,'${bank_name}-${bank_code}')]
        Validate value (value)    //select[@id='BankLink']    ${Bank ID}
        Select dropdown.AD    //select[@id='BankBranchLink']    xpath=//option[contains(.,'${bank_br_name}-01-${bank_br_code}-01')]
        Validate value (value)    //select[@id='BankBranchLink']    ${Bank Branch ID}
        Click button    //*[@id="save"]
        go to.AD    ${URL}/checkers.php?edit=y&auth_mode=2
        Validate value (value)    //select[@id='BankLink']    ${Bank ID}
        Validate value (value)    //select[@id='BankBranchLink']    ${Bank Branch ID}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/settings-branch-names.php?BankTypeID=${found ID}
        Click link    default=${bank_br_code}-01
        Wait until page contains element    //input[@id='delete']
        Click element    //input[@id='delete']
        Wait until page contains    Cannot delete:
        Wait until page contains    The characteristic is associated with the following shoppers:
        Wait until page contains    ${RobotTestShopper 02}
        Delete bank.AD    ${bank_name}    ${bank_code}    Cannot delete:
        Log to console    Status: OK - Can not delete assigned bank + bank branch (+)
    #
        Enter login and password.SD    ${RobotTestShopper 02}    ${RobotTestShopper 02}
        go to.AD    ${URL}/checkers.php?edit=y&auth_mode=2
        Wait until page contains element    //select[@id='BankLink']
        Select dropdown.AD    //select[@id='BankLink']    xpath=//option[contains(.,'(SelectBank)')]
        Validate value (value)    //select[@id='BankLink']    ${empty}
        Select dropdown.AD    //select[@id='BankBranchLink']    xpath=//option[contains(.,'(SelectBank)')]
        Validate value (value)    //select[@id='BankBranchLink']    ${empty}
        Click button    //*[@id="save"]
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Delete bank.AD    ${bank_name}    ${bank_code}    deleted successfully
        Log to console    Status: OK - Deleted not assigned bank + bank branch (+)
    END
    Close Browser
    [Teardown]    Close Browser.AD

Edit bank names > add RF bank and branch, assign, delete (in a Bulk)
    [Tags]    Administration
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    #Set Selenium speed    0.5
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${bank_name}    set variable    RF BANK (Bulk)
        ${bank_code}    set variable    RFBC-03
        Log to console    Let`s add "${bank_name}" bank via bulk box
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        #    Run Keyword If    ${preprod?}    Exit forloop
        Add bank+branches (in a bulk).AD    ${bank_name}    ${bank_code}
        Delete bank.AD    ${bank_name}    ${bank_code}    deleted successfully
    END
    Close Browser
    [Teardown]    Close Browser.AD

Edit cash flow types > add cash flow types
    [Tags]    Administration
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
        Add record.AD    ${name}    ${name}    /cash-flow-types.php
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client cash flow types > add client cash flow types
    [Tags]    Administration
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
    [Tags]    Administration
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
        ${bank_name}    set variable    RF BANK
        ${bank_code}    set variable    RFBC-01
        ${bank_br_name}    set variable    RF Branch Name
        ${bank_br_code}    set variable    RFBrCode
        Set global variable    ${bank_br_name}
        Set global variable    ${bank_br_code}
        #    Run Keyword If    ${preprod?}    Add record.AD    ${bank_name}    ${bank_name} description    /settings-bank-names.php
    #
        Run keyword and ignore error    Delete bank.AD    ${bank_name}    ${bank_code}    deleted successfully
        Add/update bank.AD    ${bank_name}    ${bank_code}    /settings-bank-names.php
    #
        Add record.AD    ${name}    Credit Card for RF    /settings-creditcards.php
    END
    Close Browser
    [Teardown]    Close Browser.AD

Special days definitions > add special day
    [Tags]    Administration
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
    [Tags]    Administration
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
    [Tags]    Administration
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
        go to.AD    ${URL}/alt-langs.php?page_var_filter_IsActive=&page_var_sorting_column=AltLangName&page_var_sorting_order=up&page_var_divide_recordsPerPage=500&page_var_divide_curPage=1
        Wait until page contains element    //button[@class='btn-input']
        ${element visible?}=    Run keyword and return status    Page should contain    ${name1}
        Run Keyword If    "${element visible?}"=="True"    Click link    default=${name1}
        Run Keyword If    "${element visible?}"=="False"    Click element    //*[@id="big_tedit_wrapping_table"]/tbody/tr[1]/td/table/tbody/tr/td/button
        Wait Until Page Contains element    //input[@id='field_AltLangName']
        Input text    //input[@id='field_AltLangName']    ${name1}
        Select dropdown.AD    //*[@id="idAltLangDirectionEditbox"]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'Right to left')]
        Set checkbox.AD    //input[@id='field_IsActive']    true
        Select dropdown.AD    //*[@id="idInterfaceLanguageEditbox"]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'English UK')]
        Click Save/Add/Delete/Cancel button.AD
        Wait Until Page Contains    successfully
        go to.AD    ${URL}/alt-langs.php?page_var_filter_IsActive=&page_var_sorting_column=AltLangName&page_var_sorting_order=up&page_var_divide_recordsPerPage=500&page_var_divide_curPage=1
        Wait until page contains element    //button[@class='btn-input']
        ${element visible?}=    Run keyword and return status    Page should contain    ${name2}
        Run Keyword If    "${element visible?}"=="True"    Click link    default=${name2}
        Run Keyword If    "${element visible?}"=="False"    Click element    //*[@id="big_tedit_wrapping_table"]/tbody/tr[1]/td/table/tbody/tr/td/button
        Wait Until Page Contains element    //input[@id='field_AltLangName']
        Input text    //input[@id='field_AltLangName']    ${name2}
        Select dropdown.AD    //*[@id="idAltLangDirectionEditbox"]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'Left to right')]
        Set checkbox.AD    //input[@id='field_IsActive']    true
        Select dropdown.AD    //*[@id="idInterfaceLanguageEditbox"]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'English UK')]
        Click Save/Add/Delete/Cancel button.AD
        Wait Until Page Contains    successfully
        GET alt lang ID.AD    ${name1}
        GET alt lang ID.AD    ${name2}
        Log to console    Added/updated 2 alt languages: "${name1}" and "${name2}"
    END
    Close Browser
    [Teardown]    Close Browser.AD
