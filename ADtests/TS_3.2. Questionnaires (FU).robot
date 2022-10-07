*** Settings ***
Suite Setup
Suite Teardown    Close All Browsers
Library           SeleniumLibrary
Library           DateTime
Library           pabot.PabotLib
Resource          ${CURDIR}/Resources/CheckerLibUI.txt
Resource          ${CURDIR}/Resources/Settings.txt
Library           openpyxl
Library           OpenPyxlLibrary
Library           ExcelLibrary
Library           Collections
Library           ExcellentLibrary
Resource          Resources/EDITORMSGs.txt
Library           ExcelLibrary
Library           RequestsLibrary

*** Test Cases ***
Client task type is created successfully
    [Tags]    Questionnaire
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${name}=    set variable    Client task type 01 [RF]
        set global variable    ${name}
    ###
        go to.AD    ${URL}/client-task-types.php
        Check if sorting is visible.AD    id="table_rows"
        Select dropdown.AD    //*[@id="side_menu"]/tbody/tr/td[3]/form/table/tbody/tr/td[2]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'${RobotTestClient}')]
        Wait until page contains element    //button[@class='btn-input']
        ${element visible?}    Run keyword and return status    Page should contain    ${name}
        Run keyword if    ${element visible?}==False    click element    //*[@id="big_tedit_wrapping_table"]/tbody/tr/td/table/tbody/tr/td/button
        Run keyword if    ${element visible?}==True    click link    default=${name}
        Wait until page contains element    //input[@id='field_TaskTypeName']
        Input text    //input[@id='field_TaskTypeName']    ${name}
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    successfully
        Wait until page contains    ${name}
    ###
        go to.AD    ${URL}/client-task-types.php
        Wait until page contains element    //button[@class='btn-input']
        Select dropdown.AD    //*[@id="side_menu"]/tbody/tr/td[3]/form/table/tbody/tr/td[2]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'${RobotTestClient}')]
        ${element visible?}    Run keyword and return status    Page should contain    ${name}
        Run keyword if    ${element visible?}==False    click element    //*[@id="big_tedit_wrapping_table"]/tbody/tr/td/table/tbody/tr/td/button
        Run keyword if    ${element visible?}==True    click link    default=${name}
        Page should contain    ${name}
        log to console    "${name}" has been created    Sorting is not visible
    ###
        go to.AD    ${URL}/client-task-types.php
        Select dropdown.AD    //*[@id="side_menu"]/tbody/tr/td[3]/form/table/tbody/tr/td[2]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'${RobotTestClient}')]
        Wait until page contains element    //button[@class='btn-input']
        ${element visible?}    Run keyword and return status    Page should contain    To be deleted
        Run keyword if    ${element visible?}==False    click element    //*[@id="big_tedit_wrapping_table"]/tbody/tr/td/table/tbody/tr/td/button
        Run keyword if    ${element visible?}==True    click link    default=To be deleted
        Wait until page contains element    //input[@id='field_TaskTypeName']
        Input text    //input[@id='field_TaskTypeName']    To be deleted
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    successfully
        Wait until page contains    To be deleted
        Check if sorting is visible.AD    id="table_rows"
    ###
        go to.AD    ${URL}/client-task-types.php
        Wait until page contains element    //button[@class='btn-input']
        Select dropdown.AD    //*[@id="side_menu"]/tbody/tr/td[3]/form/table/tbody/tr/td[2]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'${RobotTestClient}')]
        ${element visible?}    Run keyword and return status    Page should contain    To be deleted
        Run keyword if    ${element visible?}==True    click link    default=To be deleted
        click element    //input[@id='delete']
        click element    //input[@id='sure_delete']
        go to.AD    ${URL}/client-task-types.php
        Wait until page contains element    //button[@class='btn-input']
        Select dropdown.AD    //*[@id="side_menu"]/tbody/tr/td[3]/form/table/tbody/tr/td[2]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'${RobotTestClient}')]
        Page should not contain    To be deleted
    END
    Close Browser
    [Teardown]    Close Browser.AD

Questionnaire type characteristics is created successfully
    [Tags]    Questionnaire
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Add Questionnaire type characteristics.AD    RF.AutoTests 5 min [Q-re type charac-s]    5    100
        Add Questionnaire type characteristics.AD    RF.AutoTests 10 min [Q-re type charac-s]    10    88
    ###
    END
    Close Browser
    [Teardown]    Close Browser.AD

Custom scales > Custom scales is created successfully
    [Tags]    Questionnaire
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${scale name}=    set variable    AGE scale 01 [RF]
        set global variable    ${scale name}
    ###
        GET alt lang ID.AD    Robot language [LTR]
        GET alt lang ID.AD    Robot language [RTL]
        Search CScale.AD    ${scale name}
    ###
        Wait until page contains element    //input[@id='field_ScaleName']
        Scroll element into view    //input[@id='field_ScaleName']
        Input text    //input[@id='field_ScaleName']    ${scale name}
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    successfully
        Wait until page contains    ${scale name}
        log to console    "${scale name}" scale has been added/updated
        ${element visible?}    Run keyword and return status    Page should contain    ${scale name}
        Run keyword if    ${element visible?}==False    click element    //button[@class='btn-input']
        Run keyword if    ${element visible?}==True    Get ID    id="table_rows"    ${scale name}    1    2
        Run keyword if    ${element visible?}==True    go to    ${URL}/custom-scales.php?edit=${found ID}
        ${Scale ID}    Set variable    ${found ID}
        set global variable    ${Scale ID}
        Add question (Scale).AD    1    15-25(green)    rgb(69, 220, 21)    10.00    1    45dc15
        Add question (Scale).AD    2    26-35(black)    rgb(19, 21, 19)    20.00    2    131513
        Add question (Scale).AD    3    36-45(red)    rgb(218, 34, 0)    30.00    3    da2200
        Add question (Scale).AD    4    46-55(yellow)    rgb(215, 218, 23)    40.00    4    d7da17
        Add question (Scale).AD    5    56+(blue)    rgb(5, 35, 148)    50.00    5    052394
    END
    Close Browser
    [Teardown]    Close Browser.AD

Questions bank > Section + qn(s) are created successfully
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${RF section 1}=    set variable    Section 01 [RF]
        set global variable    ${RF section 1}
        ${RF sub section 1}=    set variable    Sub Section 01 [RF]
        set global variable    ${RF sub section 1}
        ${RF sub section 2}=    set variable    Sub Section 02 [RF]
        set global variable    ${RF sub section 2}
        GET alt lang ID.AD    Robot language [RTL]
        GET alt lang ID.AD    Robot language [LTR]
    ###
        Add QD section.AD    ${RF section 1}
        Add QB subsection.AD    ${RF sub section 1}    6aae0e    1    Custom
    #    ###Dispaly types:    Radio buttons    Slider    Drop-down    Basic selection (choose with CTRL)    Basic selection (choose with CTRL)    Check boxes    Ranking check boxes    Rating-stars
    #    Delete QB q-n.AD
    END
    Close Browser
    [Teardown]    Close Browser.AD

Questions bank > Section + qn(s) are deleted successfully
    [Tags]    (FIX?)
    [Template]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        GET alt lang ID.AD    Robot language [LTR]
        GET alt lang ID.AD    Robot language [RTL]
        ${RF section 1}=    set variable    - Questions Types - [RF]
        set global variable    ${RF section 1}
        ${RF sub section 1}=    set variable    Custom
        ${RF sub section 2}=    set variable    Text-only
        ${RF sub section 3}=    set variable    Custom scale
        ${RF sub section 4}=    set variable    Multiple choice, average
        ${RF sub section 5}=    set variable    Multiple choice, accumulating
        ${RF sub section 6}=    set variable    Multiple choice, according to highest score
        ${RF sub section 7}=    set variable    Multiple choice, according to lowest score
        ${RF sub section 8}=    set variable    quOrdered
        Add QD section.AD    ${RF section 1}
        #    Add QB subsection.AD    SubSection: "${RF sub section 1}"    6aae0e    1    Custom
        #    Add QB subsection.AD    SubSection: "${RF sub section 2}"    daec15    2    Text-only
        #    Add QB subsection.AD    SubSection: "${RF sub section 3}"    cdd21f    3    Custom scale
        #    Add QB subsection.AD    SubSection: "${RF sub section 4}"    1fd2ae    4    Multiple choice, average
        Add QB subsection.AD    SubSection: "${RF sub section 5}"    1a6052    5    Multiple choice, accumulating
        Add QB subsection.AD    SubSection: "${RF sub section 6}"    c6cc9c    6    Multiple choice, according to highest score
        Add QB subsection.AD    SubSection: "${RF sub section 7}"    0ccb6e    7    Multiple choice, according to lowest score
    #    Add QB subsection.AD    SubSection: "${RF sub section 8}"    c3277f    8    quOrdered
    ###Display types:    Radio buttons    Slider    Drop-down    Basic selection (choose with CTRL)    Basic selection (choose with CTRL)    Check boxes    Ranking check boxes    Rating-stars
    #    Delete QB q-n.AD
    END
    Close Browser
    [Teardown]    Close Browser.AD

New questionnaire is created successfully + grant access (Shopper)
    [Tags]    Editor    Questionnaire
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${Robot q-ry}=    set variable    RF Questionnaire [Shoppers]
        set global variable    ${Robot q-ry}
        Set Records per page    100
        #    Search profile.AD    ${RobotTestShopper 02}
        #    Edit shopper profile.AD    ${RobotTestShopper 02}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        Edit questionnaire.AD    RFQRY-SHO-03    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Set Change condition.AD    Q3
        Check questionnaire access
        Validate and Import questions.AD    RF QRY [TESTING].xlsx    RF QRY [PREPRODUCTION].xlsx    RF QRY [DEMO].xlsx
        Set q-ry brief.AD
    #    Get question ID
    END
    Close Browser
    [Teardown]    Close Browser.AD

New questionnaire is created successfully (Internet)
    [Tags]    Editor    Questionnaires
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${Robot q-ry}=    set variable    RF Questionnaire [Internet]
        set global variable    ${Robot q-ry}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        Edit questionnaire.AD    RFQRY-INT-05    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Set q-ry brief.AD
        Validate and Import questions.AD    RF QRY [TESTING].xlsx    RF QRY [PREPRODUCTION].xlsx    RF QRY [DEMO].xlsx
    #    Get question ID
    END
    Close Browser
    [Teardown]    Close Browser

New questionnaire is created successfully (Customers)
    [Tags]    Editor    Questionnaire
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${Robot q-ry}=    set variable    RF Questionnaire [Customers]
        set global variable    ${Robot q-ry}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        Edit questionnaire.AD    RFQRY-CUS-02    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Set q-ry brief.AD
        Validate and Import questions.AD    RF QRY [TESTING].xlsx    RF QRY [PREPRODUCTION].xlsx    RF QRY [DEMO].xlsx
        Get question ID
    END
    Close Browser
    [Teardown]    Close Browser.AD

New questionnaire is created successfully (Surveys)
    [Tags]    Editor    Questionnaire
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${Robot q-ry}=    set variable    RF Questionnaire [Surveys]
        set global variable    ${Robot q-ry}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        Edit questionnaire.AD    RFQRY-SUR-01    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Set q-ry brief.AD
        Validate and Import questions.AD    RF QRY [TESTING].xlsx    RF QRY [PREPRODUCTION].xlsx    RF QRY [DEMO].xlsx
        Get question ID
    END
    Close Browser
    [Teardown]    Close Browser.AD

New questionnaire is created successfully (Field)
    [Tags]    Editor    Questionnaire
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${Robot q-ry}=    set variable    RF Questionnaire [Field]
        set global variable    ${Robot q-ry}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        Edit questionnaire.AD    RFQRY-FIE-09    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Set q-ry brief.AD
        Validate and Import questions.AD    RF QRY [TESTING].xlsx    RF QRY [PREPRODUCTION].xlsx    RF QRY [DEMO].xlsx
        Get question ID
    END
    Close Browser
    [Teardown]    Close Browser.AD

New questionnaire is created successfully (Panel)
    [Tags]    Editor    Questionnaire
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${Robot q-ry}=    set variable    RF Questionnaire [Panel]
        set global variable    ${Robot q-ry}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        Edit questionnaire.AD    RFQRY-PAN-06    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Set q-ry brief.AD
        Validate and Import questions.AD    RF QRY [TESTING].xlsx    RF QRY [PREPRODUCTION].xlsx    RF QRY [DEMO].xlsx
        Get question ID
    END
    Close Browser
    [Teardown]    Close Browser.AD

New questionnaire is created successfully (Training)
    [Tags]    Editor    Questionnaire
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${Robot q-ry}=    set variable    RF Questionnaire [Training]
        set global variable    ${Robot q-ry}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        Edit questionnaire.AD    RFQRY-TRA-07    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Set q-ry brief.AD
        Validate and Import questions.AD    RF QRY [TESTING].xlsx    RF QRY [PREPRODUCTION].xlsx    RF QRY [DEMO].xlsx
        Get question ID
    END
    Close Browser
    [Teardown]    Close Browser.AD

New questionnaire is created successfully (SMS)
    [Tags]    Editor    Questionnaire
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${Robot q-ry}=    set variable    RF Questionnaire [SMS]
        set global variable    ${Robot q-ry}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        Edit questionnaire.AD    RFQRY-SMS-08    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Set q-ry brief.AD
        Validate and Import questions.AD    RF QRY [TESTING].xlsx    RF QRY [PREPRODUCTION].xlsx    RF QRY [DEMO].xlsx
        Get question ID
    END
    Close Browser
    [Teardown]    Close Browser.AD

New questionnaire is created successfully (Email)
    [Tags]    Editor    Questionnaire
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${Robot q-ry}=    set variable    RF Questionnaire [Email]
        set global variable    ${Robot q-ry}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        Edit questionnaire.AD    RFQRY-EMA-11    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Set q-ry brief.AD
        Validate and Import questions.AD    RF QRY [TESTING].xlsx    RF QRY [PREPRODUCTION].xlsx    RF QRY [DEMO].xlsx
        Get question ID
    END
    Close Browser
    [Teardown]    Close Browser.AD

New questionnaire is created successfully (POS)
    [Tags]    Editor    Questionnaire
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${Robot q-ry}=    set variable    RF Questionnaire [POS]
        set global variable    ${Robot q-ry}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        Edit questionnaire.AD    RFQRY-POS-10    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Set q-ry brief.AD
        Validate and Import questions.AD    RF QRY [TESTING].xlsx    RF QRY [PREPRODUCTION].xlsx    RF QRY [DEMO].xlsx
        Get question ID
    END
    Close Browser
    [Teardown]    Close Browser.AD

New questionnaire is created successfully (Certificate)
    [Tags]    Editor    Questionnaire
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${Robot Certificate}=    set variable    RF 001-Shopper Registration [Certificate]
        ${Robot Description Certificate}=    set variable    RF Certificate for shopper self registration (RF REVN DT: ${DD.MM.YY})
        ${Robot q-ry}=    set variable    RF Questionnaire [Certificate]
        set global variable    ${Robot q-ry}
        set global variable    ${Robot Certificate}
        set global variable    ${Robot Description Certificate}
        Search the Q-ry(via table).AD    ${Robot q-ry}    7
        Edit questionnaire.AD    RFQRY-CER-04    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Set q-ry brief.AD
        Check questionnaire access
        Validate and Import questions.AD    RF QRY [TESTING].xlsx    RF QRY [PREPRODUCTION].xlsx    RF QRY [DEMO].xlsx
        Search Certificate    ${Robot Certificate}
    END
    Close Browser
    [Teardown]    Close Browser.AD

New questionnaire is created successfully (GLOBAL)
    [Tags]    Editor
    [Setup]
    [Template]
    [Timeout]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        #    Get Shopper property ID. AD    Autotest property [RF]
        #    GET alt lang ID.AD    Robot language [LTR]
        #    GET alt lang ID.AD    Robot language [RTL]
        #    Search client using search bar.AD
        #    Get BR property ID. AD    Model
        #    Get section ID. AD    Section 01 [RF]
    #
        #    Search CScale.AD    AGE scale 01 [RF]
        #    IMPORT_Update excel file (custom scale)    ${Scale ID}
        ${Robot q-ry}=    set variable    RF Questionnaire [GLOBAL]
        set global variable    ${Robot q-ry}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        #    Edit questionnaire.AD    RFQRY-CER-04    Flat average - questions average only    //div[9]/ul/li[3]/label    do not allow
        Check questionnaire access
        #    Set q-ry brief.AD
        #    Delete prev questions
        #    [Qry] Add qry object.AD    Text    RF Text 01    c:Text01    $[213]$='AUTO 01 [RF CLIENT]'    ${RF qry - text 01}
        #    [Qry] Add qry object.AD    Picture    RF Picture 01    c:RFPic01    1=1    ${CURDIR}\\Resources\\Extra files\\IMAGES\\RF checker.gif
        #    [Qry] Add qry object.AD    Page Break    -    c:Pagebreak01    1=1    -
        #    [Qry] Import qn.AD    RF QRY [GLOBAL].xlsx
        #    Go to2.AD    ${URL}/setedit-frameset.php?SetID=${found ID}
        #    Wait until page contains    ${Robot q-ry}
        #    select frame    objects
        #    Page should contain    Q1
        #    [Qry] Add qry object.AD    Unconditional jump    -    c:UncJump    1=1    Jump
        #    [Qry] Add qry object.AD    Worker input    -    c:WorInp    $[12,Q3,6]$=1    RF Worker input (Optional)
        #    [Qry] Add qry object.AD    Branch selection    -    c:BranSelec    $[12,Q3,6]$=1    RF Branch selection (Mandatory)
        #    [Qry] Add qry object.AD    Finish time input    -    c:FinisTime    $[12,Q3,6]$=1    RF Finish time input (Mandatory)
        #    [Qry] Add qry object.AD    Sample field input    -    c:SamField    $[12,Q3,6]$=1    RF Sample field input (Mandatory)
        #    [Qry] Add qry object.AD    Countdown Timer    RF Countdown Timer    c:CountdownTimer    1=1    -
        #    GET qns.AD    0
        #    [Qry] Add qry object.AD    Change condition    Final grade    50    $[213]$='AUTO 01 [RF CLIENT]'    -
        #    GET qns.AD    0
        #    [Qry] Edit QN.AD    ${Dictionary2}[Q1]    Check boxes    -
        #    [Qry] Edit QN.AD    ${Dictionary2}[Q2]    Radio buttons    -
        #    [Qry] Edit QN.AD    ${Dictionary2}[Q3]    Drop-down    -
        #    [Qry] Edit QN.AD    ${Dictionary2}[Q4]    Check boxes    -
        #    [Qry] Edit QN.AD    ${Dictionary2}[Q5]    Check boxes    -
        #    [Qry] Edit QN.AD    ${Dictionary2}[Q6]    Check boxes    -
        #    [Qry] Edit QN.AD    ${Dictionary2}[Q7]    Radio buttons    -
        #    [Qry] Edit QN.AD    ${Dictionary2}[Q8]    Check boxes    $[1,${Dictionary2}[Q7]]$='YES+'
        #    [Qry] Edit QN.AD    ${Dictionary2}[Q9]    Drop-down    $[2,${Dictionary2}[Q4]]$=22
        #    [Qry] Edit QN.AD    ${Dictionary2}[Q10]    Check boxes    $[12,Q9,3]$=1 & $[12,Q9,4]$=1    #press continue to check code!
        #    [Qry] Edit QN.AD    ${Dictionary2}[Q11]    Rating-stars    -
        #    [Qry] Edit QN.AD    ${Dictionary2}[Q12]    Drop-down    -
        #    [Qry] Edit QN.AD    ${Dictionary2}[Q13]    Check boxes    $[1,${Dictionary2}[Q12]]$='10'
        #    #    #
        #    GET qns.AD    0
        #    #    [Qry] Add qry object.AD    Question group    RF QGroup 01    c:QGroup01    $[2,${Dictionary2}[Q13]]$='robotmailbox01@gmail.com'    5
        #    [Qry] Add qry object.AD    Page Break    -    c:Pagebreak02    1=1    -
        #    #
        #    Set text for code text table [qns]
        #    #    [Qry] Add qry object.AD    Text    RF Text 02    c:Text02    $[213]$='AUTO 01 [RF CLIENT]' & $[11,Q1]$=2    ${TEXT CODE TABLE Qns CODES}
        #    #    [Qry] Add qry object.AD    Text    RF Text 03    c:Text03    $[11,Q1]$=2    ${TEXT CODE TABLE Branches, Clients, Users and Shoppers CODES}
        #    [Qry] Add qry object.AD    Text    RF Text 04    c:Text04    ($[200]$='RF Branch 01 [Full name]')=1 & $[11,Q1]$=2 & 1=2    ${TEXT CODE TABLE Samples CODES}
        #    #[Qry] Add qry object.AD    Text    RF Text 05    c:Text05    $[11,Q1]$=2    ${TEXT CODE TABLE Qn Groups CODES}
        #    #    [Qry] Add qry object.AD    Text    RF Text 06    c:Text06    $[11,Q1]$=2    ${TEXT CODE TABLE Orders CODES}
        #    #    [Qry] Add qry object.AD    Text    RF Text 07    c:Text07    1=1    <p>This Is the End and THANK YOU!</p>
        GET qns.AD    1
        go to.AD    ${URL}/i_survey-fill.php?SurveyID=227
        Fill in review as a shopper(GLOBAL).SD    //input[@id='finishCrit']
    END
    Close Browser
    [Teardown]
