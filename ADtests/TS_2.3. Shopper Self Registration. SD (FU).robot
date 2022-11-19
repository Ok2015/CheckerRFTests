*** Settings ***
Test Setup
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
Shopper is registered and autoapproved. FU
    [Tags]    Selfregis+Auth
    [Template]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    Set CF variables
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Define default options for new assessors.AD    true
        Edit shopper self registration messages
        Set "City selection style".AD    Instant search box
        Set assessors self registration options
        go to.AD    ${URL}/company_shopper_reg.php
        Wait until page contains element    //input[@id='field_AllowCheckerSelfReg']
        ${Auto approve self registered}=    Get Element Attribute    //input[@id='field_AutoApproveSelfReg']    checked
        Run keyword if    '${Auto approve self registered}'=='None'    Click element    //input[@id='field_AutoApproveSelfReg']
        ${checked}=    checkbox should be selected    //input[@id='field_AutoApproveSelfReg']
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    Shopper registration settings saved successfully
        Open registration page and check agreement box(es)
        ${random string}=    Generate Random String    8    [LETTERS]
        set global variable    ${random string}
        ${mobile}=    Generate Random String    9    [NUMBERS]
        set global variable    ${mobile}
        Self register of new shopper.SD    RF-${random string}    ${Robot country 01}    ${Robot region 01}    ${Robot city 01}    RF-${random string}@gmail.com    ${mobile}
        Click element    //input[@id='addnew']
        Wait until page contains    Thank you for registering
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Assessor self registration.AD
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/checkers.php?page_var_filter_IsActive=1&page_var_filter_BlackListed=0&page_var_filter_IsSelfRegistered=1&page_var_filter_RegionName=0&page_var_filter_CityName_Cou=&page_var_filter_CityName_Reg=&page_var_filter_CityName=&page_var_filter_Fullname=&page_var_filter_Email=RF-${random string}@gmail.com&update=Please+wait&page_var_sorting_column=Fullname&page_var_sorting_order=up&page_var_divide_recordsPerPage=50&page_var_divide_curPage=1&s=0_2_4_17_21&cc=1
        Wait until page contains element    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-firstcol']
        ${ShopperID}    Get text    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][1]
        Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][5]    RF-${random string}@gmail.com
        Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][2]    Yes
        Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][4]    ${mobile}
        Run Keyword If    ${preprod?}    Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][1]    ${ShopperID}
        Run Keyword If    ${testing?}    Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][1]    RF-${random string}
        Log to console    User self registration is finished with next details:
        Log to console    username: RF-${random string} or ${ShopperID} (preprod only)
        Log to console    email: RF-${random string}@gmail.com
        Log to console    active: Yes
        go to.AD    ${URL}/checkers.php?page_var_filter_IsActive=&page_var_filter_BlackListed=0&page_var_filter_IsSelfRegistered=1&page_var_filter_RegionName=0&page_var_filter_CityName_Cou=&page_var_filter_CityName_Reg=&page_var_filter_CityName=&page_var_filter_Fullname=RF-${random string}
        Wait until page contains    Shoppers
        Run Keyword If    ${preprod?}    Validate value (text)    //td[@class='db-ltr'][1]    RF-${random string} RF-${random string}
        Run Keyword If    ${testing?}    Validate value (text)    //td[@class='db-ltr'][1]    RF-${random string}
        Run Keyword If    ${preprod?}    Element text should be    //td[@class='db-ltr'][2]    ${ShopperID}
        Run Keyword If    ${testing?}    Element text should be    //td[@class='db-ltr'][2]    RF-${random string}
        Element text should be    //td[@class='db-ltr'][4]    Yes
        Element text should be    //td[@class='db-ltr'][5]    Login
        Element text should be    //td[@class='db-ltr'][6]    0
        Element text should be    //td[@class='db-ltr'][7]    Robot country 01
        Element text should be    //td[@class='db-ltr'][8]    Robot region 01
        Element text should be    //td[@class='db-ltr'][9]    Robot city 01
        Element should contain    //td[@class='db-ltr'][10]    860001
        Element text should be    //td[@class='db-ltr'][11]    ${mobile}
        Element text should be    //td[@class='db-ltr'][15]    days
        Element text should be    //td[@class='db-ltr'][16]    1 regions
        Element text should be    //td[@class='db-ltr'][17]    Edit
        Element text should be    //td[@class='db-ltr'][18]    Default
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[1]/a    ShopperID
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[2]    Full name
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[3]    Username
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[4]    Code
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[5]    Active?
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[6]    Login
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[7]    Priority
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[8]    Country name
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[9]    Region name
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[10]    City
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[11]    Postcode
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[12]    Mobile (with country code)
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[13]    Age
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[14]    Shopper comments
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[15]    Refunds
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[16]    Edit availability hours
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[17]    Preferred regions
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[18]    Blocked shoppers
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[19]    CSSFileName
    #
        click element    //tbody/tr[2]/td/div[@id='custom-cols']/a
        ${is element visible}    Run keyword and return status    Page should contain    SHOW ALL COLUMNS
        Run keyword if    ${is element visible}==False    click element    //input[@id='select-all']
        Run keyword if    ${is element visible}==False    Input text    //input[@id='FilterName']    SHOW ALL COLUMNS
        Run keyword if    ${is element visible}==False    click element    //input[@id='SaveFilter']
        Wait until page contains    SHOW ALL COLUMNS
        Select from list by Label    FilterList    SHOW ALL COLUMNS
        Run keyword and ignore error    click element    //input[@id='ShowFilter']
        Wait until page contains element    //*[@id="table_rows"]/thead/tr[1]/th[17]/a
        Wait until page contains element    //*[@id="table_rows"]/thead/tr[1]/th[17]/a
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[17]/a    Latitude
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[18]/a    Longitude
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[1]/a    ShopperID
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[2]    Full name
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[3]    Username
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[4]    Code
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[5]    Active?
        Element text should be    //th[@class='db-ltr'][6]    Login
        Element text should be    //th[@class='db-ltr'][5]    Black listed
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[8]/a    Add VAT
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[9]    Priority
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[10]/a    Time zone
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[11]/a    House number
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[12]/a    Address
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[13]/a    Country name
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[14]    Region name
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[15]    City
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[16]    Postcode
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[19]/a[2]    Mobile (with country code)
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[20]/a    Day time phone (inc int. code)
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[21]/a    Evening phone (inc int. code)
        Element text should be    //th[@class='db-ltr'][23]    Age
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[22]/a    Email
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[26]/a    IdNumber
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[27]/a    SSN
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[25]/a[2]    Shopper comments
        Element text should be    //th[@class='db-ltr'][27]    Availability Radius
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[29]/a    Monthly limit for reviews
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[30]/a    Daily limit for reviews
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[31]    Default language
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[32]    Telephonic
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[33]    Can search telephone records
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[34]    Phone constant bonus
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[35]    Registered by himself?
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[36]    Registration date
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[37]    Authorized to add branches
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[38]    Refunds
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[39]    Edit availability hours
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[40]    Preferred regions
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[41]    Blocked shoppers
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[42]    Authorized to initiate a review
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[43]    Automatic reviews approval
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[44]    Require confirmation after assignment
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[45]    Notify by SMS
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[46]    Notify by email
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[47]    Can edit availability hours
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[48]    Can edit self info
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[49]    Allowed to see questionnaire preview
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[50]    Allowed to see personal review history
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[51]    Allowed to see personal refund report
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[52]    Can add refund records
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[53]    Allowed to edit availability regions
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[54]    Allowed to see branch addresses listing
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[55]    Allowed to apply for orders
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[56]    Allowed IP addresses
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[57]    CSSFileName
    #
        Run Keyword If    ${testing?}    Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[58]    Bank Name
        Run Keyword If    ${testing?}    Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[59]    Bank Branch Name
        Run Keyword If    ${testing?}    Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[60]    Phone for VOIP calls
        Run Keyword If    ${testing?}    Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[61]    Daily regions limit
        Run Keyword If    ${testing?}    Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[62]    Daily cities limit
        Run Keyword If    ${testing?}    Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[63]    Shopper balance
    #
        Run Keyword If    ${preprod?}    Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[58]    Phone for VOIP calls
        Run Keyword If    ${preprod?}    Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[59]    Daily regions limit
        Run Keyword If    ${preprod?}    Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[60]    Daily cities limit
        Run Keyword If    ${preprod?}    Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[61]    Shopper balance
    #
        Run Keyword If    ${preprod?}    Element text should be    //td[@class='db-ltr'][1]    RF-${random string} RF-${random string}
        Run Keyword If    ${testing?}    Element text should be    //td[@class='db-ltr'][1]    RF-${random string}
        Run Keyword If    ${preprod?}    Element text should be    //td[@class='db-ltr'][2]    ${ShopperID}
        Run Keyword If    ${testing?}    Element text should be    //td[@class='db-ltr'][2]    RF-${random string}
        Element text should be    //td[@class='db-ltr'][4]    Yes
        Element text should be    //td[@class='db-ltr'][5]    No
        Element text should be    //td[@class='db-ltr'][6]    Login
        Element text should be    //td[@class='db-ltr'][7]    Yes
        Element text should be    //td[@class='db-ltr'][8]    0
        Element text should be    //td[@class='db-ltr'][9]    Europe/Kiev
        Element text should be    //td[@class='db-ltr'][11]    NY
        Element text should be    //td[@class='db-ltr'][12]    Robot country 01
        Element text should be    //td[@class='db-ltr'][13]    Robot region 01
        Element text should be    //td[@class='db-ltr'][14]    Robot city 01
        Element text should be    //td[@class='db-ltr'][15]    860001
        Run Keyword If    ${testing?}    Element text should be    //td[@class='db-ltr'][16]    43.299431
        Run Keyword If    ${testing?}    Element text should be    //td[@class='db-ltr'][17]    -74.217934
        Element text should be    //td[@class='db-ltr'][18]    ${mobile}
        Run Keyword If    ${testing?}    Element text should be    //td[@class='db-ltr'][19]    ${mobile}
        Run Keyword If    ${testing?}    Element text should be    //td[@class='db-ltr'][20]    ${mobile}
        Element text should be    //td[@class='db-ltr'][21]    RF-${random string}@gmail.com
        Run Keyword If    ${testing?}    Element text should be    //td[@class='db-ltr'][25]    RF-${random string}
        Run Keyword If    ${testing?}    Element text should be    //td[@class='db-ltr'][26]    RF-${random string}
        Run Keyword If    ${preprod?}    Element text should be    //td[@class='db-ltr'][27]    40
        Run Keyword If    ${testing?}    Element text should be    //td[@class='db-ltr'][27]    0
        Element text should be    //td[@class='db-ltr'][28]    240
        Element text should be    //td[@class='db-ltr'][29]    12
        Run keyword and ignore error    Element text should be    //td[@class='db-ltr'][31]    Yes
        Run keyword and ignore error    Element text should be    //td[@class='db-ltr'][32]    Yes
        Element text should be    //td[@class='db-ltr'][33]    0
        Element text should be    //td[@class='db-ltr'][34]    Yes
        Element should contain    //td[@class='db-ltr'][35]    ${DD.MM.YY}
        Element text should be    //td[@class='db-ltr'][36]    Yes
        Element text should be    //td[@class='db-ltr'][38]    days
        Element text should be    //td[@class='db-ltr'][39]    1 regions
        Element text should be    //td[@class='db-ltr'][40]    Edit
        Element text should be    //td[@class='db-ltr'][41]    Yes
        Element text should be    //td[@class='db-ltr'][42]    Yes
        Element text should be    //td[@class='db-ltr'][43]    Yes
        Element text should be    //td[@class='db-ltr'][44]    Yes
        Element text should be    //td[@class='db-ltr'][45]    Yes
        Element text should be    //td[@class='db-ltr'][46]    Yes
        Element text should be    //td[@class='db-ltr'][47]    Yes
        Element text should be    //td[@class='db-ltr'][48]    Yes
        Element text should be    //td[@class='db-ltr'][49]    Yes
        Element text should be    //td[@class='db-ltr'][50]    Yes
        Element text should be    //td[@class='db-ltr'][51]    Yes
        Element text should be    //td[@class='db-ltr'][52]    Yes
        Element text should be    //td[@class='db-ltr'][53]    Yes
        Element text should be    //td[@class='db-ltr'][54]    Yes
        Element text should be    //td[@class='db-ltr'][56]    Default
        Run Keyword If    ${testing?}    Element text should be    //td[@class='db-ltr'][61]    3
        Run Keyword If    ${testing?}    Element text should be    //td[@class='db-ltr'][60]    1
        Run Keyword If    ${testing?}    Element text should be    //td[@class='db-ltr'][62]    0.00
        Run Keyword If    ${preprod?}    Element text should be    //*[@id="table_rows"]/tbody/tr/td[60]    3
        Run Keyword If    ${preprod?}    Element text should be    //*[@id="table_rows"]/tbody/tr/td[59]    1
        Run Keyword If    ${preprod?}    Element text should be    //*[@id="table_rows"]/tbody/tr/td[61]    0.00
        Run Keyword If    ${preprod?}    Element text should be    //*[@id="table_rows"]/tbody/tr/td[17]    42.105522
        Run Keyword If    ${testing?}    Element text should be    //*[@id="table_rows"]/tbody/tr/td[17]    43.299431
        Run Keyword If    ${preprod?}    Element text should be    //*[@id="table_rows"]/tbody/tr/td[18]    -75.923286
        Run Keyword If    ${testing?}    Element text should be    //*[@id="table_rows"]/tbody/tr/td[18]    -74.217934
    END
    close all browsers
    [Teardown]    Close All Browsers

Reviewer with details that already exist in the system can not be registered. FU
    [Tags]    Selfregis+Auth
    [Template]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Set assessors self registration options
        Open registration page and check agreement box(es)
        log to console    ${\n}CASE1: Let`s try to register a user with already registered in a system details (name+email+mobile)
        Self register of new shopper.SD    ${RobotTestShopper 02}    ${Robot country 01}    ${Robot region 01}    ${Robot city 01}    Shopper02_Email_Primary@gmail.com    +380978776567
        Page should contain    Username already exists
        Page should contain    Duplicate field.
        log to console    RESULT: "Duplicate field" and "Username already exists" messages can be seen on a page
        log to console    ${\n}CASE2: Let`s try to register a user with already registered in a system details (email)
        ${random string}=    Generate Random String    4    [LETTERS]
        log to console    Genereting random string (4 letters) and using it as Username, password and email etc (to avoid already registered values in a system). Done: ["${random string}"] will be used in further tests
        Self register of new shopper.SD    ${random string}    ${Robot country 01}    ${Robot region 01}    ${Robot city 01}    Shopper02_Email_Primary@gmail.com    +380978776567
        sleep    2
        ${element present?}=    Run Keyword And Return Status    Page should contain    Duplicate field.
        Run Keyword If    '${element present?}'=='True'    log to console    RESULT: "Duplicate field" message can be seen
        ${element present?}=    Run Keyword And Return Status    Page should contain    These shopper details already exist in the system. You can not register more than once.
        Run Keyword If    '${element present?}'=='True'    log to console    RESULT: "These assessor details already exist in the system. You can not register more than once." message can be seen
        log to console    ${\n}CASE3: Let`s try to register a user with already registered in a system details (phone number)+not valid characters in name and password="${random string}$}?>?>_)(*&!@"
        Open registration page and check agreement box(es)
        Self register of new shopper.SD    ${random string}$}?>?>_)(*&!@    ${Robot country 01}    ${Robot region 01}    ${Robot city 01}    ${random string}@gmail.com    +380978776567
        sleep    2
        Click element    //input[@id='addnew']
    # \ \ \ wait until page contains \ \ \ details already exist in the system. You can not register more than once.
    # \ \ \ log to console \ \ \ RESULT: "These assessor details already exist in the system. You can not register more than once." message can be seen
        #    Page should contain    Username contains invalid characters
        Page should contain    contains invalid characters
        log to console    RESULT: "Password contains invalid characters" and "Username contains invalid characters" messages can be seen
        log to console    ${\n}CASE4: Let`s try to register a user with already registered in a system details (IDNumber, SSN)
        Open registration page and check agreement box(es)
        Self register of new shopper.SD    ${random string}    ${Robot country 01}    ${Robot region 01}    ${Robot city 01}    ${random string}    54353543
        Page should contain    Invalid email address
        Self register of new shopper.SD    ${random string}    ${Robot country 01}    ${Robot region 01}    ${Robot city 01}    ${random string}@gmail.com    345345354
    #go back
        Run Keyword If    ${testing?}    Input Text    //input[@id='field_IdNumber']    IdNumber - RF 001
        Run Keyword If    ${testing?}    Page should contain    Duplicate field.
        Run Keyword If    ${testing?}    log to console    RESULT: IDNumber field="Duplicate field" message can be seen
        Run Keyword If    ${testing?}    Input Text    //input[@id='field_IdNumber']    ${random string}
        Run Keyword If    ${testing?}    Input Text    //input[@id='field_SSN']    SSN - RF 001
        Run Keyword If    ${testing?}    Page should contain    Duplicate field.
        Run Keyword If    ${testing?}    log to console    RESULT: SSN field="Duplicate field" message can be seen
        Input Text    //input[@id='field_BirthDated']    33
        Input Text    //input[@id='field_BirthDatem']    33
        Input Text    //input[@id='field_BirthDatey']    0000
        Run Keyword If    ${testing?}    Input Text    //input[@id='field_SSN']    ${random string}
        click element    //input[@id='field_BirthDated']
        Page should contain    Incorrect age
        Page should contain    * Maximum value is 31
        Page should contain    * Maximum value is 12
        Page should contain    * Minimum value is 1902
        Input Text    //input[@id='field_BirthDatey']    3333
        click element    //input[@id='field_BirthDated']
        Page should contain    * Maximum value is 2015
        log to console    RESULT: Birthday field="Incorrect age" message can be seen
    END
    close all browsers
    [Teardown]    Close Browser.AD

Shopper is registered in case of mandatory fields added by manager. FU (FIX?)
    [Tags]    (FIX?)
    [Template]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    Set CF variables
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
    #Search CF 1
        go to.AD    ${URL}/table-fields.php?page_var_filter_TableLink=Checkers&page_var_sorting_column=FieldName&page_var_sorting_order=up&page_var_divide_recordsPerPage=500
        Set assessors self registration options
        log to console    Let`s search and activate custom fields (8 items, types --> Number, Text line, Text block, Date, Time, Phone, Checkbox, File upload) that will be mandatory and visible on registration page (or create in case if they are missing in a system)
        Search CF via table    ${Test Custom Field1}    Shopper    Number
        Edit CF.AD    true    true    true    true
        ${Test Custom Field1 ID}=    set variable    ${found ID}
        Set global variable    ${Test Custom Field1 ID}
    #Search CF 2
        go to.AD    ${URL}/table-fields.php?page_var_filter_TableLink=Checkers&page_var_sorting_column=FieldName&page_var_sorting_order=up&page_var_divide_recordsPerPage=500
        Search CF via table    ${Test Custom Field2}    Shopper    Text Line
        Edit CF.AD    true    true    true    true
        ${Test Custom Field2 ID}=    set variable    ${found ID}
        Set global variable    ${Test Custom Field2 ID}
    #Search CF 3
        go to.AD    ${URL}/table-fields.php?page_var_filter_TableLink=Checkers&page_var_sorting_column=FieldName&page_var_sorting_order=up&page_var_divide_recordsPerPage=500
        Search CF via table    ${Test Custom Field3}    Shopper    Text block
        Edit CF.AD    true    true    true    true
        ${Test Custom Field3 ID}=    set variable    ${found ID}
        Set global variable    ${Test Custom Field3 ID}
    #Search CF 4
        go to.AD    ${URL}/table-fields.php?page_var_filter_TableLink=Checkers&page_var_sorting_column=FieldName&page_var_sorting_order=up&page_var_divide_recordsPerPage=500
        Search CF via table    ${Test Custom Field4}    Shopper    Date
        Edit CF.AD    true    true    true    true
        ${Test Custom Field4 ID}=    set variable    ${found ID}
        Set global variable    ${Test Custom Field4 ID}
    #Search CF 5
        go to.AD    ${URL}/table-fields.php?page_var_filter_TableLink=Checkers&page_var_sorting_column=FieldName&page_var_sorting_order=up&page_var_divide_recordsPerPage=500
        Search CF via table    ${Test Custom Field5}    Shopper    Time
        Edit CF.AD    true    true    true    true
        ${Test Custom Field5 ID}=    set variable    ${found ID}
        Set global variable    ${Test Custom Field5 ID}
    #Search CF 6
        go to.AD    ${URL}/table-fields.php?page_var_filter_TableLink=Checkers&page_var_sorting_column=FieldName&page_var_sorting_order=up&page_var_divide_recordsPerPage=500
        Search CF via table    ${Test Custom Field6}    Shopper    Phone
        Edit CF.AD    true    true    true    true
        ${Test Custom Field6 ID}=    set variable    ${found ID}
        Set global variable    ${Test Custom Field6 ID}
    #Search CF 7
        go to.AD    ${URL}/table-fields.php?page_var_filter_TableLink=Checkers&page_var_sorting_column=FieldName&page_var_sorting_order=up&page_var_divide_recordsPerPage=500
        Search CF via table    ${Test Custom Field7}    Shopper    Checkbox
        Edit CF.AD    true    true    true    true
        ${Test Custom Field7 ID}=    set variable    ${found ID}
        Set global variable    ${Test Custom Field7 ID}
    #Search CF 8
        go to.AD    ${URL}/table-fields.php?page_var_filter_TableLink=Checkers&page_var_sorting_column=FieldName&page_var_sorting_order=up&page_var_divide_recordsPerPage=500
        Search CF via table    ${Test Custom Field8}    Shopper    Fileupload
        Edit CF.AD    true    true    true    true
        ${Test Custom Field8 ID}=    set variable    ${found ID}
        Set global variable    ${Test Custom Field8 ID}
        Open registration page and check agreement box(es)
        Page should contain    ${Test Custom Field1}
        Page should contain    ${Test Custom Field2}
        Page should contain    ${Test Custom Field3}
        Page should contain    ${Test Custom Field4}
        Page should contain    ${Test Custom Field5}
        Page should contain    ${Test Custom Field6}
        Page should contain    ${Test Custom Field7}
        Page should contain    ${Test Custom Field8}
        log to console    Registration page contains ${Test Custom Field1};${Test Custom Field2};${Test Custom Field3};${Test Custom Field4};${Test Custom Field5};${Test Custom Field6};${Test Custom Field7};${Test Custom Field8}
        Open registration page and check agreement box(es)
        log to console    ${\n}------------------TEST START-------------${\n}
        log to console    ${\n}CASE1(negative): Let`s see if system will throw an error message(s) in case if user tries to register profile with not valid custom field values
        ${random string}=    Generate Random String    6    [LETTERS]
        log to console    Generating random string to be used as username and password. Done: "${random string}"
        set global variable    ${random string}
        ${mobile}=    Generate Random String    5    [NUMBERS]
        log to console    Generating random string to be used as mobile. Done: "${mobile}"
        set global variable    ${mobile}
        Self register of new shopper.SD    RF-${random string}    ${Robot country 01}    ${Robot region 01}    ${Robot city 01}    RF-${random string}@gmail.com    ${mobile}
        Enter not valid registration values
        sleep    1
        Open registration page and check agreement box(es)
        log to console    ${\n}CASE2(positive): Let`s self-register a user using valid custom field values
        Self register of new shopper.SD    RF-${random string}    ${Robot country 01}    ${Robot region 01}    ${Robot city 01}    RF-${random string}@gmail.com    ${mobile}
        Enter valid registration values
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Assessor self registration.AD
        log to console    ${\n}------------------Checking registration results-------------${\n}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Check registered user in admin panel
        log to console    ${\n}------------------TEST END-------------${\n}
    END
    close all browsers
    [Teardown]    Deactivate mandatory CFields

Shopper is registered and autoapproved after passing Certification. FU
    [Tags]    Selfregis+Auth
    [Template]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    Set CF variables
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${Robot Certificate}=    set variable    RF 001-Shopper Registration [Certificate]
        ${Robot Description Certificate}=    set variable    RF Certificate for shopper self registration
        ${Robot q-ry}    set variable    RF Questionnaire [Certificate]
        set global variable    ${Robot Certificate}
        set global variable    ${Robot Description Certificate}
        set global variable    ${Robot q-ry}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
    ###
        go to.AD    ${URL}/sets.php?page_var_filter_IsActive=1&page_var_filter_ClientName=&page_var_filter_SetTypeLink=5&page_var_sorting_column=SetName&page_var_sorting_order=up&page_var_divide_recordsPerPage=100&page_var_divide_curPage=1&popup=
        ${ItemIsVisible}    Run keyword and return status    Page should contain    ${Robot q-ry}
        Run Keyword If    "${ItemIsVisible}"=="False"    Create new questionnaire    ${Robot q-ry}
        ...    ELSE    Log to console    "${Robot q-ry}" questionnaire is found in a system
        go to.AD    ${URL}/sets.php?page_var_filter_IsActive=1&page_var_filter_ClientName=&page_var_filter_SetTypeLink=5&page_var_sorting_column=SetName&page_var_sorting_order=up&page_var_divide_recordsPerPage=100&page_var_divide_curPage=1&popup=
        Run Keyword If    ${ItemIsVisible}    Click link    default=${Robot q-ry}
        Get ID from ad bar.AD    edit=    &popup=&page_var_sorting_column=
        Get question ID
        Search Certificate    ${Robot Certificate}
        Set assessors self registration options
        go to.AD    ${URL}/company_shopper_reg.php
        Wait until page contains element    //input[@id='field_AllowCheckerSelfReg']
        ${Auto approve self registered}=    Get Element Attribute    //input[@id='field_AutoApproveSelfReg']    checked
        Run keyword if    '${Auto approve self registered}'=='None'    Click element    //input[@id='field_AutoApproveSelfReg']
        ${checked}=    checkbox should be selected    //input[@id='field_AutoApproveSelfReg']
        click element    //tr[@id='tr_PostRegistrationCertification']/td[@id='idPostRegistrationCertificationEditbox']/table/tbody/tr/td/span
        set focus to element    xpath=//li[contains(.,'${Robot Certificate}')]
        click element    xpath=//li[contains(.,'${Robot Certificate}')]
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    successfully
    ##
        #    Search the Q-ry(via table).AD    ${Robot q-ry}    7
        #    Edit questionnaire.AD    RFQRY-CER-04    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        #    Set q-ry brief.AD
        #    Validate and Import questions.AD    RF QRY [TESTING].xlsx    RF QRY [PREPRODUCTION].xlsx    RF QRY [DEMO].xlsx
    ##
        Log to console    Let`s create a user
        Open registration page and check agreement box(es)
        ${random string}=    Generate Random String    8    [LETTERS]
        set global variable    ${random string}
        ${mobile}=    Generate Random String    10    [NUMBERS]
        set global variable    ${mobile}
        Self register of new shopper.SD    RF-${random string}    ${Robot country 01}    ${Robot region 01}    ${Robot city 01}    RF-${random string}@gmail.com    ${mobile}
        Click element    //input[@id='addnew']
        Wait until page contains    Thank you for registering
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        sleep    1
        go to.AD    ${URL}/checkers.php?page_var_filter_IsActive=0&page_var_filter_BlackListed=0&page_var_filter_IsSelfRegistered=1&page_var_filter_RegionName=0&page_var_filter_CityName_Cou=&page_var_filter_CityName_Reg=&page_var_filter_CityName=&page_var_filter_Fullname=&page_var_filter_Email=RF-${random string}@gmail.com&update=Please+wait&page_var_sorting_column=Fullname&page_var_sorting_order=up&page_var_divide_recordsPerPage=50&page_var_divide_curPage=1&s=0_2_4_17_21&cc=1
        Wait until page contains element    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-firstcol']
        ${ShopperID}    Get text    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][1]
        Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][5]    RF-${random string}@gmail.com
        Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][2]    No
        Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][4]    ${mobile}
        Run Keyword If    ${preprod?}    Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][1]    ${ShopperID}
        Run Keyword If    ${testing?}    Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][1]    RF-${random string}
        Log to console    Self registration is finished
        Log to console    email: RF-${random string}@gmail.com
        Log to console    active: No
        Run Keyword If    ${preprod?}    Enter login and password.SD    ${ShopperID}    RF-${random string}
        ...    ELSE    Enter login and password.SD    RF-${random string}    RF-${random string}
        go to.AD    ${URL}/c_main.php
        Wait until page contains    Welcome, RF-${random string}
        Page should contain    Note
        Page should contain    In order to continue registration process
        click element    //body/div[2]/p/a
        Page should contain    ${Robot Certificate}
        Page should contain    RF Certificate for shopper self registration
        Page should contain    ${Robot q-ry}
        click element    //*[@id="table_rows"]/tbody/tr/td[2]/a
        Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF    2000    Free text message    Internal message    NO
        Click element    id=finishCrit
        Wait until page contains    Thank you for filling this review    8
        Wait until page contains    Certificate passed successfully
        Enter login and password.SD    RF-${random string}    RF-${random string}
        Enable agreements.SD
        go to.AD    ${URL}/c_main.php
        Wait until page contains    Welcome, RF-${random string}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Assessor self registration.AD
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search Element.AD    RF-${random string}    id=uesrs_table
        go to.AD    ${URL}/checkers.php?page_var_filter_IsActive=1&page_var_filter_BlackListed=0&page_var_filter_IsSelfRegistered=1&page_var_filter_RegionName=0&page_var_filter_CityName_Cou=&page_var_filter_CityName_Reg=&page_var_filter_CityName=&page_var_filter_Fullname=&page_var_filter_Email=RF-${random string}@gmail.com&update=Please+wait&page_var_sorting_column=Fullname&page_var_sorting_order=up&page_var_divide_recordsPerPage=50&page_var_divide_curPage=1&s=0_2_4_17_21&cc=1
        Wait until page contains element    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-firstcol']
        ${ShopperID}    Get text    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][1]
        Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][5]    RF-${random string}@gmail.com
        Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][2]    Yes
        Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][4]    ${mobile}
        Run Keyword If    ${preprod?}    Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][1]    ${ShopperID}
        Run Keyword If    ${testing?}    Validate value (text)    //table[@id='table_rows']/tbody/tr[@class='db1']/td[@class='db-ltr'][1]    RF-${random string}
    #
        Log to console    User self registration is finished with next details:
        Log to console    username: RF-${random string} or ${ShopperID} (preprod only)
        Log to console    email: RF-${random string}@gmail.com
        Log to console    active: Yes
    END
    close all browsers
    [Teardown]    Close Browser.AD
