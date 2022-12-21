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
Operation > Failed 105 code shows 0 results on check review condition page
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${LabelName}=    Set variable    RF Label 03 - will be deleted by manager
        Set global variable    ${LabelName}
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        Get BR property ID. AD    Manager
    #
        Go to2.AD    ${URL}/crits-handling.php
        Wait until page contains    Handle finished reviews
        Input text    //input[@id='rangeStart']    13-05-2020
        Click element    //input[@id='show']
        ${Review ID}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[2]/a[1]
        Go to2.AD    ${URL}/check-condition.php
        Wait until page contains    Check review condition
        Page should contain    In this page you can check a condition against a finished review.
        Page should contain    Click here for explanation about conditions
        Page should contain    Enter condition
    #
        Input text    //*[@id="side_menu"]/tbody/tr/td[3]/form/table/tbody/tr[1]/td[2]/textarea    $[105,${Property ID},${Property option ID}]$+$[105,${Property ID},${Property option ID}]$=0
        Input text    //input[@id='CritID']    ${Review ID}
        Log to console    Review ID="${Review ID}"
        Click element    //input[@id='go']
        Element text should be    //*[@id="side_menu"]/tbody/tr/td[3]/table/tbody/tr[1]/td[1]    The condition with the values
        Element text should be    //*[@id="side_menu"]/tbody/tr/td[3]/table/tbody/tr[2]/td[1]    Condition result
        Element text should be    //*[@id="side_menu"]/tbody/tr/td[3]/table/tbody/tr[1]/td[2]    0+0=0
        Element text should be    //*[@id="side_menu"]/tbody/tr/td[3]/table/tbody/tr[2]/td[2]    True
        Page should contain    Show entire review
        Log to console    Works! 105 text code shows "0+0=0" in case of false condition result (condition: $[105,${Property ID},${Property option ID}]$+$[105,${Property ID},${Property option ID}]$=0)
        Go to2.AD    ${URL}/help-text-subst-codes.php
        Wait Until Page Contains    The Checker system supports a number of codes, which can be used inside the Survey Group (inside text, question, question description and answer text). Some of the codes are used also as a display condition.
        Page should contain    Text codes explanation
        Page should contain    Questions
        Page should contain    Branches, Clients, Users and Shoppers
        Page should contain    Samples
        Page should contain    Text Design Codes
        Page should contain    Display conditions
        Page should contain    Content codes are used for showing or using several types of data.
        Page should contain    The following codes are currently supported:
        Page should contain    $[1,question_object_id]$
        Page should contain    This code is replaced with the chosen answer text for this question. question_object_id is a numeric identification code of this question. It can be determined by showing the question details in survey group editing mode. In the window which will be opened, you will be able to see "Object identifier" and the aforementioned code.
        Page should contain    In case you want to display the chosen answer, a page break has to be inserted between the source question and betwen the object which contains the code. Otherwise the system will not be able to tell the chosen answer.
        Page should contain    $[2,question_object_id]$
        Page should contain    This code returns the user-entered input (more information) for the question with the specified object-id
        Page should contain    It's possible to define default value in the folowing way:
        Page should contain    $[2;value,question_object_id]$
        Page should contain    $[3,question_object_id]$
        Page should contain    This code returns a numeric value that represents date or time enterd in the user-entered input (more information) for the question with the specified object-id
        Page should contain    It's possible to define default value in the folowing way:
        Page should contain    $[3;value,question_object_id]$
        Page should contain    $[4,condition,value_in_case_true,value_in_case_false]$
        Page should contain    Rturns different value based on checked condition
        Page should contain    $[11,question_code]$
        Page should contain    This code returns the answer code of the question whose code is specified.
        Page should contain    Please note the difference between codes and IDs. The latter is user-defined (for example: Question codes).
        Page should contain    $[12,question_code,answer_code]$
        Page should contain    Checks if the specified answer was selected by the reviewer as one of the answers of the specified question.
        Page should contain    Returns 1 if true, 0 otherwise.
        Page should contain    Useful for multiple choice questions.
        Page should contain    $[16,question_code]$
        Page should contain    Returns all selected answers seperated by comma.
        Page should contain    Useful for multiple choice questions.
        Page should contain    $[13,question_code]$
        Page should contain    This code returns the user-entered input (more information) for the question with the specified question code.
        Page should contain    It's possible to define default value in the folowing way:
        Page should contain    $[13;value,question_code]$
        Page should contain    $[1300,question_code]$
        Page should contain    This code returns 1 if the user-entered input (more information) for the question with the specified question code was filled, 0 otherwise.
        Page should contain    $[15,Question_ID,Answer_ID]$
        Page should contain    Checks if the specified answer ID was selected by the reviewer as one of the answers of the specified question ID.
        Page should contain    Returns 1 if true, 0 otherwise.
        Page should contain    Useful for multiple choice questions
        Page should contain    $[234,section_id]$
        Page should contain    This code is replaced with the score of the chosen section for this review.
        Page should contain    Use this format in order to set decimal fraction digits : $[234,section_id~2]$
        Page should contain    $[235,sub_section_id]$
        Page should contain    This code is replaced with the score of the chosen sub-section for this review.
        Page should contain    Use this format in order to set decimal fraction digits : $[235,sub-section_id~2]$
        Page should contain    $[250,section_id]$
        Page should contain    This code is replaced with the weight of the chosen section for this review.
        Page should contain    $[251,sub_section_id]$
        Page should contain    This code is replaced with the weight of the chosen sub-section for this review.
        Page should contain    $[252,question_id,sub_section_id]$
        Page should contain    This code is replaced with the weight of the chosen question in the sub-section specified for this review.
        Page should contain    $[260,question_id,sub_section_id]$
        Page should contain    This code is replaced with the grade of the chosen question specified for this review.
    ###
        Page should contain    $[101,client_property_id]$
        Page should contain    This code is replaced with the property content identifier, according to the branch defined in the current survey. You may use this code as a display condition, in order to display certain object only if a branch has a specific property defined.
        Page should contain    For example, you may define a question called "Rate the waiter politeness", which will appear only in branches defined as branches without self service.
        Page should contain    For this code, you have have to know the property identifier, and the property content identifier. They appear in the client property editing screen.
        Page should contain    $[102,PropID]$
        Page should contain    This code returns the content of the branch characteristic.
        Page should contain    $[103,PropID]$
        Page should contain    This code returns the ID of the shopper characteristic value.
        Page should contain    $[104,PropID,PropValueID]$
        Page should contain    Checks if the specified characteristic value ID was chosen for the shopper as one of it's characteristics.
        Page should contain    Useful for multiple choice characteristics.
        Page should contain    $[105,PropID,PropValueID]$
        Page should contain    Checks if the specified characteristic value ID was chosen for the branch as one of it's characteristics.
        Page should contain    Useful for multiple choice characteristics.
        Page should contain    $[200]$
        Page should contain    This code is replaced with the full branch name.
        Page should contain    $[201]$
        Page should contain    This code is replaced with the short branch name.
        Page should contain    $[202]$
        Page should contain    This code is replaced with the reviewer name.
        Page should contain    $[203]$
        Page should contain    This code is replaced with the review ID number.
        Page should contain    $[2031]$
        Page should contain    This code is replaced with the review status.
        Page should contain    $[204]$
        Page should contain    This code is replaced with the reviewer code.
        Page should contain    $[205]$
        Page should contain    This code is replaced with the branch code.
        Page should contain    $[400]$
        Page should contain    This code is replaced with the worker name from the review.
        Page should contain    $[206]$
        Page should contain    This code is replaced with survey group code.
        Page should contain    $[207]$
        Page should contain    This code is replaced with survey result (if the survey was completed)
        Page should contain    Rounded result
        Page should contain    $[207, rounding digits]$
        Page should contain    This code is replaced with survey result (if the survey was completed)
        Page should contain    Rounded result to the rounded digits specified
        Page should contain    $[221]$
        Page should contain    This code is replaced with survey result (if the survey was completed)
        Page should contain    Not rounded result
        Page should contain    $[208]$
        Page should contain    This code is replaced with the branch phone number
        Page should contain    $[210]$
        Page should contain    This code is replaced with the password of the shopper
        Page should contain    $[212]$
        Page should contain    This code is replaced with the user name of the shopper
        Page should contain    $[211]$
        Page should contain    This code is replaced with the user name of the user - not a shopper, but a user
        Page should contain    $[2120]$
        Page should contain    When a message is sent to a shopper, this code is replaced with recipient's user name
        Page should contain    $[2115]$
        Page should contain    When message is sent to a branch contact, this code is replaced with the recipient's contact name
        Page should contain    $[2110]$
        Page should contain    When message is sent to a user, this code is replaced with recipient's user name
        Page should contain    $[2100]$
        Page should contain    This code is replaced with recipient's user name.
        Page should contain    $[626,CustomFieldID]$
        Page should contain    This code returns the textual value that is in the Users custom field.
        Page should contain    $[213]$
        Page should contain    This code is replaced with the name of the client
        Page should contain    $[214]$
        Page should contain    This code is replaced with the address of the branch
        Page should contain    $[215]$
        Page should contain    This code is replaced with the city to which the branch is linked
        Page should contain    $[217]$
        Page should contain    This code is replaced with the opening hours of the branch
        Page should contain    $[218]$
        Page should contain    This code is replaced with the name of the questionnaire
        Page should contain    $[2180]$
        Page should contain    This code is replaced with the ID of the questionnaire
        Page should contain    $[2181]$
        Page should contain    This code is replaced with the text code of the questionnaire
        Page should contain    $[219]$
        Page should contain    This code is replaced with the name of the current review client label
        Page should contain    $[2191]$
        Page should contain    This code is replaced with the name of the next review client label it's going to be automatically changed to
        Page should contain    $[2192]$
        Page should contain    This code is replaced with the date on which it's going to be changed automatically to the next client label
        Page should contain    $[2193]$
        Page should contain    This code is replaced with the number of days remaining to be changed automatically to the next client label
        Page should contain    $[220]$
        Page should contain    This code is replaced with the code of the current language
        Page should contain    $[222]$
        Page should contain    This code is replaced with the Email of the shopper
        Page should contain    $[225]$
        Page should contain    This code is replaced with the ID number of the project
        Page should contain    $[226]$
        Page should contain    This code is replaced with the name of the project
        Page should contain    $[240]$
        Page should contain    This code is replaced with the Purchase Invoice number
        Page should contain    $[241]$
        Page should contain    This code is replaced with the Purchase Invoice value
        Page should contain    $[242]$
        Page should contain    This code is replaced with the Order Briefing
    ###
        Page should contain    $[300]$
        Page should contain    This code is replaced with the description of the order with html tags
        Page should contain    $[301]$
        Page should contain    This code is replaced with the date of the order
        Page should contain    $[302]$
        Page should contain    This code is replaced with the time of the order
        Page should contain    $[303]$
        Page should contain    This code is replaced with the purchase description of the order
        Page should contain    $[304]$
        Page should contain    This code is replaced with the purchase sum limit for the order
        Page should contain    $[307]$
        Page should contain    This code is replaced with the description of the order without html tags
        Page should contain    $[700]$
        Page should contain    Will return 1 if user is using a Mobile device and 0 if not
        Page should contain    $[800]$
        Page should contain    This code returns a numeric value that represents current date
        Page should contain    $[801]$
        Page should contain    This code returns a numeric value that represents current time
        Page should contain    $[310]$
        Page should contain    This code returns date and time of review start time
        Page should contain    $[311]$
        Page should contain    This code returns date and time of review finish time
        Page should contain    $[312]$
        Page should contain    This code returns numeric value of review start time
        Page should contain    $[313]$
        Page should contain    This code returns numeric value of review finish time
        Page should contain    $[326]$
        Page should contain    This code is replaced with the Phone of the shopper
        Page should contain    $[333]$
        Page should contain    This code is replaced with the order ID number.
        Page should contain    $[334]$
        Page should contain    This code is replace with the publicized application comment.
    ###
        Page should contain    $[500,sample_field_name]$
        Page should contain    In telephonic survey mode, returns the value of the specified sample field which is associated with the current survey.
        Page should contain    $[305,CustomFieldID]$
        Page should contain    This code returns the textual value that is in the Order custom field.
        Page should contain    $[306,CustomFieldID]$
        Page should contain    This code returns the textual value that is in the Branch custom field.
        Page should contain    $[501,sample_field_name,days_to_count]$
        Page should contain    In telephonic survey mode, returns the number of completed surveys to the specific value for the field.
        Page should contain    Example:
        Page should contain    sample_field_name: city
        Page should contain    days_to_count: 14
        Page should contain    The result will be the number of completed surveys for the same city name as the current record in the last 14 days
        Page should contain    $[510]$
        Page should contain    This code is replaced with the link that is defined for the Email survey invitation
        Page should contain    $[600,ProductID]$
        Page should contain    For POS reviews, will return the total items counted for the specified Product ID
        Page should contain    Using Question Groups
        Page should contain    In order to point to question groups use following format:
        Page should contain    Regular question    Question in Question Group
        Page should contain    question_object_id    question_group_object_id;title_id;question_object_id
        Page should contain    question_code    question_group_code;title_id;question_code
        Page should contain    * available for codes 1,2,3,11,12,13
        Page should contain    Codes which change the text format.
        Page should contain    Important, please notice: in screens that have the graphical editor, there is no need to use the following design codes.
        Page should contain    Those codes are consisted of an opening code and a closing code, which defines the text section that you would like to modify (as in HTML). You must specify both of them, otherwise they will be ignored by the system.
        Page should contain    Here are the codes:
        Page should contain    [b]Bold text[/b]
        Page should contain    [i]Italic text[/i]
        Page should contain    [u]Underline text[/u]
        Page should contain    You may use several codes in the same line, and even use nested codes.
        Page should contain    For every object defined in the survey group, exists a field called "Display condition", which allows to show that object only if a certain condtion is true.
        Page should contain    If the condition is empty (which is the default), the object will be always shown. Otherwise the condition will be checked and the object will be shown only if the condition is fulfilled.
        Page should contain    If the condition depends on an answer chosen in a previous question, the system will automatically add a page break before the object containing that condition.
        Page should contain    Right now, display conditions consist of a comparison of a content code and a specified value (those are the same content codes explained above). The condition format is as follows:
        Page should contain    To check for equality: code='value'
        Page should contain    To check for inequality: code!='value'
        Page should contain    To check if code is bigger than a value: code>value
        Page should contain    To check if code is bigger or equal to a value: code>=value
        Page should contain    To check if code is smaller than a value: code<value
        Page should contain    To check if code is smaller or equal to a value: code<=value
        Page should contain    To check if value exists in a list: value in_array (value1,value2,...)
        Page should contain    To check if value is in a string: value in_string (value1)
        Page should contain    To check if value is in one of strings from the list: value in_strings (value1,value2,...)
        Page should contain    To round a number with a specific number of decimals, use this format: (number~precision)
        Page should contain    For example:
        Page should contain    ($[207]$~2)
        Page should contain    The value has to be inside single quotes.
        Page should contain    For example, if you want text to appear only if the answer "Yes" was chosen in a question before that text, while the question identifier is 3030, you have to write the following display condition in the text object:
        Page should contain    $[1,3030]$='yes'
        Page should contain    You may define several conditions, which have to be fullfilled altogether. In order to do that, seperate the conditions with the & symbol for AND condtion and || symbol for OR condtion.
        Page should contain    For example:
        Page should contain    $[1,3030]$='Yes' & $[201]$='London'
        Page should contain    and with and OR condtion:
        Page should contain    $[1,3030]$='Yes' || $[201]$='London'
    END
    Close Browser
    [Teardown]    Close Browser.AD

Operation > Internet survey shows a reached quota message
    [Tags]    Internet    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${ISurveyName}=    Set variable    RF Survey 01 [Internet Survey]
        Set global variable    ${ISurveyName}
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Search the Q-ry (via search bar).AD    RF Questionnaire [Internet]
        Search Client.AD    ${RobotTestClient}
        Edit ISurvey.AD    0    RF Questionnaire [Internet]    BranchFullname 05 (for Internet Surveys)
        Log to console    Starting the review if quota is reached at ${URL}/i_survey-fill.php?SurveyID=${ReviewID}
        go to.AD    ${URL}/i_survey-fill.php?SurveyID=${ReviewID}
        Page should contain    Quota reached message: "sorry, this survey`s quota has been exceeded"
        Page should contain    What is a survey quota?
        Page should contain    A survey quota is the number of observations needed to meet a specified requirement, such as the number of men and the number of women to complete a survey.
        Page should contain    RF REVN DT:
        Log to console    Done. Status - OK. Quota reached message is seen.
    END
    Close Browser
    [Teardown]    Close Browser.AD

Operation > Pass Internet survey
    [Tags]    Internet    Jenkins
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${ISurveyName}=    Set variable    RF Survey 01 [Internet Survey]
        ${Branch}=    Set variable    RF Branch 11 (Internet Surveys) [Short name]
        Set global variable    ${ISurveyName}
        Set global variable    ${Branch}
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Search the Q-ry (via search bar).AD    RF Questionnaire [Internet]
        Get question ID
        Search Client.AD    ${RobotTestClient}
        Edit ISurvey.AD    1000000    RF Questionnaire [Internet]    ${Branch}
        go to.AD    ${URL}/i_survey-fill.php?SurveyID=${ReviewID}
        Log to console    Starting the review at ${URL}/i_survey-fill.php?SurveyID=${ReviewID}
        Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF - INTERNET SURVEY    2000    I am free text entered by reviewer - ${DD.MM.YY} RF - INTERNET SURVEYEXTRACHARACTERS    Internal message added by RF shopper (date: ${DD.MM.YY})    NO
        Click element    id=finishCrit
        Wait Until Page Contains    Thank you message
        Page Should contain    You have completed the RF survey, thank you for participating
        Page Should contain    Thank you for taking the time to complete this survey.
        Page Should contain    The fact that you are reading this message indicates that you have completed our survey
        Page Should contain    and that we owe you a debt of thanks.
        Page Should contain    We are very appreciative of the time you have taken to assist in our analysis and commit to utilizing the information gained to contemplate and implement worthwhile improvements.
        Wait Until Page Contains    The Professional Platform For    20
        ${Pageurl} =    Execute Javascript    return window.location.href
        Should be equal    ${Pageurl}    https://www.checker-soft.com/
        Log to console    Survey is finished. Thank you message is seen. User is redirected to saved link --> ${Pageurl} (in 3 seconds)
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Review completed (internet review).AD    RF Branch 11 (Internet Surveys) [Short name]    46.40
    #    Run Keyword If    '${check emails?}'=='True'    GMAIL: check subject and body.AD    Email subject: RF Alert 02 (Finished) rev date (${DD.MM.YY}); Status (Finished, awaiting approval)    This is an alert text ("RF Alert 02 (Finished)")    info-${URL1index}-system@checker-soft.com
    END
    Close Browser
    [Teardown]    Close Browser.AD
