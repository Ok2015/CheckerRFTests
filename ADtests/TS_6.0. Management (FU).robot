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
    [Tags]    Sample    Survey
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        ${RF sample name}    set variable    RF SAMPLE 01
        set global variable    ${RF sample name}
        Search Client.AD
        Search/create Sample.AD
        go to.AD    ${URL}/sample-data-upload.php?SampleID=${Sample ID}
        Choose File    //input[@id='dataFile']    ${CURDIR}\\Resources\\Extra files\\SAMPLEs\\Valid Sample.xls
        Click element    //input[@id='upload']
        go to.AD    ${URL}/sample-edit.php?SampleID=${Sample ID}
        go to.AD    ${URL}/sample-api.php?SampleID=${Sample ID}
        go to.AD    ${URL}/sample-unification.php?SampleID=${Sample ID}
        go to.AD    ${URL}/sample-data-edit.php?SampleID=${Sample ID}
        Add sample row.AD
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
        ${RF sample name}    set variable    RF SAMPLE 01
        set global variable    ${RF sample name}
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        ${Robot q-ry}=    set variable    RF Questionnaire [Email]
        set global variable    ${Robot q-ry}
        Search the Q-ry (via search bar).AD    RF Questionnaire [Email]
        Get question ID
        Search Client.AD
        Search/add Survey.AD    RF SURVEY [EMAIL]    RF Questionnaire [Email]    Email
        Search/create Sample.AD
        Add sample row.AD
    #
        go to.AD    ${URL}/survey-workers.php?SurveyID=${SurveyID}
        go to.AD    ${URL}/surveyors.php?SurveyID=${SurveyID}
        go to.AD    ${URL}/survey-statuses.php?SurveyID=${SurveyID}
        go to.AD    ${URL}/survey2-quotas.php?SurveyID=${SurveyID}
    #    Run Keyword If    ${testing?}    go to.AD    ${URL}/survey-weighted-result-setup.php?SurveyID=${SurveyID}
        go to.AD    ${URL}/survey-quotas-status.php?SurveyID=${SurveyID}
        go to.AD    ${URL}/report-samples.php?SurveyID=${SurveyID}&show=1
        go to.AD    ${URL}/phone-survey-management.php?SurveyID=${SurveyID}
        go to.AD    ${URL}/survey-sample-transfers.php?SurveyID=${SurveyID}
        go to.AD    ${URL}/survey-flt-questions.php?SurveyID=${SurveyID}
        go to.AD    ${URL}/survey-delete-unused-sample-rows.php?SurveyID=${SurveyID}
        go to.AD    ${URL}/survey2-priorities.php?SurveyID=${SurveyID}
        go to.AD    ${URL}/survey2-filter-conditions.php?SurveyID=${SurveyID}
        go to.AD    ${URL}/survey-send-invitations.php?SurveyID=${SurveyID}
        Send survey invitation.AD
    #
        GMAIL: Survey email.AD    RF SP user    RF Email subject for the invitation
        Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF - EMAIL SURVEY    2000    I am free text entered by reviewer - ${DD.MM.YY} RF - INTERNET SURVEYEXTRACHARACTERS    Internal message added by RF shopper (date: ${DD.MM.YY})    NO
        click element    //input[@id='finishCrit']
        Wait Until Page Contains    RF Thank you message, right after filling the survey
        Check errors on page [-1]
        Wait Until Page Contains    REQUEST A FREE DEMO    20
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
        Validate value (text)    //textarea[@id='obj${Q1 ID}-mi']    ***
        Validate value (value)    //textarea[@id='obj${Q2 ID}-mi']    Additional info - ${DD.MM.YY} RF - EMAIL SURVEY
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

Management > add Survey (SMS)
    [Tags]    Survey
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        set global variable    ${URL}
        SET UP
    #
        ${RF sample name}    set variable    RF SAMPLE 01
        set global variable    ${RF sample name}
    #
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD
        Search/create Sample.AD
        Search/add Survey.AD    RF SURVEY [SMS]    RF Questionnaire [SMS]    SMS
        go to.AD    ${URL}/surveyors.php?SurveyID=${SurveyID}
        Manage sample fields.AD
        Add sample row.AD
        Send survey invitation.AD
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
        Search/add Survey.AD    ${RF survey name}    RF Questionnaire [Surveys]    Phone
        Manage sample fields.AD
        Check Authorized surveyors.AD    /surveyors.php?SurveyID=${SurveyID}    ${RobotTestShopper 02}
        Add survey status.AD    STATUS A (Refused)    Refused
        Add survey status.AD    STATUS B (Completed a survey)    Completed a survey
        Add survey status.AD    STATUS C (Asked to be contacted later)    Asked to be contacted later
    #
        go to.AD    ${URL}/phone-survey-management-summary.php
        Wait until page contains    Surveys management summary
        Input text    //input[@id='rangeStart']    01-01-2021
        Input text    //input[@id='rangeEnd']    01-01-2022
        Click element    //input[@id='go']
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[1]    Survey name
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[2]    Type
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[3]    Planned hourly surveys average per surveyor
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[4]    Reviews/Hr
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[5]    Duration
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[6]    Reviews count
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[7]    Stack
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[8]    Date of sample addition
    #
        go to.AD    ${URL}/phone-survey-management-summary.php
        Wait until page contains    Surveys management summary
        Select dropdown.AD    //*[@id="type"]    //*[@id="type"]/option[2]
        Input text    //input[@id='rangeStart']    01-01-2021
        Input text    //input[@id='rangeEnd']    01-01-2022
        Click element    //input[@id='go']
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[1]    Survey name
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[2]    Type
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[3]    Runs Now
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[4]    Last status
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[5]    Invited
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[6]    Invited read
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[7]    In progress
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[8]    Reviews count
        Element text should be    //*[@id="survey_summary"]/thead/tr[1]/th[9]    Date of sample addition
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

Management > add Survey (WhatsApp Business)
    [Tags]    Survey
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        set global variable    ${URL}
        SET UP
    #
        ${RF sample name}    set variable    RF SAMPLE 01
        set global variable    ${RF sample name}
    #
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD
        Search/create Sample.AD
        Search/add Survey.AD    RF SURVEY [WhatsApp B]    RF Questionnaire [SMS]    SMS
        go to.AD    ${URL}/surveyors.php?SurveyID=${SurveyID}
        Manage sample fields.AD
        Add sample row.AD
        Send survey invitation.AD
    END
    Close Browser
    [Teardown]    Close Browser.AD
