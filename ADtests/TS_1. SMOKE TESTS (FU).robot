*** Settings ***
Suite Setup
Suite Teardown    Close All Browsers
Library           SeleniumLibrary
Library           DateTime
Library           pabot.PabotLib
Resource          ${CURDIR}/Resources/CheckerLibUI.txt
Resource          ${CURDIR}/Resources/EDITORMSGs.txt
Resource          ${CURDIR}/Resources/Settings.txt
Library           OpenPyxlLibrary

*** Test Cases ***
MysteryShopping_01: Shopper submits a review (check only review statuses and saved answers)
    [Tags]    Smoke
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}=    Set variable    RF Order: Single_01 SMOKE [To check review status and answers, ${DD.MM.YY}]
        ${Internal message}    Set variable    Internal message added by RF shopper ${DD.MM.YY}
        Set global variable    ${Internal message}
        ${Free text message}    Set variable    Fee text entered by RF reviewer - ${DD.MM.YY}
        Set global variable    ${Free text message}
        Set global variable    ${test order description}
        ${Robot q-ry}=    set variable    ${RobotQ-ry SHOPPERS}
        set global variable    ${Robot q-ry}
    #
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/company-display.php
        Run Keyword If    ${testing?}    Execute JavaScript    window.document.getElementById("field_ShopperNewInterface").scrollIntoView(true)
        Run Keyword If    ${testing?}    Set checkbox.AD    //*[@id="field_ShopperNewInterface"]    None
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    Display settings saved successfully
        Make visible Job columns.AD    true    on
        Search client using search bar.AD
        Set client autocritapprove.AD    None
        Search the Q-ry (via search bar).AD    ${RobotQ-ry SHOPPERS}
        Edit questionnaire.AD    RFQRY-SHO-03    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Get question ID
        #    Make visible Job columns.AD    true    on
        #    Set Records per page    100
        #    Search shopper by AD    ${RobotTestShopper 02}
        Create test order (Single)    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        click link    default=Edit assignments
        Wait until page contains element    //form/input[@id='show']
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][9]    Ordered, awaiting assignation
        Select dropdown.AD    //select[@id='PropID']    xpath=//option[contains(.,'${Property name}')]
        Select dropdown.AD    //*[@id="ValueID"]    xpath=//option[contains(.,'Autotest-YES')]
        Select dropdown.AD    //*[@id="pleaseFilter"]    //*[@id="pleaseFilter"]/option[2]
        Wait until page contains element    //form/input[@id='show']
        Click Element    //input[@id='show']
        Element text should be    //td[@class='report-dir'][2]    Robot 02 [Full Name]
        Set focus to element    //*[@id="assignmenttable"]/tbody/tr/td[1]/input
        Click Element    //*[@id="assignmenttable"]/tbody/tr/td[1]/input
        Click Element    //input[@id='do_assignment']
        Page should contain    1 orders assigned
        Log to console    Order `${found order ID}` (description="${test order description}") is assigned!
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][9]    Assigned, awaiting shopper acceptance
        Wait until page contains    ${test order description}
        #    Check errors on page [-1]    # fails on testing here
        Log to console    [Order page] Status="Assigned, awaiting shopper acceptance" (+)
    #
        Login as a Shopper
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Accept job
        Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF    2000    ${Free text message}    ${Internal message}    No
        Check Review Subm Time    SubmissionTime (2022).xlsx    1    Thank you    # № of sheet
        Element text should be    //center/table/tbody/tr[2]/td/a[1]    Back to main menu
        Element text should be    //center/table/tbody/tr[2]/td/a[2]    Back to review selection
        Element text should be    //center/table/tbody/tr[2]/td/a[3]    Log off
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Log to console    ------------------------->CHECKING "Edit entire review" page
        go to.AD    ${URL}/edit-entire-crit.php?CritID=${ReviewID}
        Element text should be    //span[@class='CritInfoItem'][9]    Finished, awaiting approval
        Log to console    [Edit entire review page] Status="Finished, awaiting approval" (+)
        Approve review.AD
        go to.AD    ${URL}/edit-entire-crit.php?CritID=${ReviewID}
        Element text should be    //span[@class='CritInfoItem'][9]    Approved
        Validate value (text)    //textarea[@id='obj${Q1 ID}-mi']    ***
        Validate value (value)    //textarea[@id='obj${Q2 ID}-mi']    Additional info - ${DD.MM.YY} RF
        Validate value (value)    //input[@id='obj${Q3 ID}-mi']    2000
        Validate element attribute.AD    //input[@id='obj${Q1 ID}4']    checked    true
        Validate element attribute.AD    //input[@id='obj${Q2 ID}3']    checked    true
        Validate element attribute.AD    //input[@id='obj${Q3 ID}4']    checked    true
        Validate element attribute.AD    //select[@id='obj${Q4 ID}']/option[3]    selected    true
        Validate element attribute.AD    //select[@id='obj${Q4 ID}']/option[4]    selected    true
        Page should contain    ${RobotQ-ry SHOPPERS}
        Page should contain    ${RobotTestClient}
        Page should contain    ${RobotTestShopper 02}
        Log to console    [Edit entire review page] Status="Approved" (+)
        Log to console    [Edit entire review page] Answers are saved properly (+)
    END
    Close Browser
    [Teardown]    Close Browser.AD

InternetSurvey_02: Shopper submits an Internet survey (check only review statuses and saved answers)
    [Tags]    Internet    Smoke
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${ISurveyName}=    Set variable    RF Survey 01 [Internet Survey]
        ${Branch}=    Set variable    RF Branch 11 (Internet Surveys) [Short name]
        ${Robot q-ry}=    set variable    RF Questionnaire [Internet]
        set global variable    ${Robot q-ry}
        Set global variable    ${ISurveyName}
        Set global variable    ${Branch}
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        Edit questionnaire.AD    RFQRY-INT-05    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Get question ID
        Search Client.AD
        go to.AD    ${URL}/clients.php?_&edit=${client ID}
        Wait until page contains element    //input[@id='field_AutomaticCritApproval']
        Set checkbox.AD    //input[@id='field_AutomaticCritApproval']    None
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    saved successfully
        Edit ISurvey.AD    1000000    RF Questionnaire [Internet]    BranchFullname 05 (for Internet Surveys)
        #    go to.AD    https://eu.checker-soft.com/testing/i_survey-fill.php?SurveyID=221
        go to.AD    ${URL}/i_survey-fill.php?SurveyID=${ReviewID}
        Begin scorecard (OPlogic=no).SD    Additional info (${DD.MM.YY}) RF - INTERNET SURVEY    2000    I am free text entered by reviewer - ${DD.MM.YY} RF - INTERNET SURVEY    Internal message added by RF shopper (date: ${DD.MM.YY})    NO
        Check Review Subm Time    SubmissionTime (2022).xlsx    2    Thank you    # № of sheet
        Page Should contain    You have completed the RF survey, thank you for participating
        Page Should contain    Thank you for taking the time to complete this survey.
        Page Should contain    The fact that you are reading this message indicates that you have completed our survey
        Page Should contain    and that we owe you a debt of thanks.
        Page Should contain    We are very appreciative of the time you have taken to assist in our analysis and commit to utilizing the information gained to contemplate and implement worthwhile improvements.
        Wait Until Page Contains    REQUEST A FREE DEMO    20
        go to.AD    ${URL}/crit-handling-details.php?CritID=${Review Number}
        Wait Until Page Contains    Review handling details
        Page should contain    ${Review Number} Finished, awaiting approval
        Log to console    [Edit entire review page] Status="Finished, awaiting approval" (+)
        Scroll Element Into View    id=approveCrit
        Click button    id=approveCrit
        Check errors on page [-1]
        Wait Until Page Contains    Review approved
        Page should contain    ${Review Number} Approved
        Log to console    Review `${Review Number}` has been approved by manager (+)
        go to.AD    ${URL}/edit-entire-crit.php?CritID=${Review Number}
        Element text should be    //span[@class='CritInfoItem'][9]    Approved
        Validate value (text)    //textarea[@id='obj${Q1 ID}-mi']    ***
        Validate value (value)    //textarea[@id='obj${Q2 ID}-mi']    Additional info (${DD.MM.YY}) RF - INTERNET SURVEY
        Validate value (value)    //input[@id='obj${Q3 ID}-mi']    2000
        Validate element attribute.AD    //input[@id='obj${Q1 ID}4']    checked    true
        Validate element attribute.AD    //input[@id='obj${Q2 ID}3']    checked    true
        Validate element attribute.AD    //input[@id='obj${Q3 ID}4']    checked    true
        Validate element attribute.AD    //select[@id='obj${Q4 ID}']/option[3]    selected    true
        Validate element attribute.AD    //select[@id='obj${Q4 ID}']/option[4]    selected    true
        Page should contain    ${Robot q-ry}
        Page should contain    ${RobotTestClient}
        Log to console    [Edit entire review page] Status="Approved" (+)
        Log to console    [Edit entire review page] Answers are saved properly (+)
    END
    Close Browser
    [Teardown]    Close Browser.AD

PhoneSurvey_03: Shopper submits a Phone survey (check saved answers)
    [Tags]    PhoneS    Smoke
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        set global variable    ${URL}
        SET UP
        ${RF survey name}    set variable    RF SURVEY [PHONE]
        set global variable    ${RF survey name}
        ${RF sample name}    set variable    RF SAMPLE 01
        set global variable    ${RF sample name}
        ${Robot q-ry}=    set variable    RF Questionnaire [Surveys]
        set global variable    ${Robot q-ry}
    #
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Search the Q-ry (via search bar).AD    RF Questionnaire [Surveys]
        Edit questionnaire.AD    RFQRY-SUR-01    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Get question ID
        Search Client.AD
        #    Search/add Survey.AD    ${RF survey name}    RF Questionnaire [Surveys]
        #    Check Authorized surveyors.AD    /surveyors.php?SurveyID=${ReviewID}    ${RobotTestShopper 02}
        Search/create Sample.AD
        Add sample row.AD
    #
        Login as a Shopper
        go to.AD    ${URL}/c_survey-select.php
        Wait until page contains    Please select a survey
        Page should contain    Surveys selection
        Element text should be    //*[@id="table_rows"]/tbody/tr/td[1]/a    ${RF survey name}
        Element text should be    //*[@id="table_rows"]/tbody/tr/td[2]    RF Questionnaire [Surveys]
        Element text should be    //*[@id="table_rows"]/tbody/tr/td[3]    RF SAMPLE 01
        Element text should be    //*[@id="table_rows"]/tbody/tr/td[4]/p[1]    RF note for surveyors for ${RF survey name}
        Page should contain element    //input[@id='request-break']
        Page should contain    Back to main menu
        Page should contain    Log off
        Element text should be    //*[@id="table_rows"]/thead/tr/th[1]    Survey name
        Element text should be    //*[@id="table_rows"]/thead/tr/th[2]    Questionnaire name
        Element text should be    //*[@id="table_rows"]/thead/tr/th[3]    Sample name
        Element text should be    //*[@id="table_rows"]/thead/tr/th[4]    Note for surveyors
        Click link    default=${RF survey name}
        Check errors on page [-1]
        Wait until page contains    Questionnaire preview
        Click element    //input[@id='submitSurveyForm']
        Run keyword and ignore error    select frame    top_frame
        sleep    1
        Page should contain element    calling_widget
    ##################
        Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF    2000    I am a Free text RF message    I am an Internal RF message    No
        Run keyword and ignore error    select frame    top_frame
        Page should contain element    calling_widget
        Unselect frame
        Run keyword and ignore error    select frame    ${Iframe}
        Check Review Subm Time    SubmissionTime (2022).xlsx    3    Back to main menu    # № of sheet
        #    Element text should be    //center/table/tbody/tr[2]/td/a[1]    Back to main menu
        #    Element text should be    //center/table/tbody/tr[2]/td/a[2]    Back to review selection
        #    Element text should be    //center/table/tbody/tr[2]/td/a[3]    Log off
        Check errors on page [-1]
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/crit-handling-details.php?CritID=${Review Number}
        Wait Until Page Contains    Review handling details
        Page should contain    ${Review Number} Finished, awaiting approval
        Log to console    [Edit entire review page] Status="Finished, awaiting approval" (+)
        Scroll Element Into View    id=approveCrit
        Click button    id=approveCrit
        Check errors on page [-1]
        Wait Until Page Contains    Review approved
        Page should contain    ${Review Number} Approved
        Log to console    Review `${Review Number}` has been approved by manager (+)
        go to.AD    ${URL}/edit-entire-crit.php?CritID=${Review Number}
        Element text should be    //span[@class='CritInfoItem'][9]    Approved
        Page should contain    ${Robot q-ry}
        Page should contain    ${RobotTestClient}
        Page should contain    ${RobotTestShopper 02}
        Validate value (text)    //textarea[@id='obj${Q1 ID}-mi']    ***
        Validate value (value)    //textarea[@id='obj${Q2 ID}-mi']    Additional info - ${DD.MM.YY} RF
        Validate value (value)    //input[@id='obj${Q3 ID}-mi']    2000
        Validate element attribute.AD    //input[@id='obj${Q1 ID}4']    checked    true
        Validate element attribute.AD    //input[@id='obj${Q2 ID}3']    checked    true
        Validate element attribute.AD    //input[@id='obj${Q3 ID}4']    checked    true
        Validate element attribute.AD    //select[@id='obj${Q4 ID}']/option[3]    selected    true
        Validate element attribute.AD    //select[@id='obj${Q4 ID}']/option[4]    selected    true
        Log to console    [Edit entire review page] Status="Approved" (+)
        Log to console    [Edit entire review page] Answers are saved properly (+)
    END
    Close Browser
    [Teardown]    Close Browser.AD

Checkertificate_04: Shopper submits a Checkertificate review (check only review statuses and saved answers)
    [Tags]    PhoneS    Smoke
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        set global variable    ${URL}
        SET UP
        ${Robot Certificate}=    set variable    RF 002 - Check submission [Certificate]
        ${Robot Description Certificate}=    set variable    RF Hidden certificate for RF shopper to check its submission
        ${Robot q-ry}    set variable    RF Questionnaire [Certificate]
        set global variable    ${Robot Certificate}
        set global variable    ${Robot Description Certificate}
        set global variable    ${Robot q-ry}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
    ###
        Search Certificate    ${Robot Certificate}
        Manage passed certificates.AD
        ${Robot q-ry}=    set variable    RF Questionnaire [Certificate]
        set global variable    ${Robot q-ry}
    #
        Search the Q-ry(via table).AD    ${Robot q-ry}    7
        #    Edit questionnaire.AD    RFQRY-CER-04    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Get question ID
    #
        Login as a Shopper
    #
    #
        go to.AD    ${URL}/c_certificate-list.php?CerID=${CertID}
        Wait until page contains    CheckerTificate
        Page should contain    ${Robot Certificate}
        Page should contain    ${Robot Description Certificate}
        Log to console    "${Robot Certificate}" is visible (${Robot Description Certificate})
        Click element    //*[@id="table_rows"]/tbody/tr/td[2]/a
        Run keyword and ignore error    Handle alert
    ##################
        Run keyword if    ${testing?}    Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF    2000    I am a Free text RF message    I am an Internal RF message    No
        Run keyword if    ${testing?}    Click element    //*[@id="saveAndExit"]
        Run keyword if    ${testing?}    Wait until page contains    Data saved
        Run keyword if    ${testing?}    go to.AD    ${URL}/c_unfinished-crits.php
        Run keyword if    ${testing?}    Page should not contain    ${Robot Certificate}
        Run keyword if    ${testing?}    Page should not contain    ${Robot Description Certificate}
        Run keyword if    ${testing?}    Page should not contain    ${Robot q-ry}
        Run keyword if    ${testing?}    Log to console    ${URL}/c_unfinished-crits.php does not contain saved certificate job (+)
    #
        go to.AD    ${URL}/c_certificate-list.php?CerID=${CertID}
        Wait until page contains    CheckerTificate
        Page should contain    ${Robot Certificate}
        Page should contain    ${Robot Description Certificate}
        Log to console    "${Robot Certificate}" is visible (${Robot Description Certificate})
        Click element    //*[@id="table_rows"]/tbody/tr/td[2]/a
    ##################
        Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF    2000    I am a Free text RF message    I am an Internal RF message    No
        Check Review Subm Time    SubmissionTime (2022).xlsx    4    Thank you    # № of sheet
        Page should contain    Thank you for filling this review
        Page should contain    Certificate passed successfully
        #    Page should contain    No need to add certificate for this checker
        #    Page should contain    No need to give any set permissions
        #    Page should contain    Adding certificate to Checker
        #    Page should contain    Checker should be certified to this certificate
        Page should contain    ${Robot Certificate}
        Check errors on page [-1]
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/crit-handling-details.php?CritID=${Review Number}
        Wait Until Page Contains    Review handling details
        Page should contain    ${Review Number} Finished, awaiting approval
        Log to console    [Edit entire review page] Status="Finished, awaiting approval" (+)
        #    Scroll Element Into View    id=approveCrit
        #    Click button    id=approveCrit
        #    Check errors on page [-1]
        #    Wait Until Page Contains    Review approved
        #    Page should contain    ${Review Number} Approved
        #    Log to console    Review `${Review Number}` has been approved by manager (+)
        go to.AD    ${URL}/edit-entire-crit.php?CritID=${Review Number}
        Element text should be    //span[@class='CritInfoItem'][9]    Finished, awaiting approval
        Page should contain    ${Robot q-ry}
        Page should contain    ${RobotTestClient}
        Page should contain    ${RobotTestShopper 02}
        Validate value (text)    //textarea[@id='obj${Q1 ID}-mi']    ***
        Validate value (value)    //textarea[@id='obj${Q2 ID}-mi']    Additional info - ${DD.MM.YY} RF
        Validate value (value)    //input[@id='obj${Q3 ID}-mi']    2000
        Validate element attribute.AD    //input[@id='obj${Q1 ID}4']    checked    true
        Validate element attribute.AD    //input[@id='obj${Q2 ID}3']    checked    true
        Validate element attribute.AD    //input[@id='obj${Q3 ID}4']    checked    true
        Validate element attribute.AD    //select[@id='obj${Q4 ID}']/option[3]    selected    true
        Validate element attribute.AD    //select[@id='obj${Q4 ID}']/option[4]    selected    true
        click element    //input[@id='saveandapprove']
        go to.AD    ${URL}/edit-entire-crit.php?CritID=${Review Number}
        Element text should be    //span[@class='CritInfoItem'][9]    Approved
        Log to console    [Edit entire review page] Status="Approved" (+)
        Log to console    [Edit entire review page] Answers are saved properly (+)
    END
    Close Browser
    [Teardown]    Close Browser.AD
