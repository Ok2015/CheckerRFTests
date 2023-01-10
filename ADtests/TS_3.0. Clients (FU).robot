*** Settings ***
Suite Setup
Suite Teardown    Close All Browsers
Library           SeleniumLibrary
Library           DateTime
Library           pabot.PabotLib
Resource          ${CURDIR}/Resources/CheckerLibUI.txt
Resource          ${CURDIR}/Resources/EDITORMSGs.txt
Resource          ${CURDIR}/Resources/Settings.txt
Library           ImapLibrary
Library           FtpLibrary

*** Test Cases ***
Client. Add client and edit
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=chrome
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD    ${RobotTestClient}
        Edit client.AD
        Run keyword and ignore error    Select client users for alerts
        Login as a Shopper
        go to.AD    ${URL}/c_ordered-crits.php
        Page should contain    ${RF Type of client}
        go to.AD    ${URL}/colorwheel-select.php
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Deactivation/Activation
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        Deactivate client    ${found ID}
        Search Element.AD    ${RobotTestClient}    id=clients_table
        ${status}    Get text    //*[@id="clients_table"]/tbody/tr/td[7]
        Element text should be    //*[@id="clients_table"]/tbody/tr/td[7]    No
        Log to console    Client status is "Not active" on search result page
        Check errors on page [-1]
        Activate client    ${found ID}
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Create graph color groups for client
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        Set client report custom text.AD
        Set visit report settings.AD
        Set client report settings.AD
        Validate graph level    "Low level"    0    10    rgb(224, 44, 10)
        Validate graph level    "Poor level"    11    45    rgb(239, 231, 67)
        Validate graph level    "Good level"    45    60    rgb(230, 134, 0)
        Validate graph level    "Excellent level"    60    500    rgb(113, 196, 6)
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Create graph color group and delete it
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Check errors on page [-1]
        Search client using search bar.AD    ${RobotTestClient}
        ${Level name}=    set variable    Level (to delete)    #max 25 letters in title
        set global variable    ${Level name}
        Validate graph level    ${Level name}    1000    2000    rgb(230, 134, 0)
        go to.AD    ${URL}/client-graph-color-groups.php?page_var_divide_recordsPerPage=500&&ClientID=${found ID}
        Log to console    Let`s add graph color that already exists in a system (same "name" and "min-max" ranges)
        Wait until page contains element    //button[@class='btn-input']
        Page should contain element    xpath=//a[@href="clients.php?edit=${found ID}"]
        Page should contain element    xpath=//a[@href="clients.php?highlight_id=${found ID}"]
        Page should contain element    xpath=//a[@href="main-menu.php"]
        go to.AD    ${URL}/client-graph-color-groups.php?addnew=yup&ClientID=${found ID}
        Wait until page contains element    //input[@id='field_ColorGroupName']
        Input text    //input[@id='field_ColorGroupName']    ${Level name}
        Input text    //input[@id='field_RangeStart']    3000
        Input text    //input[@id='field_RangeEnd']    3500
        Click element    //input[@id='field_FinalResult']
        Click element    //input[@id='field_FinalResult']
        Click element    //input[@id='field_Chapter']
        Click element    //input[@id='field_Question']
        Click element    //*[@id="idLevelColorEditbox"]/table/tbody/tr/td/div/div[1]/div
        Wait until page contains element    //body/div[2]/div[2]/div[2]/input
        Input text    //body/div[2]/div[2]/div[2]/input    rgb(124,252,0)
        Click element    //button[@class='sp-choose']
        Click element    //input[@id='addnew']
        Wait until page contains    already exists
        Log to console    "Already exists" error is seen
        go to.AD    ${URL}/client-graph-color-groups.php?page_var_divide_recordsPerPage=500&&ClientID=${found ID}
        ${element present?}=    Run Keyword And Return Status    Page should contain    ${Level name}
        Run Keyword If    '${element present?}'=='False'    Create graph color groups for client    ${Level name}    1000    2000    rgb(230, 134, 0)
        Run Keyword If    '${element present?}'=='True'    click link    default=${Level name}
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        Click element    //input[@id='delete']
        Click element    //input[@id='sure_delete']
        go to.AD    ${URL}/client-graph-color-groups.php?page_var_divide_recordsPerPage=500&&ClientID=${found ID}
        Page should not contain    ${Level name}
        Log to console    "${Level name}" has been deleted properly
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Add label, edit and delete
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${LabelName}=    Set variable    RF AutoLabel - to be deleted
        Set global variable    ${LabelName}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        Add/Edit label.AD    ${LabelName}    0    0    None
        go to.AD    ${URL}/client-statuses.php?ClientID=${found ID}
        wait until page contains element    //button[@class='btn-input']
        #Select dropdown    //*[@id="TableEdit_filtering"]/tbody/tr/td/div/div/table/tbody/tr/td/span/button    //body/div[2]/ul/li[1]/label/span
        ${IsElementVisible}=    Run keyword and return status    Page should contain    ${LabelName}
        Run Keyword If    ${IsElementVisible}    Log to console    Deleting the label (name = "${LabelName}")
        ...    ELSE    Add new label.AD
        click link    default=${LabelName}
        Wait until page contains element    //input[@id='delete']
        click element    //input[@id='delete']
        click element    //input[@id='sure_delete']
        Page should contain    deleted successfully
        go to.AD    ${URL}/client-statuses.php?ClientID=${found ID}
        Page should not contain    ${LabelName}
        Log to console    Status: OK. "${LabelName}" has been deleted.
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Add auto label
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${LabelName 01}=    Set variable    RF Label 01 [Automatically change to this label]
        ${LabelName 02}=    Set variable    RF Label 02 [Manually change to this label]
    #
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        Add/Edit label.AD    ${LabelName 01}    0    0    true
    #
        Add/Edit label.AD    ${LabelName 02}    0    0    None
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Add worker
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD    ${RobotTestClient}
        Add client worker.AD    RF Worker 01 [Active]    true    workercode-001
        Add client worker.AD    RF Worker 02 [Not Active]    None    workercode-002
    #
        go to.AD    ${URL}/client-workers.php?ClientID=${client ID}
        Wait until page contains element    //button[@class='btn-input']
        Select dropdown.AD    //*[@id="TableEdit_filtering"]/tbody/tr/td[1]/div/div/table/tbody/tr/td/span/button    xpath=//li[contains(.,'(All)')]
        Element text should be    //*[@id="table_rows"]/tbody/tr/td[1]/a    RF Worker 01 [Active]
        Run Keyword and ignore error    Element text should be    //*[@id="table_rows"]/tbody/tr/td[2]    ${Short auto branch name 01}
        Element text should be    //*[@id="table_rows"]/tbody/tr/td[3]    workercode-001
        Element text should be    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][3]    Yes
        Element text should be    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][4]    Task: to create and validate orders
        Element text should be    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][5]    Comment: internal worker
        Log to console    Worker(s) were added/updated successfully
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[1]/a    Worker name
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[2]    Short branch name
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[3]    Worker code
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[4]    Active?
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[5]    Task
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[6]    Comment
        Element text should be    //*[@id="table_rows"]/tbody/tr[2]/td[1]/a    RF Worker 02 [Not Active]
        Run Keyword and ignore error    Element text should be    //*[@id="table_rows"]/tbody/tr[2]/td[2]    ${Short auto branch name 01}
        Element text should be    //*[@id="table_rows"]/tbody/tr[2]/td[3]    workercode-002
        Element text should be    //*[@id="table_rows"]/tbody/tr[2]/td[4]    No
        Element text should be    //*[@id="table_rows"]/tbody/tr[2]/td[5]    Task: to create and validate orders
        Element text should be    //*[@id="table_rows"]/tbody/tr[2]/td[6]    Comment: internal worker
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Add active project
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD    ${RobotTestClient}
        go to.AD    ${URL}/projects.php?ClientID=${client ID}
        Wait until page contains element    //*[@id="big_tedit_wrapping_table"]/tbody/tr[1]/td/table/tbody/tr/td/button
        ${proj visible?}=    Run Keyword and return status    Page should contain    ${RF Project}
        Run Keyword If    ${proj visible?}    click element    //table/tbody/tr/td[2]/table[4]/tbody/tr/td[3]/table/tbody/tr[2]/td/table/tbody/tr/td/form/table/tbody/tr/td[1]/a
        Run Keyword If    "${proj visible?}"=="False"    click element    //*[@id="big_tedit_wrapping_table"]/tbody/tr[1]/td/table/tbody/tr/td/button
        Wait until page contains element    //input[@id='field_ProjectName']
    #
        Page should contain    Only users who are linked to AUTO 01 [RF CLIENT] are shown
        Page should contain    To be apply pins color on map for mobile application job board only.
        Input text    //input[@id='field_ProjectName']    ${RF Project}
        Run keyword and ignore error    Select dropdown.AD    //*[@id="idUsernameEditbox"]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'${RobotAnalystUser 01}')]
        Click element    //*[@id="idColorEditbox"]/table/tbody/tr/td/div/div[2]
        Input text    //div[2]/div[2]/div[2]/input    rgb(63, 227, 14)
        Click element    //body/div[2]/div[2]/div[4]/button
        Set checkbox.AD    //input[@id='field_IsActive']    true
        Input text    //input[@id='field_StartDate']    01-01-2022
        Input text    //input[@id='field_CreationDate']    31-12-2022
        Click element    //input[@id='field_CreationDate']
        Validate style.AD    //*[@id="idColorEditbox"]/table/tbody/tr/td/div/div[1]/div    background-color: rgb(63, 227, 14);
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    Project '${RF Project}'
        Wait until page contains    successfully
        Log to console    Project '${RF Project}' added/edited successfully
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[1]    ProjectID
        Element text should be    //tr[@class='db']/th[@class='db-ltr'][1]    Project name
        Element text should be    //tr[@class='db']/th[@class='db-ltr'][2]    Active?
        Element text should be    //tr[@class='db']/th[@class='db-ltr'][3]    Start date
        Element text should be    //tr[@class='db']/th[@class='db-ltr'][4]    End date
        Element text should be    //tr[@class='db']/th[@class='db-ltr'][5]    Responsible manager name
        Element text should be    //tr[@class='db']/th[@class='db-ltr'][6]    Color
        Element text should be    //*[@id="table_rows"]/tbody/tr/td[2]    ${RF Project}
        Element text should be    //*[@id="table_rows"]/tbody/tr/td[3]    Yes
        Element text should be    //*[@id="table_rows"]/tbody/tr/td[4]    01.01.2022
        Element text should be    //*[@id="table_rows"]/tbody/tr/td[5]    31.12.2022
        Run keyword and ignore error    Element text should be    //*[@id="table_rows"]/tbody/tr/td[6]    ${RobotAnalystUser 01}
        Page should contain    Edit projects for client
        ${actual name}=    Get Text    //*[@id="table_rows"]/tbody/tr/td[2]
        Run Keyword If    '${actual name}'=='${RF Project}'    Get ID (table)    //*[@id="table_rows"]/tbody/tr/td[1]    //*[@id="table_rows"]/tbody/tr/td[2]
        go to.AD    ${URL}/projects.php?edit=${found ID}&ClientID=${client ID}
        Wait until page contains element    //input[@id='field_ProjectName']
        Validate value (value)    //input[@id='field_ProjectName']    ${RF Project}
        Run Keyword If    ${testing?}    Validate value (text)    //*[@id="idUsernameEditbox"]/table/tbody/tr/td/span/button    ${RobotAnalystUser 01}
        Validate style.AD    //*[@id="idColorEditbox"]/table/tbody/tr/td/div/div[1]/div    background-color: rgb(63, 227, 14);
        Checkbox should be selected    //input[@id='field_IsActive']
        Validate value (value)    //input[@id='field_StartDate']    01-01-2022
        Validate value (value)    //input[@id='field_CreationDate']    31-12-2022
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Add not active project
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD    ${RobotTestClient}
        go to.AD    ${URL}/projects.php?ClientID=${client ID}
        Wait until page contains element    //button[@class='btn-input']
        ${RF Project not active}    Set variable    RF NOT ACTIVE project 2022 [PROJECT]
        Set global variable    ${RF Project not active}
        ${proj visible?}=    Run Keyword and return status    Page should contain    ${RF Project not active}
        Run Keyword If    ${proj visible?}    click element    //*[@id="table_rows"]/tbody/tr[2]/td[1]/a
        Run Keyword If    "${proj visible?}"=="False"    click element    //*[@id="big_tedit_wrapping_table"]/tbody/tr[1]/td/table/tbody/tr/td/button
        Wait until page contains element    //input[@id='field_ProjectName']
    #
        Page should contain    Only users who are linked to AUTO 01 [RF CLIENT] are shown
        Page should contain    To be apply pins color on map for mobile application job board only.
        Input text    //input[@id='field_ProjectName']    ${RF Project not active}
        Run keyword and ignore error    Select dropdown.AD    //*[@id="idUsernameEditbox"]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'${RobotAnalystUser 01}')]
        Click element    //*[@id="idColorEditbox"]/table/tbody/tr/td/div/div[2]
        Input text    //div[2]/div[2]/div[2]/input    e3210e
        Click element    //body/div[2]/div[2]/div[4]/button
        Set checkbox.AD    //input[@id='field_IsActive']    None
        Input text    //input[@id='field_StartDate']    01-01-2022
        Input text    //input[@id='field_CreationDate']    31-12-2022
        Click element    //input[@id='field_CreationDate']
        Validate style.AD    //*[@id="idColorEditbox"]/table/tbody/tr/td/div/div[1]/div    background-color: rgb(227, 33, 14);
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    Project '${RF Project not active}'
        Wait until page contains    successfully
        Log to console    Project '${RF Project not active}' added/edited successfully
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[1]    ProjectID
        Element text should be    //tr[@class='db']/th[@class='db-ltr'][1]    Project name
        Element text should be    //tr[@class='db']/th[@class='db-ltr'][2]    Active?
        Element text should be    //tr[@class='db']/th[@class='db-ltr'][3]    Start date
        Element text should be    //tr[@class='db']/th[@class='db-ltr'][4]    End date
        Element text should be    //tr[@class='db']/th[@class='db-ltr'][5]    Responsible manager name
        Element text should be    //tr[@class='db']/th[@class='db-ltr'][6]    Color
        Element text should be    //*[@id="table_rows"]/tbody/tr[2]/td[2]    ${RF Project not active}
        Element text should be    //*[@id="table_rows"]/tbody/tr[2]/td[3]    No
        Element text should be    //*[@id="table_rows"]/tbody/tr[2]/td[4]    01.01.2022
        Element text should be    //*[@id="table_rows"]/tbody/tr[2]/td[5]    31.12.2022
        Run keyword and ignore error    Element text should be    //*[@id="table_rows"]/tbody/tr[2]/td[6]    ${RobotAnalystUser 01}
        Page should contain    Edit projects for client
        ${actual name}=    Get Text    //*[@id="table_rows"]/tbody/tr[2]/td[2]
        Run Keyword If    '${actual name}'=='${RF Project not active}'    Get ID (table)    //*[@id="table_rows"]/tbody/tr[2]/td[1]    //*[@id="table_rows"]/tbody/tr[2]/td[2]
        go to.AD    ${URL}/projects.php?edit=${found ID}&ClientID=${client ID}
        Wait until page contains element    //input[@id='field_ProjectName']
        Validate value (value)    //input[@id='field_ProjectName']    ${RF Project not active}
        Run keyword and ignore error    Validate value (text)    //*[@id="idUsernameEditbox"]/table/tbody/tr/td/span/button    ${RobotAnalystUser 01}
        Validate style.AD    //*[@id="idColorEditbox"]/table/tbody/tr/td/div/div[1]/div    background-color: rgb(227, 33, 14);
        Checkbox Should Not Be Selected    //input[@id='field_IsActive']
        Validate value (value)    //input[@id='field_StartDate']    01-01-2022
        Validate value (value)    //input[@id='field_CreationDate']    31-12-2022
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Add visit template
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD    ${RobotTestClient}
        go to.AD    ${URL}/client-visit-reports.php?&ClientID=${client ID}
        Wait until page contains    Client name: ${RobotTestClient}
        Wait until page contains    Visit report templates
        ${is element visible?}    Run keyword and return status    Page should contain    ${RF visit template}
        Run Keyword If    ${is element visible?}    Click link    default=${RF visit template}
        ...    ELSE    Click element    //*[@id="big_tedit_wrapping_table"]/tbody/tr[1]/td/table/tbody/tr/td/button
        Wait until page contains element    //input[@id='field_VisitReportName']
        Input text    //input[@id='field_VisitReportName']    ${RF visit template}
        Validate value (value)    //input[@id='field_VisitReportName']    ${RF visit template}
        Select dropdown.AD    //*[@id="idReportFormatEditbox"]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'excel2007')]
        Set checkbox.AD    //input[@id='field_AllowToAllBranches']    true
        Set checkbox.AD    //input[@id='field_AllowToAllSets']    true
        Validate value (text)    //*[@id="idReportFormatEditbox"]/table/tbody/tr/td/span/button    excel2007
        Choose File    //table/tbody/tr/td[1]/table/tbody/tr[5]/td[2]/input[1]    ${CURDIR}\\Resources\\Extra files\\Questionnaires\\RF QRY [TESTING].xlsx
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    successfully
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Add alert(s)
    [Tags]    Editor    Alert
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${AlertName 01}=    Set variable    RF Alert 01 (Accepted)
        Set global variable    ${AlertName 01}
        ${AlertName 02}=    Set variable    RF Alert 02 (Finished)
        Set global variable    ${AlertName 02}
        ${AlertName 03}=    Set variable    RF Alert 03 (Approved)
        Set global variable    ${AlertName 03}
        ${AlertName 04}=    Set variable    RF Alert 04 (NOT ACTIVE)
        Set global variable    ${AlertName 04}
    #
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        Add/Edit alert.AD    Accepted, awaiting implementation    ${AlertName 01}    1=1    xpath=//li[contains(.,'Survey report')]    Attachment    None    true    ${empty}    true    None    This is an alert text "${AlertName 01}" ${Usual Text Codes Table} ${RF REVN DT}    No    None
        Add/Edit alert.AD    Finished, awaiting approval    ${AlertName 02}    1=1    xpath=//li[contains(.,'Survey report-v6')]    Attachment    None    true    ${empty}    true    None    This is an alert text "${AlertName 02}" ${Usual Text Codes Table} ${RF REVN DT}    No    None
        Add/Edit alert.AD    Approved    ${AlertName 03}    1=1    xpath=//li[contains(.,'EmailVisitReport')]    Attachment    None    true    ${empty}    true    None    This is an alert text "${AlertName 03}" ${Usual Text Codes Table} ${RF REVN DT}    No    None
    END
    Close Browser
    [Teardown]    Close Browser.AD

Alert. Send alert email with attachments + HTML
    [Tags]    Editor    Alert    runme
    [Setup]
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${AlertName}=    Set variable    RF_ALERT REVIEW - $[203]$ - WITH ATTACHMENTS
        Set global variable    ${AlertName}
    #
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
    #
        Get section ID. AD    Section 01 [RF]
        Get BR property ID. AD    Manager
        Get project ID.AD    RF ACTIVE project 2022 [PROJECT]
    #
        Add/Edit alert.AD    Approved    ${AlertName}    $[221]$>=0    xpath=//li[contains(.,'EmailVisitReport')]    List    true    true    ${SP user email address}    None    None    This is an alert text "${AlertName}" ${Usual Text Codes Table} ${Branch property text codes} ${Section text codes} ${RF REVN DT}    No    None
        Open Operational Panel.AD    Approved    xpath=//li[contains(.,'${RobotTestClient}')]
        Get Review handling details page.AD    ${ReviewID}
    #
        Simulate alert.AD
        Check report-failed-email page.AD    Email subject: RF_ALERT REVIEW - ${ReviewID} - WITH ATTACHMENTS
        ${passed}=    Run Keyword And Return Status    GMAIL: GET ALERT EMAIL.SD    Email subject: RF_ALERT REVIEW - ${ReviewID} - WITH ATTACHMENTS    RF SP user
    #
        Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
        Run Keyword If    ${passed}==False    Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
    END
    Close Browser
    [Teardown]    Close Browser.AD

FTP Alert - file HTML
    [Tags]    Editor    Alert
    [Setup]
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${AlertName}=    Set variable    RF_ALERT - FTP - HTML
        Set global variable    ${AlertName}
    #CASE 1
        Log to console    ${\n}(!) CASE 1: Attached files (not archived) can be seeen/downloaded on FTP
        Empty Directory    ${CURDIR}\\Resources\\Extra files\\FTP files    # on local system
        Log to console    Target local folder is cleaned before test: ${CURDIR}\\Resources\\Extra files\\FTP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        Add/Edit alert.AD    Approved    ${AlertName}    $[221]$>=0    xpath=//li[contains(.,'Survey report-File HTML')]    Attachment    true    true    ${empty}    None    None    This is an alert text "${AlertName}" ${RF REVN DT}    Yes    None
        Open Operational Panel.AD    Approved    xpath=//li[contains(.,'${RobotTestClient}')]
    #
        ${ReviewID}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[2]/a[1]
        Set global variable    ${ReviewID}
        Get attached files (Review handling details page).AD    ${ReviewID}    Not archived
    #
        Simulate alert.AD
        Connect FTP    ${ReviewID}.htm    Not archived
    #CASE 2
        Log to console    ${\n}(!) CASE 2: Attached files (archived) can not be seeen/downloaded via FTP
        Log to console    Target local folder is cleaned before test: ${CURDIR}\\Resources\\Extra files\\FTP
        Empty Directory    ${CURDIR}\\Resources\\Extra files\\FTP files    # on local system
        Simulate alert.AD
        Connect FTP    ${ReviewID}.htm    Archived
    #
        Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
        ${passed}     Run Keyword And Warn On Failure    Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
    END
    Close Browser
    [Teardown]    Close Browser.AD

Alert. Send alert to special email with PDF +no attachment (positive + negative)
    [Tags]    Editor    Alert
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${AlertName}=    Set variable    RF_ALERT REVIEW - $[203]$ - NO ATTACHMENTS
        Set global variable    ${AlertName}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
    #
        Log to console    CASE 1: POSITIVE, send alert and check alert body
        go to.AD    ${URL}/client-statuses.php?&ClientID=${found ID}
        Get section ID. AD    Section 01 [RF]
        Get BR property ID. AD    Manager
        Get project ID.AD    RF ACTIVE project 2022 [PROJECT]
        ${Attachment}    Set variable    None
        Set global variable    ${Attachment}
    #
        Open Operational Panel.AD    Approved    xpath=//li[contains(.,'${RobotTestClient}')]
        Wait until page contains element    //*[@id="table_rows"]/tbody/tr[1]/td[3]/a[1]
        ${ReviewID}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[2]/a[1]
        Set global variable    ${ReviewID}
        Get Review handling details page.AD    ${ReviewID}
        Get Order details page.AD    ${Dictionary}[OrderID]
        Add/Edit alert.AD    Approved    ${AlertName}    $[207]$=${Rounded result} || $[221]$>=${Dictionary}[Result] & $[218]$='RF Questionnaire [Shoppers]' || $[204]$='RFCheckerCode_02'    xpath=//li[contains(.,'Survey report-v6')]    None    true    None    ${RFShopperEmail}    None    None    This is an alert text "${AlertName}" ${Usual Text Codes Table} ${Branch property text codes} ${Section text codes} ${RF REVN DT}    No    None
    #
        Simulate alert.AD
        Check report-failed-email page.AD    Email subject: RF_ALERT REVIEW - ${ReviewID} - NO ATTACHMENTS
    #
        GMAIL: GET ALERT EMAIL.SD    Email subject: RF_ALERT REVIEW - ${ReviewID} - NO ATTACHMENTS    RF Shopper
    #
        Log to console    CASE 2: NEGATIVE, alert which will be not sent due to false score alert condition
        Add/Edit alert.AD    Approved    ${AlertName}    $[207]$=3690 || $[221]$>=4500 & $[218]$='RF Questionnaire [Shoppers]' || $[204]$='RFCheckerCode_02'    xpath=//li[contains(.,'Survey report-v6')]    None    true    None    ${RFShopperEmail}    true    None    This is an alert text "${AlertName}" ${RF REVN DT}    No    None
    #
        Simulate alert.AD
        Check report-failed-email page.AD    Email subject: RF_ALERT REVIEW - ${ReviewID} - NO ATTACHMENTS
    #
        ${results}=    Run keyword and return status    GMAIL: GET ALERT EMAIL.SD    Email subject: RF_ALERT REVIEW - ${ReviewID} - NO ATTACHMENTS    RF Shopper
        Should Be Equal As Strings    ${results}    False
        Log to console    ---------Actual Status---------: ${\n} NO ALERT EMAIL IS RECEIVED (+)
    #
        Log to console    CASE 3: NEGATIVE, alert will be not sent due to false (qre name) alert condition
        Add/Edit alert.AD    Approved    ${AlertName}    $[207]$=${Rounded result} || $[221]$>=${Dictionary}[Result] & $[218]$='RF Questionnaire [Shoppers 2]' & $[204]$='RFCheckerCode_02'    xpath=//li[contains(.,'Survey report-v6')]    None    true    None    ${RFShopperEmail}    true    None    This is an alert text "${AlertName}" ${RF REVN DT}    No    None
        Simulate alert.AD
        Check report-failed-email page.AD    Email subject: RF_ALERT REVIEW - ${ReviewID} - NO ATTACHMENTS
    #
        ${results}=    Run keyword and return status    GMAIL: GET ALERT EMAIL.SD    Email subject: RF_ALERT REVIEW - ${ReviewID} - NO ATTACHMENTS    RF Shopper
        Should Be Equal As Strings    ${results}    False
        Log to console    ---------Actual Status---------: ${\n} NO ALERT EMAIL IS RECEIVED (+)
        Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
        Run Keyword If    ${results}==True    Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
    END
    Close Browser
    [Teardown]    Close Browser.AD

Alert. Create alert and delete it
    [Tags]    Editor    Alert
    [Setup]
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${AlertName}=    Set variable    RF_ALERT - TO BE DELETED
        Set global variable    ${AlertName}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
    #
        Add/Edit alert.AD    Finished, awaiting approval    ${AlertName}    $[221]$>=0 & $[218]$='RF Questionnaire [Shoppers]'    xpath=//li[contains(.,'EmailVisitReport')]    List    true    true    ${RFShopperEmail}    true    None    Some contetnt goes here    No    None
    #
        Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
    #
        go to.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}
        Click link    default=${AlertName}
        Set checkbox.AD    //*[@id="field_IsActive"]    None
        Click element    //input[@id='delete']
        Wait until page contains element    //input[@id='sure_delete']
        Click element    //input[@id='sure_delete']
        Wait until page contains    ${AlertName} deleted successfully
    END
    Close Browser
    [Teardown]    Close Browser.AD

Alert. Send alert email to all branch contact with attachments + HTML
    [Tags]    Editor    Alert
    [Setup]
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${AlertName}=    Set variable    RF_ALERT TO ALL BRANCH CONTACTS - REVIEW - $[203]$
        Set global variable    ${AlertName}
    #
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
    #
        Get section ID. AD    Section 01 [RF]
        Get BR property ID. AD    Manager
        Get project ID.AD    RF ACTIVE project 2022 [PROJECT]
    #
        Add/Edit alert.AD    Approved    ${AlertName}    $[221]$>=0    xpath=//li[contains(.,'EmailVisitReport')]    List    true    true    ${empty}    None    None    This is an alert text "${AlertName}" ${Usual Text Codes Table} ${Branch property text codes} ${Section text codes} ${RF REVN DT}    No    None
        Open Operational Panel.AD    Approved    xpath=//li[contains(.,'${RobotTestClient}')]
        Get Review handling details page.AD    ${ReviewID}
    #
        Simulate alert.AD
        Check report-failed-email page.AD    Email subject: RF_ALERT REVIEW - ${ReviewID} - WITH ATTACHMENTS
    #
        ${passed}=    Run Keyword And Return Status    GMAIL: GET ALERT EMAIL.SD    Email subject: RF_ALERT TO ALL BRANCH CONTACTS - REVIEW - ${ReviewID}    RF Shopper
    #
        Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
        Run Keyword If    ${passed}==False    Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
    END
    Close Browser
    [Teardown]    Close Browser.AD

FTP Alert - PDF
    [Tags]    Editor    Alert
    [Setup]
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${AlertName}=    Set variable    RF_ALERT - FTP - PDF
        Set global variable    ${AlertName}
    #CASE 1
        Log to console    ${\n}(!) CASE 1: Attached files (not archived) can be seeen/downloaded via FTP
        Empty Directory    ${CURDIR}\\Resources\\Extra files\\FTP files    # on local system
        Log to console    Target local folder is cleaned before test: ${CURDIR}\\Resources\\Extra files\\FTP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        Add/Edit alert.AD    Approved    ${AlertName}    $[221]$>=0    xpath=//li[contains(.,'Survey report-v6')]    Attachment    true    true    ${empty}    None    None    This is an alert text "${AlertName}" ${RF REVN DT}    Yes    None
        Open Operational Panel.AD    Approved    xpath=//li[contains(.,'${RobotTestClient}')]
    #
        ${ReviewID}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[2]/a[1]
        Set global variable    ${ReviewID}
        Get attached files (Review handling details page).AD    ${ReviewID}    Not archived
    #
        Simulate alert.AD
        Connect FTP    ${ReviewID}.pdf    Not archived
    #CASE 2
        Log to console    ${\n}(!) CASE 2: Attached files (archived) can not be seeen/downloaded via FTP
        Log to console    Target local folder is cleaned before test: ${CURDIR}\\Resources\\Extra files\\FTP
        Empty Directory    ${CURDIR}\\Resources\\Extra files\\FTP files    # on local system
        Simulate alert.AD
        ${Archived?}    Run keyword and return status    Page should contain    Archived
        Run keyword if    ${any attachment?}>0 and ${Archived?}==False    Click element    //tbody/tr[2]/td/fieldset/form[@id='_attachments']/input[2]
        Run keyword if    ${any attachment?}>0 and ${Archived?}==False    Click element    //tbody/tr[2]/td/fieldset/form[@id='_attachments']/input[4]
        Run keyword if    ${any attachment?}>0    Page should contain    Archived
        ${passed}=    Run Keyword And Return Status    Connect FTP    ${ReviewID}.pdf    Archived
        Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
        Run Keyword If    ${passed}==False    Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
    END
    Close Browser
    [Teardown]    Close Browser.AD

Alert. Send alert email to role
    [Tags]    Editor
    [Setup]
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${AlertName}=    Set variable    RF_ALERT TO ROLE - REVIEW - $[203]$
        Set global variable    ${AlertName}
    #
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        Create/update role.AD    ${RF role name}
        Search user profile.AD    ${RobotSPUser 01}    Special permissions
        #    Search user profile.AD    RF user 03 [SP USER]    Special permissions
    #
        Get section ID. AD    Section 01 [RF]
        Get BR property ID. AD    Manager
        Get project ID.AD    RF ACTIVE project 2022 [PROJECT]
    #
        Add/Edit alert.AD    Approved    ${AlertName}    $[221]$>=0    xpath=//li[contains(.,'EmailVisitReport')]    List    true    true    ${empty}    true    None    This is an alert text "${AlertName}" ${Usual Text Codes Table} ${Branch property text codes} ${Section text codes} ${RF REVN DT}    No    None
        Open Operational Panel.AD    Approved    xpath=//li[contains(.,'${RobotTestClient}')]
        Get Review handling details page.AD    ${ReviewID}
    #
        Simulate alert.AD
        Check report-failed-email page.AD    Email subject: RF_ALERT REVIEW - ${ReviewID} - WITH ATTACHMENTS
        ${passed}=    Run Keyword And Return Status    GMAIL: GET ALERT EMAIL.SD    Email subject: RF_ALERT TO ROLE - REVIEW - ${ReviewID}    RF SP user
    #
        Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
        Run Keyword If    ${passed}==False    Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
    END
    Close Browser
    [Teardown]    Close Browser.AD

Alert. Send concentrated alert
    [Tags]    Editor    Alert
    [Setup]
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${AlertName}=    Set variable    RF_ALERT - CONCENTRATED ALERT
        Set global variable    ${AlertName}
    #
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        Get section ID. AD    Section 01 [RF]
        Get BR property ID. AD    Manager
        Get project ID.AD    RF ACTIVE project 2022 [PROJECT]
        Add/Edit alert.AD    Approved    ${AlertName}    $[221]$>=0    xpath=//li[contains(.,'EmailVisitReport')]    List    true    true    ${empty}    None    true    This is an alert text "${AlertName}" ${Usual Text Codes Table} ${Branch property text codes} ${Section text codes} ${RF REVN DT}    No    None
        go to.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Dictionary}[${RobotTestClient}]
        Click link    default=${AlertName}
        Wait until page contains element    //*[@id="idNoAlertsWeekdaysEditbox"]/table/tbody/tr/td/span/button
        Click element    //*[@id="idNoAlertsWeekdaysEditbox"]/table/tbody/tr/td/span/button
        Set checkbox.AD    //input[@id='field_AllowEmailDigest']    true
        Manage allowed users.AD    //td[3]/div[2]/select[@id='SelectedUsers']    ROBOT [MANAGER] (ROBOT [MANAGER])    //*[@id="bla1"]    //tbody/tr[28]/td[2]/table/tbody/tr/td[2]/input[@id='moveButton']
        Click Save/Add/Delete/Cancel button.AD
        Open Operational Panel.AD    Approved    xpath=//li[contains(.,'${RobotTestClient}')]
    #
        ${1 Finished review ID}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[2]/a[1]
        ${2 Finished review ID}    Get text    //*[@id="table_rows"]/tbody/tr[2]/td[2]/a[1]
        Set global variable    ${1 Finished review ID}
        Set global variable    ${2 Finished review ID}
        Log to console    Sending alert for ${1 Finished review ID} and ${2 Finished review ID}
        Execute JavaScript    window.document.getElementById("filter_1").scrollIntoView(true)
        Sleep    1
        Click element    //*[@id="table_rows"]/tbody/tr[1]/td[1]/input
        Sleep    1
        Click element    //*[@id="table_rows"]/tbody/tr[2]/td[1]/input
        Sleep    1
        Execute JavaScript    window.document.getElementById("checkAndSendAlerts").scrollIntoView(true)
        Click element    //input[@id='checkAndSendAlerts']
        Wait until page contains    Alerts sent for: ${1 Finished review ID}, ${2 Finished review ID}
        go to.AD    ${URL}/report-failed-email.php
        Log to console    Checking failed email reports page...
        ${text visible?}    Run keyword and return status    Page should contain    Email subject: ${AlertName}
        Log to console    Alert failed? -> "${text visible?}"
        Run keyword if    ${text visible?}    Get ID    id="table_rows"    Email subject: ${AlertName}    2    8
        sleep    1
        Run keyword if    ${text visible?}    Click element    //*[@id="table_rows"]/tbody/tr[${final index}]/td[1]/input
        Run keyword if    ${text visible?}    Click element    //*[@id="side_menu"]/tbody/tr/td/form[1]/input[2]
        Run keyword if    ${text visible?}    Wait until page contains    Done
        ${passed}=    Run Keyword And Return Status    GMAIL: GET ALERT EMAIL.SD    Email subject: ${AlertName}    RF Manager
    #
        ${passed}=    Run Keyword And Return Status    Get Review handling details page.AD    ${1 Finished review ID}
        ${passed}=    Run Keyword And Return Status    Check default codes table    ${1 Finished review ID}
        ${passed}=    Run Keyword And Return Status    Get Review handling details page.AD    ${2 Finished review ID}
        ${passed}=    Run Keyword And Return Status    Check default codes table    ${2 Finished review ID}
        #    #
        Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
        Run Keyword If    ${passed}==False    Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
    END
    Close Browser
    [Teardown]    Close Browser.AD

Alert. Do not send alert on days
    [Tags]    Editor    Alert
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${AlertName}=    Set variable    RF_ALERT REVIEW - $[203]$ - DO NOT SEND ON DAYS
        Set global variable    ${AlertName}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        Add/Edit alert.AD    Approved    ${AlertName}    1=1    xpath=//li[contains(.,'Survey report-v6')]    None    true    None    ${RFShopperEmail}    None    None    123    No    None
        go to.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}
        Click link    default=${AlertName}
        Wait until page contains element    //*[@id="idNoAlertsWeekdaysEditbox"]/table/tbody/tr/td/span/button
        Click element    //*[@id="idNoAlertsWeekdaysEditbox"]/table/tbody/tr/td/span/button
        Click element    //div[6]/div/ul/li[2]/a/span[2]
        ${Sunday}    Set variable    //input[@id='ui-multiselect-field_NoAlertsWeekdays-option-0']
        ${Monday}    Set variable    //input[@id='ui-multiselect-field_NoAlertsWeekdays-option-1']
        ${Tuesday}    Set variable    //input[@id='ui-multiselect-field_NoAlertsWeekdays-option-2']
        ${Wednesday}    Set variable    //input[@id='ui-multiselect-field_NoAlertsWeekdays-option-3']
        ${Thursday}    Set variable    //input[@id='ui-multiselect-field_NoAlertsWeekdays-option-4']
        ${Friday}    Set variable    //input[@id='ui-multiselect-field_NoAlertsWeekdays-option-5']
        ${Saturday}    Set variable    //input[@id='ui-multiselect-field_NoAlertsWeekdays-option-6']
        Click element    ${${Tday}}
        Click Save/Add/Delete/Cancel button.AD
    #
        go to.AD    ${URL}/operation-panel.php
        Log to console    Searching a RF "Finished, awaiting approval" review
        Wait until page contains element    //input[@id='end_date']
        #    Input text    //input[@id='end_date']    ${date minus 30 days}
        Select dropdown.AD    //*[@id="side_menu"]/tbody/tr/td[3]/form[1]/table/tbody/tr[3]/td[1]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'${RobotTestClient}')]
        Validate value (text)    //*[@id="side_menu"]/tbody/tr/td[3]/form[1]/table/tbody/tr[3]/td[1]/table/tbody/tr/td/span/button    AUTO 01 [RF CLIENT]
        Click element    //input[@id='show']
        Wait until page contains element    //*[@id="table_rows"]/tbody/tr[1]/td[3]/a[1]
        ${Finished review ID}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[2]/a[1]
        Set global variable    ${Finished review ID}
        go to.AD    ${URL}/crit-handling-details.php?CritID=${Finished review ID}
    #
    #
        go to.AD    ${URL}/crit-handling-details.php?CritID=${Finished review ID}
        Log to console    Clicking button - Send Alert if needed
        Click element    //input[@id='checkAndSendAlerts']
        Wait until page contains    Alerts sent
    #
        go to.AD    ${URL}/report-failed-email.php
        Log to console    Checking failed email reports
        ${text visible?}    Run keyword and return status    Page should contain    Email subject: RF_ALERT REVIEW - ${Finished review ID} - DO NOT SEND ON DAYS
        Run keyword if    ${text visible?}    Get ID    id="table_rows"    Email subject: RF_ALERT REVIEW - ${Finished review ID} - DO NOT SEND ON DAYS    2    8
        sleep    1
        ${Time of creation}    Get text    //*[@id="table_rows"]/tbody/tr[${final index}]/td[4]
        ${Scheduled to be sent at}    Get text    //*[@id="table_rows"]/tbody/tr[${final index}]/td[5]
        ${date plus 1 day}    Add Time To Date    ${Ttime}    1 day    result_format=%d.%m.%Y
        Should contain    ${Time of creation}    ${DD.MM.YY}
        Should contain    ${Scheduled to be sent at}    ${date plus 1 day} 00:00
        ${From}    Get text    //*[@id="table_rows"]/tbody/tr[${final index}]/td[6]
        ${Address}    Get text    //*[@id="table_rows"]/tbody/tr[${final index}]/td[7]
        Should contain    ${From}    ${empty}
        Should contain    ${Address}    ${RFShopperEmail}
        Run keyword if    ${text visible?}    Click element    //*[@id="table_rows"]/tbody/tr[${final index}]/td[1]/input
        Run keyword if    ${text visible?}    Click element    //*[@id="side_menu"]/tbody/tr/td/form[1]/input[3]
        Run keyword if    ${text visible?}    Wait until page contains    Deleted: 1
        Log to console    Expected schedule to be sent = TODAY DATE + 1 day = ${date plus 1 day}; From=${From}; Address=${Address}
        Log to console    Scheduled to be sent at = "${Scheduled to be sent at}" (+) Record is deleted
    #
        Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
        Run Keyword If    ${passed}==False    Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
    END
    Close Browser
    [Teardown]    Close Browser.AD

Alert. Send alert email to client users
    [Tags]    Editor    Alert
    [Setup]
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${AlertName}=    Set variable    RF_ALERT TO CLIENT USER - REVIEW - $[203]$
        Set global variable    ${AlertName}
    #
        Log to console    Case 2: send alert for "2" client`s users (1ne user with branch access and 2nd without access - both will receive system alert email)
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        Search user profile.AD    RF user 03 [SP USER]    Special permissions
        Edit branch access    Add all
        Search user profile.AD    RF user 02 [SP USER]    Special permissions
        Edit branch access    Remove all
    #
        Get section ID. AD    Section 01 [RF]
        Get BR property ID. AD    Manager
        Get project ID.AD    RF ACTIVE project 2022 [PROJECT]
        Add/Edit alert.AD    Approved    ${AlertName}    $[221]$>=0    xpath=//li[contains(.,'EmailVisitReport')]    List    true    true    ${empty}    true    None    This is an alert text "${AlertName}" ${Usual Text Codes Table} ${Branch property text codes} ${Section text codes} ${RF REVN DT}    None    None
        go to.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Dictionary}[${RobotTestClient}]
        Click link    default=${AlertName}
        Manage allowed users.AD    //select[@id='SelectedUsers']    RF user 02 [SP USER] (RF user 02 [SP USER])    //select[@id='bla1']    //tbody/tr[28]/td[2]/table/tbody/tr/td[2]/input[@id='moveButton']
        go to.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Dictionary}[${RobotTestClient}]
        Click link    default=${AlertName}
        Manage allowed users.AD    //select[@id='SelectedUsers']    RF user 03 [SP USER] (RF user 03 [SP USER])    //select[@id='bla1']    //tbody/tr[28]/td[2]/table/tbody/tr/td[2]/input[@id='moveButton']
        Open Operational Panel.AD    Approved    xpath=//li[contains(.,'${RobotTestClient}')]
        Get Review handling details page.AD    ${ReviewID}
        Simulate alert.AD
        Check report-failed-email page.AD    Email subject: RF_ALERT TO CLIENT USER - REVIEW - ${ReviewID}
    #
        GMAIL: GET ALERT EMAIL.SD    Email subject: RF_ALERT TO CLIENT USER - REVIEW - ${ReviewID}    RF SP user
        GMAIL: GET ALERT EMAIL.SD    Email subject: RF_ALERT TO CLIENT USER - REVIEW - ${ReviewID}    RF Shopper
    #
        Log to console    Case 2: send alert for "2" client`s users (user with branch access will receive alert and users without branch access - will receive system notice with full review report link)
        Add/Edit alert.AD    Approved    ${AlertName}    $[221]$>=0    xpath=//li[contains(.,'EmailVisitReport')]    List    true    true    ${empty}    true    None    This is an alert text "${AlertName}" ${Usual Text Codes Table} ${Branch property text codes} ${Section text codes} ${RF REVN DT}    None    true
        Simulate alert.AD
        Check report-failed-email page.AD    Email subject: RF_ALERT TO CLIENT USER - REVIEW - ${ReviewID}
        GMAIL: GET ALERT EMAIL.SD    Email subject: RF_ALERT TO CLIENT USER - REVIEW - ${ReviewID}    RF SP user    # system notice because no bran access
        GMAIL: GET ALERT EMAIL.SD    Email subject: RF_ALERT TO CLIENT USER - REVIEW - ${ReviewID}    RF Shopper    # full report
        ${passed}=    Run Keyword And Return Status    GMAIL: GET ALERT EMAIL.SD    Email subject: RF_ALERT TO CLIENT USER - REVIEW - ${ReviewID}    RF Manager    # system notice because no bran access
    #
        Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
        Run Keyword If    ${passed}==False    Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
    END
    Close Browser
    [Teardown]    Close Browser.AD
