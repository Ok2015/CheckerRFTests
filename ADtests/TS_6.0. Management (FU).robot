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
Management > add Sample
    [Tags]    Sample
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        ${RF sample name}    set variable    RF SAMPLE 01
        set global variable    ${RF sample name}
        Search/create Sample.AD
        go to.AD    ${URL}/sample-data-upload.php?SampleID=${ReviewID}
        Choose File    //input[@id='dataFile']    ${CURDIR}\\Resources\\Extra files\\SAMPLEs\\Valid Sample.xls
        Click element    //input[@id='upload']
        go to.AD    ${URL}/sample-edit.php?SampleID=${ReviewID}
        go to.AD    ${URL}/sample-api.php?SampleID=${ReviewID}
        go to.AD    ${URL}/sample-unification.php?SampleID=${ReviewID}
        go to.AD    ${URL}/sample-data-edit.php?SampleID=${ReviewID}
    END
    Close Browser
    [Teardown]    Close Browser.AD

Management > add Survey (EMAIL)
    [Tags]    Survey
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD
        Search/add Survey.AD    RF SURVEY [EMAIL]    RF Questionnaire [Email]
    END
    Close Browser
    [Teardown]    Close Browser.AD

Management > add Survey (SMS)
    [Tags]    Survey
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD
        Search/add Survey.AD    RF SURVEY [SMS]    RF Questionnaire [SMS]
        go to.AD    ${URL}/surveyors.php?SurveyID=${ReviewID}
    END
    Close Browser
    [Teardown]    Close Browser.AD

Management > add Survey (PHONE)
    [Tags]    Survey
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        set global variable    ${URL}
        SET UP
        ${RF survey name}    set variable    RF SURVEY [PHONE]
        set global variable    ${RF survey name}
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD
        Search/add Survey.AD    ${RF survey name}    RF Questionnaire [Surveys]
        Check Authorized surveyors.AD    /surveyors.php?SurveyID=${ReviewID}    ${RobotTestShopper 02}
        go to.AD    ${URL}/survey-sample-fields-manage.php?SurveyID=${ReviewID}
        Run keyword if    ${testing?}    Input text    //input[@id='PhoneNumberField[CellNumber]']    1
        Run keyword if    ${testing?}    Input text    //input[@id='SMSPhoneNumberField[CellNumber]']    1
        Run keyword if    ${preprod?}    Input text    //input[@id='PhoneNumberField[Cellular]']    1
        Run keyword if    ${preprod?}    Input text    //input[@id='SMSPhoneNumberField[Cellular]']    1
        Click element    //input[@id='save']
        Run keyword if    ${testing?}    Validate value (value)    //input[@id='PhoneNumberField[CellNumber]']    1
        Run keyword if    ${testing?}    Validate value (value)    //input[@id='SMSPhoneNumberField[CellNumber]']    1
        Run keyword if    ${preprod?}    Validate value (value)    //input[@id='PhoneNumberField[Cellular]']    1
        Run keyword if    ${preprod?}    Validate value (value)    //input[@id='SMSPhoneNumberField[Cellular]']    1
    ####
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
    #    Wait until page contains    No matching records found or survey completed, please contact survey manager.
    END
    Close Browser
    [Teardown]    Close Browser.AD
