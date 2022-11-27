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

*** Test Cases ***
Order: Single and Mass orders with rich descr and project are created successfully
    [Tags]    Order
    [Template]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${single rich order description}    Set variable    <p style="text-align:center">(S) RF ORDER №10 ${DD.MM.YY} (Project is not selected)+<strong><span style="font-size:10px">re</span>ac</strong>h<em><span style="background-color:#f1c40f">de</span></em><u>sc<span style="color:#2980b9">ri</span></u><cite>p<span style="color:#2980b9">tio</span>n</cite></p>
        ${mass rich order description}    Set variable    <p style="text-align:center">(M) RF ORDER №10 ${DD.MM.YY} (Project is selected)+<strong><span style="font-size:10px">re</span>ac</strong>h<em><span style="background-color:#f1c40f">de</span></em><u>sc<span style="color:#2980b9">ri</span></u><cite>p<span style="color:#2980b9">tio</span>n</cite></p>
        ${single order description}    Set variable    (S) RF ORDER №10 ${DD.MM.YY} (Project is not selected)+reachdescri
        ${mass order description}    Set variable    (M) RF ORDER №10 ${DD.MM.YY} (Project is selected)+reachdescri
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Set "City selection style".AD    Select by hierarchy
    #
        ${RobotTestClient 02}    Set variable    AUTO 02 [RF CLIENT]
    #%%    Search client ID.AD     ${RobotTestClient 02}
    #%%    Search branch.AD
    #
        go to.AD    https://eu.checker-soft.com/testing/orders-assignment-manual.php
        Check Search a shopper filters.AD
    #
        Create test order (Single)    ${single rich order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Create test order (MASS) - BASIC    ${mass rich order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Create test order (Single)    ${single rich order description}    ${RobotTestClient 02}    ${RobotQ-ry SHOPPERS}
        #    Manage Orders.table export    ${test order description 05}    ${RobotTestClient}
        go to.AD    ${URL}/orders-assignment-manual.php
        Check Search a shopper filters.AD
        Wait until page contains element    //input[@id='disregardCheckerAvailability']
        Wait until page contains element    //input[@id='shplst']
        Wait until page contains element    //select[@id='theDate']
        Wait until page contains element    //select[@id='untilDate']
        Wait until page contains element    //select[@id='ClientID']
        Wait until page contains element    //select[@id='RegionID']
    #
        Click element    id=ClientID
        Click element    xpath=//option[contains(.,'${RobotTestClient}')]
        Click element    //input[@id='update']
        Element Should Contain    //*[@id="Orders"]/tbody/tr[1]/td[3]/p    ${mass order description}    #    collapse_spaces=True
        Element Should Contain    //*[@id="Orders"]/tbody/tr[2]/td[3]/p    ${single order description}    #    collapse_spaces=True
        Log to console    Manual assignment page: page contains newly created orders titles (+)
    #
        ${date+5days}    Add Time To Date    ${Ttime}    5 days    result_format=%d-%m-%Y
        Input text    //input[@id='criorderdate']    ${date+5days}
        Click element    //*[@id="Orders"]/tbody/tr[1]/td[1]/input
        Click element    //*[@id="Orders"]/tbody/tr[2]/td[1]/input
        Click element    //*[@id="updateAssignments"]
        sleep    2
        Check errors on page [-1]
        should NOT contain    //*[@id="Orders"]/tbody/tr[1]/td[3]/p    ${mass order description}
        should NOT contain    //*[@id="Orders"]/tbody/tr[2]/td[3]/p    ${single order description}
        Log to console    Manual assignment page: page does not contains newly created orders titles after changing dates (+)
    #
        go to.AD    ${URL}/operation-panel.php?StatusID=1
        Log to console    Searching a RF review (q-re="RF Questionnaire [Shoppers]")
        Wait until page contains element    //input[@id='end_date']
        Input text    //input[@id='end_date']    ${date+5days}
        Input text    //input[@id='start_date']    ${DD-MM-YY}
        Select dropdown.AD    //*[@id="side_menu"]/tbody/tr/td[3]/form[1]/table/tbody/tr[3]/td[1]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'${RobotTestClient}')]
        Validate value (text)    //*[@id="side_menu"]/tbody/tr/td[3]/form[1]/table/tbody/tr[3]/td[1]/table/tbody/tr/td/span/button    AUTO 01 [RF CLIENT]
        Click element    //input[@id='show']
        Wait until page contains element    //*[@id="SetID"]
        Element Text Should Be    //*[@id="table_rows"]/tbody/tr[1]/td[4]/p    ${mass order description}
        Element Text Should Be    //*[@id="table_rows"]/tbody/tr[2]/td[4]/p    ${single order description}
    #
        Select dropdown.AD    //*[@id="side_menu"]/tbody/tr/td[3]/form[1]/table/tbody/tr[3]/td[1]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'${RobotTestClient 02}')]
        Click element    //input[@id='show']
        Wait until page contains element    //*[@id="SetID"]
        Execute JavaScript    window.document.getElementById("publicizeOrders").scrollIntoView(true)
        Element Text Should Be    //*[@id="table_rows"]/tbody/tr[1]/td[15]    ${empty}
        Element Text Should Be    //*[@id="table_rows"]/tbody/tr[2]/td[15]    RF ACTIVE project 2022 [PROJECT]
        Element Text Should Be    //*[@id="table_rows"]/tbody/tr[3]/td[15]    ${empty}
        Element Text Should Be    //*[@id="table_rows"]/tbody/tr[3]/td[4]    ${single order description}
    #
        Element Should Contain    //*[@id="table_rows"]/tbody/tr[1]/td[8]    ${RobotTestClient 02}
        Element Should Contain    //*[@id="table_rows"]/tbody/tr[2]/td[8]    ${RobotTestClient}
        Element Should Contain    //*[@id="table_rows"]/tbody/tr[3]/td[8]    ${RobotTestClient}
    #
        Element Should Contain    //*[@id="table_rows"]/tbody/tr[1]/td[2]    1
        Element Should Contain    //*[@id="table_rows"]/tbody/tr[2]/td[2]    1
        Element Should Contain    //*[@id="table_rows"]/tbody/tr[3]/td[2]    1
    #
        Element Should Contain    //*[@id="table_rows"]/tbody/tr[1]/td[12]    Assign
        Element Should Contain    //*[@id="table_rows"]/tbody/tr[2]/td[12]    Assign
        Element Should Contain    //*[@id="table_rows"]/tbody/tr[3]/td[12]    Assign
        Log to console    OPanel: OP contains newly created orders titles with updating dates in status "Ordered, waiting assignment" (+); selected project is shown properly
    # Checking default table titles
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[1]    ${empty}
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[2]/a    Order count
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[3]/a    OrderID
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[4]/a    Description
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[5]/a    Date
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[6]/a    Region name
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[7]/a    City
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[8]/a    Client name
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[9]/a    Full name
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[10]/a    Short branch name
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[11]/a    Status
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[12]/a    Shopper name
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[13]/a    Shopper priority
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[14]/a    Questionnaire name
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[15]/a    Project
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[16]/a    Briefing
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[17]/a    Limit for products payment
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[18]/a    Services payment
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[19]/a    Survey payment
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[20]/a    Transportation payment
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[21]/a    Publicized
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[22]/a    Is Duplicate
        Element Should Contain    //*[@id="table_rows"]/thead/tr[1]/th[23]/a    Package name
        Click element    //form[@id='frm']/input[1]
        Input text    //input[@id='datepicker_order_date']    ${DD.MM.YY}
        Click element    //form[@id='frm']/input[@id='ChangeReviewsDate']
        Wait until page contains    Saved: 3 Orders
    #
    #Canceling orders
        go to.AD    ${URL}/crit-orders-handle.php
        Click element    id=ClientID
        Click element    xpath=//option[contains(.,'${RobotTestClient}')]
        Click element    //input[@id='update']
        Click element    //*[@id="side_menu"]/tbody/tr/td[3]/form[2]/p/table[3]/tbody/tr/td[1]/input
        Click element    id=cancelOrders
        sleep    1
        Click element    //span/select[@id='ClientID']
        Element should not contain    //span/select[@id='ClientID']    xpath=//option[contains(.,'${RobotTestClient}')]
        Page should not contain    xpath=//option[contains(.,'${RobotTestClient}')]
    #    Page should not contain    ${single order description}
        Page should not contain    ${mass order description}
        Check errors on page [-1]
    #
        Click element    id=ClientID
        Click element    xpath=//option[contains(.,'${RobotTestClient 02}')]
        Click element    //input[@id='update']
        Click element    //*[@id="side_menu"]/tbody/tr/td[3]/form[2]/p/table[3]/tbody/tr/td[1]/input
        Click element    id=cancelOrders
        sleep    1
        Click element    //span/select[@id='ClientID']
        Element should not contain    //span/select[@id='ClientID']    xpath=//li[contains(.,'${RobotTestClient 02}')]
        Page should not contain    xpath=//li[contains(.,'${RobotTestClient 02}')]
        Page should not contain    ${single order description}
        Page should not contain    ${mass order description}
        Check errors on page [-1]
    #
        Log to console    Select filter="unassigned", select all orders, press Cancel and confirm
        Log to console    Dropbox "Client name" does not contan "${RobotTestClient}"
        Log to console    Page does not contain text: "${RobotTestClient}"
        Log to console    Page does not contain text: "${single order description}" and "${mass order description}"
        Log to console    "${RobotTestClient}" orders (unassigned) were cancelled!
    END
    Close Browser
    [Teardown]    Close Browser.AD

Order: Order assignment is cancelled by manager (order page)
    [Tags]    Order    Order assignment
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}=    Set variable    RF Order: M02 [To be canceled by a manage, ${DD.MM.YY}]
        Set global variable    ${test order description}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Set Records per page    300
        Create test order (MASS) - BASIC    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Assign order (via orders-management.php).AD    ${test order description}
        Order page - check elements. AD    Assigned, awaiting shopper acceptance    ${DD.MM.YY}    ${Tday}    ${order start_time}    ${order end_time}
        Login as a Shopper
        go to    ${URL}/c_ordered-crits.php
        Page should contain    ${found order ID}
        Log to console    Page ${URL}/c_ordered-crits.php contains text: "${test order description}"
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Order page - check elements. AD    Assigned, awaiting shopper acceptance    ${DD.MM.YY}    ${Tday}    ${order start_time}    ${order end_time}
        Cancel order assignment    ${test order description}
        Order page - check elements. AD    Ordered, awaiting assignation    ${DD.MM.YY}    ${Tday}    ${order start_time}    ${order end_time}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Assignment cancellation notification.AD
        Login as a Shopper
        go to    ${URL}/c_ordered-crits.php
        Page should not contain    ${found order ID}
        Log to console    Page ${URL}/c_ordered-crits.php does not contain text: "${test order description}"
        go to    ${URL}/c_ordered-crits.php?showJobBoard=1
        set focus to element    //*[@id="Filter"]
        click element    //*[@id="Filter"]
        Page should not contain    ${found order ID}
        #Page should contain    There are no ordered scorecards
        #Page should contain    Hello, welcome to JOB BOARD
        #Page should contain    (Modification date: ${DD.MM.YY})
        Log to console    Page ${URL}//c_ordered-crits.php?BranchFilter=&date_from=&date_to=&printMode=&showJobBoard=1&filters_submitted=1&Filter=Please+wait does not contain text: "${test order description}"
    #Log to console    Page contains default text: "There are no ordered scorecards"
    #Log to console    Page contains text: "Hello, welcome to JOB BOARD message, edited by manager ${DD.MM.YY}"
    END
    Close Browser
    [Teardown]    Close Browser.AD

Order: Single order assignment notification is recieved by shoppper
    [Tags]    Order    Order assignmnet    Operational settings
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}    Set variable    RF Order: M018 [Check assignment email notification ${DD.MM.YY}]
        Set global variable    ${test order description}
    #
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD
        Get section ID. AD    Section 01 [RF]
        Get BR property ID. AD    Manager
        Set Operation messages.AD
        Create test order (MASS) - BASIC    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        #    Assign order (via orders-management.php).AD    ${test order description}
        #    Create test order (Single)    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        #    click link    default=Edit assignments
        #    Wait until page contains element    //form/input[@id='show']
        Search order via OP.AD
        Click element    //*[@id="table_rows"]/tbody/tr[${rowindex}]/td[11]
        Wait until page contains element    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][9]
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
        Get Order details page.AD    ${found order ID}
        ${ReviewID}    Set variable    -1
        Set global variable    ${ReviewID}
        GMAIL: Assignment notification.AD    Assignment notification
        Manage orders page > Cancel order.AD    ${RobotTestClient}    2
        go to.AD    ${URL}/crit-order-assignments.php?OrderID=${found order ID}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][9]    Canceled
        Log to console    Order canceled. Order Status (="Canceled") - ok (+)
    END
    Close Browser
    [Teardown]    Close Browser.AD

Order: Check (dis)enabled Dates policy option
    [Tags]    Order    Order assignment    Operational settings
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Log to console    Case 1: Disabled "Enforce dates policy when filling-in the date of the review" is disabled on Mass/Single creation order page
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Go to2.AD    ${URL}/company-assignments.php
        Set checkbox.AD    //input[@id='field_EnforeOrderFillingdates']    None
        Validate element attribute.AD    //input[@id='field_EnforeOrderFillingdates']    checked    None
        Click Save/Add/Delete/Cancel button.AD
        Go to2.AD    ${URL}/shahar_bridge.php?name=mass_order
        Validate element attribute.AD    //input[@id='EnforceFillingdates']    checked    None
        Go to2.AD    ${URL}/crit-do-order.php
        Validate element attribute.AD    //*[@id="side_menu"]/tbody/tr/td[3]/form/table/tbody/tr[18]/td[2]/input    checked    None
        Log to console    Result: Disabled "Enforce dates policy when filling-in the date of the review" is disabled on Mass/Single creation order page (+)
    #
        Log to console    Case 2: Enabled "Enforce dates policy when filling-in the date of the review" is enabled on Mass/Single creation order page
        Go to2.AD    ${URL}/company-assignments.php
        Set checkbox.AD    //input[@id='field_EnforeOrderFillingdates']    true
        Validate element attribute.AD    //input[@id='field_EnforeOrderFillingdates']    checked    true
        Click Save/Add/Delete/Cancel button.AD
        Go to2.AD    ${URL}/shahar_bridge.php?name=mass_order
        Validate element attribute.AD    //input[@id='EnforceFillingdates']    checked    true
        Go to2.AD    ${URL}/crit-do-order.php
        Validate element attribute.AD    //*[@id="side_menu"]/tbody/tr/td[3]/form/table/tbody/tr[18]/td[2]/input    checked    true
        Log to console    Result: Enabled "Enforce dates policy when filling-in the date of the review" is enabled on Mass/Single creation order page (+)
    END
    Close Browser
    [Teardown]    Close Browser.AD

Order: Manager creates a valid MASS order with N Reviews per branch+assign to matched shopper by property
    [Tags]    Order    Order creation
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}    Set variable    RF Order: M020 [Check manual order assignment using Edit assignment page, ${DD.MM.YY}]
        Set global variable    ${test order description}
        ${agemax}    Set variable    23
        ${agemin}    Set variable    4
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Set assignment settings.AD    None
        Search Client.AD
        #    Search profile.AD    ${RobotTestShopper 02}
        #    Assign property.AD    ${RobotTestShopper 02}
        Create test order (MASS) - ADVANCED    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}    3    1    1    1    1    YES    Enforce WEO-NO    Date Policy-NO
        Search order via OP.AD
        sleep    2
        Run keyword and ignore error    Click element    //*[@id="table_rows"]/tbody/tr[${rowindex}]/td[11]
        #    Get ID from ad bar.AD    OrderID=    ${space}
        Go to2.AD    ${URL}/edit-multiple-orders.php?OrderIDs=${found order ID}
        Input text    //*[@id="table_rows"]/tbody/tr/td[10]/input    ${agemin}
        Input text    //*[@id="table_rows"]/tbody/tr/td[11]/input    ${agemax}
        Click element    //*[@id="table_rows"]/tbody/tr/td[1]/input
        Click element    //input[@id='save']
        Wait until page contains    Orders saved
        Go to2.AD    ${URL}/crit-order-assignments.php?OrderID=${found order ID}
        Wait until page contains element    //form/input[@id='show']
    #
        Element should contain    //*[@id="side_menu"]/tbody/tr/td[3]/p/table/tbody/tr/td[4]    Age range:${agemin}-${agemax}
        Element text should be    //table/tbody/tr/td[4]/span[@class='critInfoItemTitle']    ${Property name}
        Element text should be    //table/tbody/tr/td[4]/span[@class='critInfoItem']    Autotest-YES
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][1]    Make acquisition
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][2]    Acquisition description
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][3]    Limit for products payment
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][4]    Budget control confirmation
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][5]    Services payment
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][6]    Transportation payment
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][7]    Survey payment
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][8]    Bonus payment
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][9]    Time extent (minutes)
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][10]    Maximum reviews per day
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][11]    Allow orders on holidays
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][12]    Allow orders on special days
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][13]    Enforce dates policy
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][14]    Shopper availability radius
    #
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][1]    Yes
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][2]    RF Acquisition description
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][3]    100.00
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][4]    No
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][5]    10.50
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][6]    11.00
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][7]    15.00
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][8]    5.00
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][9]    5
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][10]    100
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][11]    No
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][12]    No
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][13]    No
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][14]    0
    #
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][1]    Description
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][2]    Client name
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][3]    Short branch name
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][4]    Region name
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][5]    City
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][6]    Address
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][7]    Questionnaire name
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][8]    Briefing description
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][9]    Status
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][10]    Date
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][11]    Day in week
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][12]    Starting time
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][13]    Ending time
    #
        Element should contain    //*[@id="side_menu"]/tbody/tr/td[3]/p/table/tbody/tr/td[1]/span[2]    ${test order description}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][2]    ${RobotTestClient}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][3]    ${Short auto branch name 01}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][4]    Robot region 01
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][5]    Robot city 01
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][6]    Zelena street 45A, 44
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][7]/a    ${RobotQ-ry SHOPPERS}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][8]    RF Universal Brief [Briefing]
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][9]    Ordered, awaiting assignation
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][10]/a    ${DD.MM.YY}
        Element text should be    //tbody/tr/td[1]/span[@class='CritInfoItem'][11]    ${Tday}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][12]    ${order start_time}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][13]    ${order end_time}
        Log to console    Checking order details (payments details, age, shopper characteristic) and its values Status - ok (+)
        #    Select dropdown.AD    //select[@id='PropID']    xpath=//option[contains(.,'${Property name}')]
        #    Select dropdown.AD    //*[@id="ValueID"]    xpath=//option[contains(.,'Autotest-YES')]
        Select dropdown.AD    //*[@id="pleaseFilter"]    //*[@id="pleaseFilter"]/option[2]
        Wait until page contains element    //form/input[@id='show']
        Click Element    //input[@id='show']
        Set focus to element    //*[@id="assignmenttable"]/tbody/tr[1]/td[13]/a
        Element should contain    //td[@class='report-dir'][12]    Characteristics do not match
        Select dropdown.AD    //*[@id="pleaseFilter"]    //*[@id="pleaseFilter"]/option[1]
        Wait until page contains element    //form/input[@id='show']
        Click Element    //input[@id='show']
        Page should not contain element    //*[@id="assignmenttable"]/tbody/tr[2]
        Element text should be    //td[@class='report-dir'][2]    Robot 02 [Full Name]
        Element text should be    //*[@id="assignmenttable"]/tbody/tr/td[13]    Accepted
        Set focus to element    //*[@id="assignmenttable"]/tbody/tr/td[1]/input
        Click Element    //*[@id="assignmenttable"]/tbody/tr/td[1]/input
        Click Element    //input[@id='do_assignment']
        Page should contain    1 orders assigned
        Log to console    Order assigned to matched shopper. Status - ok (+)
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][9]    Assigned, awaiting shopper acceptance
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][10]/a    Robot 02 [Full Name]
        Log to console    Order `${found order ID}` (description="${test order description}") is assigned!
        Manage orders page > Cancel order.AD    ${RobotTestClient}    2
        go to.AD    ${URL}/crit-order-assignments.php?OrderID=${found order ID}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][9]    Canceled
        Log to console    Order canceled. Order Status (="Canceled") - ok (+)
    END
    Close Browser
    [Teardown]    Close Browser.AD

Order: Manager creates a valid MASS order with N Min & Max gap between reviews (days)
    [Tags]    Order    Order creation    Order assignment
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}    Set variable    RF Order: M021 [Check manual order assignment using Search shopper filter, ${DD.MM.YY}]
        Set global variable    ${test order description}
        ${agemax}    Set variable    15
        ${agemin}    Set variable    4
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Set assignment settings.AD    None
        Search Client.AD
        #    Search profile.AD    ${RobotTestShopper 02}
        #    Assign property.AD    ${RobotTestShopper 02}
        Create test order (MASS) - ADVANCED    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}    2    2    6    2    2    YES    Enforce WEO-NO    Date Policy-NO
        Search order via OP.AD
        Click element    //*[@id="table_rows"]/tbody/tr[${rowindex}]/td[1]
        Get ID from ad bar.AD    OrderID=    ${space}
        sleep    1
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        Select frame    external
        Wait until page contains element    CritCount_Approved_Min
        Input text    CritCount_Approved_Min    10
        Input text    CritCount_Approved_Max    15000
        Input text    zipcode    4455
        Input text    shopper_name_search    robo
        Input text    Email    robotshopperemail@gmail.com
        Input text    Phone    +380670118780
        Input text    AgeStart    20
        Input text    AgeEnd    22
        Click element    go
        Execute JavaScript    window.document.getElementById("AgeEnd").scrollIntoView(true)
        Wait until page contains element    //*[@id="theChecker"]/option[1]
        Click element    //*[@id="theChecker"]/option[1]
        Execute JavaScript    window.document.getElementById("AgeEnd").scrollIntoView(true)
        sleep    2
        Click element    name=assignChecker
        Handle alert    Accept
        #    Wait until page contains    1 orders were assigned to Robot 02 [Full Name]
        Go to2.AD    ${URL}/crit-order-assignments.php?OrderID=${found order ID}
        Wait until page contains element    //form/input[@id='show']
    #
        Element text should be    //table/tbody/tr/td[4]/span[@class='critInfoItemTitle']    ${Property name}
        Element text should be    //table/tbody/tr/td[4]/span[@class='critInfoItem']    Autotest-YES
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][1]    Make acquisition
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][2]    Acquisition description
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][3]    Limit for products payment
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][4]    Budget control confirmation
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][5]    Services payment
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][6]    Transportation payment
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][7]    Survey payment
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][8]    Bonus payment
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][9]    Time extent (minutes)
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][10]    Maximum reviews per day
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][11]    Allow orders on holidays
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][12]    Allow orders on special days
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][13]    Enforce dates policy
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][14]    Shopper availability radius
    #
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][1]    Yes
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][2]    RF Acquisition description
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][3]    100.00
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][4]    No
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][5]    10.50
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][6]    11.00
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][7]    15.00
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][8]    5.00
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][9]    5
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][10]    100
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][11]    Yes
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][12]    Yes
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][13]    No
        Element text should be    //tbody/tr/td[2]/span[@class='CritInfoItem'][14]    0
    #
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][1]    Description
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][2]    Client name
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][3]    Short branch name
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][4]    Region name
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][5]    City
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][6]    Address
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][7]    Questionnaire name
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][8]    Briefing description
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][9]    Status
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][10]    Shopper
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][11]    Date
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][12]    Day in week
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][13]    Starting time
        Element text should be    //table/tbody/tr/td[1]/span[@class='critInfoItemTitle'][14]    Ending time
    #
        Element should contain    //*[@id="side_menu"]/tbody/tr/td[3]/p/table/tbody/tr/td[1]/span[2]    ${test order description}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][2]    ${RobotTestClient}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][3]    ${Short auto branch name 01}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][4]    Robot region 01
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][5]    Robot city 01
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][6]    Zelena street 45A, 44
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][7]/a    ${RobotQ-ry SHOPPERS}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][8]    RF Universal Brief [Briefing]
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][9]    Assigned, awaiting shopper acceptance
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][10]/a    Robot 02 [Full Name]
        Element text should be    //tbody/tr/td[1]/span[@class='CritInfoItem'][11]/a    ${DD.MM.YY}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][12]    ${Tday}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][13]    ${order start_time}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][14]    ${order end_time}
    #
        Log to console    Order `${found order ID}` (description="${test order description}") is assigned!
        Click link    default=Cancel order
        Input text    reasonForCancelling    Not actual RF order (${DD.MM.YY})
        Click Element    //input[@id='cancelOrder']
        go to.AD    ${URL}//crit-order-assignments.php?OrderID=${found order ID}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][9]    Canceled
        Log to console    Order canceled. Order Status (="Canceled") - ok (+)
    #
        #    Manage orders page > Cancel order.AD    ${RobotTestClient}    2
        go to.AD    ${URL}//crit-order-assignments.php?OrderID=${found order ID}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][9]    Canceled
        Log to console    Order canceled. Order Status (="Canceled") - ok (+)
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][9]    Canceled
    END
    Close Browser
    [Teardown]    Close Browser.AD

Order: Manager creates a valid MASS order with: - (dis)enabled - holiday N day(s) - special N (days) - weekday
    [Tags]    Order
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}    Set variable    RF Order: M022 [Check Mass order creation with (dis) enabled holiday, special day and weekday ${DD.MM.YY}]
        Set global variable    ${test order description}
        ${agemax}    Set variable    15
        ${agemin}    Set variable    4
        ${RFholiday}    Set variable    Holiday [RF]
        ${SPday}    Set variable    Special day [RF]
        ${date-plus-1-day}    Add Time To Date    ${Ttime}    1 days    result_format=%d-%m-%Y
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Add record(ID).AD    ${SPday}    /settings-special-days.php    ${DD-MM-YY}
        Add record(ID).AD    ${RFholiday}    /settings-holidays.php    ${date-plus-1-day}
        #    #
        Create test order (MASS) - ADVANCED    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}    1    5    20    2    2    NO    Enforce WEO-NO    Date Policy-NO
        Create test order (MASS) - ADVANCED    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}    1    5    20    1    1    NO    Enforce WEO-NO    Date Policy-NO
        Create test order (MASS) - ADVANCED    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}    1    5    20    2    2    TODAY    Enforce WEO-NO    Date Policy-NO
    END
    Close Browser
    [Teardown]    Close Browser.AD

Order: Manager creates a valid MASS order with: - (dis)enabled Enforce with existing orders
    [Tags]    Order    Order creation
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}    Set variable    RF Order: M024 [Check Mass order creation with (dis) Enforce with existing orders ${DD.MM.YY}]
        Log to console    Setup step: Creating M order on today`s date to check enforce option
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Set global variable    ${test order description}
        ${agemax}    Set variable    15
        ${agemin}    Set variable    4
        ${RFholiday}    Set variable    Holiday [RF]
        ${SPday}    Set variable    Special day [RF]
        ${date-plus-1-day}    Add Time To Date    ${Ttime}    1 days    result_format=%d-%m-%Y
        #    #
        Log to console    Precriation: creating new mass order to check option with dis/enabled state
        Create test order (MASS) - ADVANCED    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}    1    5    20    1    1    YES    Enforce WEO-NO    Date Policy-NO
        Create test order (MASS) - ADVANCED    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}    1    5    5    2    2    NO    Enforce WEO-NO    Date Policy-NO
        Log to console    Case 1: Disabled "Enforce with existing orders" creates M order on today`s date \ ${DD.MM.YY} (Status +)
    #
        Create test order (MASS) - ADVANCED    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}    1    5    5    2    2    NO    Enforce WEO-YES    Date Policy-NO
        Log to console    Case 2: Enabled "Enforce with existing orders" creates M order with a gap in dates ${DD.MM.YY}+5 days (Status +)
    END
    Close Browser
    [Teardown]    Close Browser.AD

JOB: Shopper submits a review with attached files (+check reports)
    [Tags]    Order    Job
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}=    Set variable    RF Order: M03 [To be accepted by a shopper and submitted with attached files, ${DD.MM.YY}]
        Set global variable    ${test order description}
        ${Internal message}    Set variable    Internal message added by RF shopper ${DD.MM.YY}
        Set global variable    ${Internal message}
        ${Free text message}    Set variable    Fee text entered by RF reviewer - ${DD.MM.YY}
        Set global variable    ${Free text message}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Make visible Job columns.AD    true    on
        Set Records per page    100
        Search the Q-ry (via search bar).AD    ${RobotQ-ry SHOPPERS}
        Edit questionnaire.AD    RFQRY-SHO-03    Flat average - questions average only    //div[9]/ul/li[1]/label    allow both
        Search shopper by AD    ${RobotTestShopper 02}
        Edit shopper profile.AD    ${RobotTestShopper 02}
        ${Shopper ID}    set variable    ${found ID}
        Set global variable    ${Shopper ID}
        Search client using search bar.AD
    #
        Search Client.AD
        Go to2.AD    ${URL}/clients.php?_&edit=${client ID}
        Wait until page contains element    //input[@id='field_AutomaticCritApproval']
        Set checkbox.AD    //input[@id='field_AutomaticCritApproval']    None
        Click Save/Add/Delete/Cancel button.AD
    #
        Set visit report settings.AD
        Create test order (MASS) - BASIC    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Assign order (via orders-management.php).AD    ${test order description}
        Order page - check elements. AD    Assigned, awaiting shopper acceptance    ${DD.MM.YY}    ${Tday}    ${order start_time}    ${order end_time}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Assignment notification.AD
        Search the Q-ry (via search bar).AD    ${RobotQ-ry SHOPPERS}
        Get question ID
        Login as a Shopper
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Check job details.SD
        Accept job
        Run Keyword If    '${check emails?}'=='True'    GMAIL: ALERT (no email body).AD    Email subject: RF Alert 01 (Accepted) rev date (${DD.MM.YY}); Status${\n} (Accepted, awaiting implementation)
        Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF    2000    ${Free text message}    ${Internal message}    YES
        Click element    id=finishCrit
        Reload page
        Wait until page contains    Thank you for filling this review.
        Element text should be    //center/table/tbody/tr[2]/td/a[1]    Back to main menu
        Element text should be    //center/table/tbody/tr[2]/td/a[2]    Back to review selection
        Element text should be    //center/table/tbody/tr[2]/td/a[3]    Log off
        go to.AD    ${URL}/c_ordered-crits.php
        Page should not contain    ${found order ID}
        Log To Console    Go to ${URL}/c_ordered-crits.php and Page does not contain    ${test order description}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Message from an assessor.AD    Message from a shopper Client:${RobotTestClient} Branch:RF Branch 01 ${\n}[Short name]    ${Internal message}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Log to console    ------------------------->CHECKING REPORT PAGES
        ${Review result}    Set variable    46.40
        Set global variable    ${Review result}
        Check Review handling details page.AD    Finished, awaiting approval    NO    ${Free text message}    ${Internal message}    ${Review result}
        Approve review.AD
        Check Review handling details page.AD    Approved    NO    ${Free text message}    ${Internal message}    ${Review result}
        Order page - check elements. AD    Approved    ${DD.MM.YY}    ${Tday}    ${order start_time}    ${order end_time}
        Open PDF review    ${ReviewID}
        HTML (old) page. AD    ${ReviewID}    ${Review result}
        HTML (new) page. AD    ${ReviewID}    ${Free text message}
        Show entire scorecard by question code page. AD    ${ReviewID}    ${RobotQ-ry SHOPPERS}    30.07.2021 14:19    ${RobotTestClient}    ${UpdatedShopperName}    ${Short auto branch name 01}    Approved    ${test order description}    ${Review result}
        Review in print version page. AD    ${ReviewID}    ${RobotQ-ry SHOPPERS}    30.07.2021 14:19    ${RobotTestClient}    ${UpdatedShopperName}    ${Short auto branch name 01}    Approved    ${test order description}    ${Review result}
        Full scorecard report.AD    ${ReviewID}    ${RobotQ-ry SHOPPERS}    30.07.2021 14:19    ${RobotTestClient}    ${UpdatedShopperName}    ${Short auto branch name 01}    Approved    ${test order description}    ${Review result}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: ALERT (no email body).AD    Email subject: RF Alert 03 (Approved) rev date (${DD.MM.YY}); Status${\n} (Approved)
    END
    Close Browser
    [Teardown]    Close Browser.AD

JOB: Manager can not return review older 30 days (from 2 pages: OP and handling details)
    [Tags]    Order    Job
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/operation-panel.php
        Wait until page contains element    //input[@id='end_date']
        Input text    //input[@id='end_date']    ${date minus 30 days}
        Select dropdown.AD    //*[@id="side_menu"]/tbody/tr/td[3]/form[1]/table/tbody/tr[3]/td[1]/table/tbody/tr/td/span/button    xpath=//li[contains(.,'${RobotTestClient}')]
        Validate value (text)    //*[@id="side_menu"]/tbody/tr/td[3]/form[1]/table/tbody/tr[3]/td[1]/table/tbody/tr/td/span/button    AUTO 01 [RF CLIENT]
        Click element    //input[@id='show']
        Wait Until Element Is Visible    //input[@id='show']    200
        ${is element visible}=    Run keyword and return status    Page should contain element    //*[@id="table_rows"]/tbody/tr[1]/td[1]/input
        Run keyword if    "${is element visible}"=="False"    exit for loop
        Log to console    Open OP and search review by date (todays date minus 30 days="${date minus 30 days}")
        Run keyword if    "${is element visible}"=="True"    click element    //*[@id="table_rows"]/tbody/tr[1]/td[1]/input
        Click element    ReturnCrits    #//*[@id="page_division_wrapping_table"]/tbody/tr[1]/td[1]/input[5]
        Wait until page contains    Cannot delete old reviews!    10
        Scroll Element Into View    //*[@id="table_rows"]/tbody/tr[1]/td[2]/a[1]
        ${Review ID}=    get text    //*[@id="table_rows"]/tbody/tr[1]/td[2]/a[1]
        Set global variable    ${Review ID}
        Log to console    Review ID="${Review ID}"
        Return review to shopper (handling page)
        Wait until page contains    Cannot return the review back to the shopper
        Wait until page contains    Internal Policy:
        Wait until page contains    the review older than 30 days cannot be assigned back to the shopper
        Log to console    OP and handling pages: Cannot return the review back to the shopper (Internal Policy: the review older than 30 days cannot be assigned back to the shopper)
    END
    Close Browser
    [Teardown]    Close Browser.AD

JOB: Manager returns review to shopper (from 2 pages: OP and handling details)
    [Tags]    Order    Job
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}=    set variable    RF Order: M04 [To be returned to shopper, ${DD.MM.YY}]
        set global variable    ${test order description}
        ${Free text message}    Set variable    Fee text entered by RF reviewer - ${DD.MM.YY}
        Set global variable    ${Free text message}
        ${Internal message}    Set variable
        Set global variable    ${Internal message}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        #    Set Records per page    100
        Search client using search bar.AD
        ${AlertName}=    Set variable    RF_ALERT - SEND REPEATEDLY
        Get section ID. AD    Section 01 [RF]
        Get BR property ID. AD    Manager
        Get project ID.AD    RF ACTIVE project 2022 [PROJECT]
        Add/Edit alert.AD    Finished, awaiting approval    ${AlertName}    $[207]$=46.60 || $[221]$>=46 & $[218]$='RF Questionnaire [Shoppers]' || $[204]$='RFCheckerCode_02'    xpath=//li[contains(.,'EmailVisitReport')]    List    true    true    ${RFShopperEmail}    true    None    This is an alert text "${AlertName}" ${Usual Text Codes Table} ${Branch property text codes} ${Section text codes} ${RF REVN DT}    No    None
    #
        Create test order (MASS) - BASIC    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Assign order (via orders-management.php).AD    ${test order description}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Assignment notification.AD
        Search the Q-ry (via search bar).AD    ${RobotQ-ry SHOPPERS}
        Edit questionnaire.AD    RFQRY-SHO-03    Flat average - questions average only    //div[9]/ul/li[1]/label    do not allow
        Get question ID
        Login as a Shopper
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Accept job
        Run Keyword If    '${check emails?}'=='True'    GMAIL: GET ALERT EMAIL.SD    Email subject: RF Alert 01 (Accepted) rev date (${DD.MM.YY}); Status${\n} (Accepted, awaiting implementation)    RF Shopper
        Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF    2000    ${Free text message}    ${Internal message}    NO
        Click element    id=finishCrit
        Reload page
        Run keyword and ignore error    Click element    //*[@id="continue"]
        Wait until page contains    Thank you for filling this review.
        go to.AD    ${URL}/c_ordered-crits.php
        Log To Console    Go to ${URL}/c_ordered-crits.php
        Page should not contain    ${found order ID}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Message from an assessor.AD    Message from a shopper Client:AutoTests Client 01 Branch:RF Branch 01${\n} (short name)    ${Internal message}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Review completed and requires approval.AD
    #
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Get Review handling details page.AD    ${ReviewID}
        GMAIL: GET ALERT EMAIL.SD    Email subject: ${AlertName}    RF Shopper
        Return review to shopper (handling page)
    #
        go to.AD    ${URL}/c_ordered-crits.php
        Log To Console    Go to ${URL}/c_ordered-crits.php
        Wait until page contains    ${found order ID}
        Wait until page contains element    //*[@id="BeginCriticism"]
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Execute JavaScript    window.document.getElementById("BeginCriticism").scrollIntoView(true)
        Element should contain    //*[@id="orders_list"]/tbody/tr[${index}]/td[${Status ID}]    In progress
        Log to console    "${found order ID}" is seen on order page.SD (status=IN PROGRESS)
        Continue scorecard.SD    Additional info - ${DD.MM.YY} RF TRY№2    2000    ${Free text message} TRY№2    ${Internal message} TRY№2    NO    id=finishCrit
        Go to    ${URL}/c_ordered-crits.php
        Log To Console    Go to ${URL}/c_ordered-crits.php
        Page should not contain    ${found order ID}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Review completed and requires approval.AD
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Open OP and filter reviews.AD
        Login as a Shopper
        Go to    ${URL}/c_ordered-crits.php
        Log To Console    Go to ${URL}/c_ordered-crits.php
        Wait until page contains    ${found order ID}
        Click element    //tr[${index}]/td[${Begin scorecard ID}]/form/input[1]
        #Wait until page contains element    //*[@id="continue"]
        Continue scorecard.SD    Additional info - ${DD.MM.YY} RF TRY№3    2000    ${Free text message} TRY№3    ${Internal message} TRY№3    YES    id=finishCrit
        Go to    ${URL}/c_ordered-crits.php
        Log To Console    Go to ${URL}/c_ordered-crits.php
        Page should not contain    ${found order ID}
        Get Review handling details page.AD    ${ReviewID}
        GMAIL: GET ALERT EMAIL.SD    Email subject: ${AlertName}    RF Shopper
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Check Review handling details page.AD    Finished, awaiting approval    YES    ${Free text message} TRY№3    ${Internal message} TRY№3    46.40
        Approve review.AD
        Check Edit review page.AD    Approved    46.40    Yes
        Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
    END
    Close Browser
    [Teardown]    Close Browser.AD

Order: Manager dis/approves a review (via OP page)
    [Tags]    Order
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}=    Set variable    RF Order: M03 [To be accepted by a shopper, ${DD.MM.YY}]
        Set global variable    ${test order description}
        ${Internal message}    Set variable    Internal message added by RF shopper ${DD.MM.YY}
        Set global variable    ${Internal message}
        ${Free text message}    Set variable    Fee text entered by RF reviewer - ${DD.MM.YY}
        Set global variable    ${Free text message}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
    #
        Log to console    CASE 1: dis/approve of 1 review via OP (one by one)
        Open Operational Panel.AD    Finished, awaiting approval    //div/ul/li[2]/a/span[2]
        Click element    //tr[@class='report1 '][1]/td[@class='report-firstcol']/input
        ${disapproved review}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[2]/a[1]
        Click element    //input[@id='DisApproveCrits']
        Wait until page contains    Reviews ${disapproved review} disapproved
    #
        Click element    //tr[@class='report1 '][1]/td[@class='report-firstcol']/input
        ${approved review}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[2]/a[1]
        Click element    //input[@id='ApproveCrits']
        Wait until page contains    The following reviews were approved: ${approved review}
    #
        go to.AD    ${URL}/crit-handling-details.php?CritID=${approved review}
        Wait until page contains    Review handling details
        Check errors on page [-1]
        Page should contain    Approved
        Page should contain    ${approved review}
        go to.AD    ${URL}/crit-handling-details.php?CritID=${disapproved review}
        Wait until page contains    Review handling details
        Page should contain    ${disapproved review}
        Page should contain    Disapproved
        Check errors on page [-1]
        Log to console    "${approved review}" has been approved via OP
        Log to console    "${disapproved review}" has been disapproved via OP
    ###
        Log to console    CASE 2: disapprove reviews in bulk via OP
        Open Operational Panel.AD    Approved    xpath=//li[contains(.,'${RobotTestClient}')]
        Wait until page contains element    //*[@id="table_rows"]/tbody/tr[1]/td[1]/input
        ${ReviewID}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[2]/a[1]
        Click element    //*[@id="table_rows"]/tbody/tr[1]/td[1]/input
        Click element    //input[@id='DisApproveCrits']
        Wait until page contains    disapproved
        Click element    //input[@id='show']
        Wait until page contains element    //input[@id='show']
        Check errors on page [-1]
        Page should not contain    ${ReviewID}
        go to.AD    ${URL}/crit-handling-details.php?CritID=${ReviewID}
        Wait until page contains    Disapproved
        Log to console    The reviews were dispproved in bulk via OP (+)
    #
        Log to console    CASE 3: approve reviews in bulk via OP
        Open Operational Panel.AD    Disapproved    xpath=//li[contains(.,'${RobotTestClient}')]
        Wait until page contains element    //*[@id="table_rows"]/tbody/tr[1]/td[3]/a[1]
        ${ReviewID}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[2]/a[1]
        Click element    //*[@id="table_rows"]/tbody/tr[1]/td[1]/input
        Click element    //input[@id='ApproveCrits']
        Wait until page contains    The following reviews were approved:
        Click element    //input[@id='show']
        Wait until page contains element    //input[@id='show']
        Check errors on page [-1]
        Page should not contain    ${ReviewID}
        go to.AD    ${URL}/crit-handling-details.php?CritID=${ReviewID}
        Wait until page contains    Approved
        Log to console    The reviews were approved in bulk via OP (+)
    END
    Close Browser
    [Teardown]    Close Browser.AD

JOB: Alert. Send repeatedly(Off)+Alert condition
    [Tags]    Alert
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}=    set variable    RF Order: M042 [To check send repeatedly alert, ${DD.MM.YY}]
        set global variable    ${test order description}
        ${Free text message}    Set variable    Fee text entered by RF reviewer - ${DD.MM.YY}
        Set global variable    ${Free text message}
        ${Internal message}    Set variable
        Set global variable    ${Internal message}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Set Records per page    100
        Search client using search bar.AD
        Set client autocritapprove.AD    None
        ${AlertName}=    Set variable    RF_ALERT - SEND REPEATEDLY
        Get section ID. AD    Section 01 [RF]
        Get BR property ID. AD    Manager
        Get project ID.AD    RF ACTIVE project 2022 [PROJECT]
        Log to console    SCENARIO: 1. Setting alert to "Send repeatedly"=OFF 2. Shopper finish review 3. Alert is sent 4. Review is sent back to a shopper 5. Review is submitted by shopper 6. Alert is not sent
        Add/Edit alert.AD    Finished, awaiting approval    ${AlertName}    $[207]$=46 || $[221]$>=45 & $[218]$='RF Questionnaire [Shoppers]' || $[204]$='RFCheckerCode_02'    xpath=//li[contains(.,'EmailVisitReport')]    List    true    true    ${RFShopperEmail}    None    None    This is an alert text "${AlertName}" ${Usual Text Codes Table} ${Branch property text codes} ${Section text codes} ${RF REVN DT}    No    None
    #
        Create test order (MASS) - BASIC    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Assign order (via orders-management.php).AD    ${test order description}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Assignment notification.AD
        Search the Q-ry (via search bar).AD    ${RobotQ-ry SHOPPERS}
        Edit questionnaire.AD    RFQRY-SHO-03    Flat average - questions average only    //div[9]/ul/li[1]/label    allow both
        Get question ID
        Login as a Shopper
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Accept job
        Run Keyword If    '${check emails?}'=='True'    GMAIL: GET ALERT.SD    Email subject: RF Alert 01 (Accepted) rev date (${DD.MM.YY}); Status${\n} (Accepted, awaiting implementation)    RF Shopper
        Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF    2000    ${Free text message}    ${Internal message}    NO
        Click element    id=finishCrit
        Reload page
        Run keyword and ignore error    Click element    //*[@id="continue"]
        Wait until page contains    Thank you for filling this review.
        go to.AD    ${URL}/c_ordered-crits.php
        Log To Console    Go to ${URL}/c_ordered-crits.php
        Page should not contain    ${found order ID}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Message from an assessor.AD    Message from a shopper Client:AutoTests Client 01 Branch:RF Branch 01${\n} (short name)    ${Internal message}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Review completed and requires approval.AD
    #
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Get Review handling details page.AD    ${ReviewID}
        GMAIL: GET ALERT EMAIL.SD    Email subject: ${AlertName}    RF Shopper
        Return review to shopper (handling page)
    #
        go to.AD    ${URL}/c_ordered-crits.php
        Log To Console    Go to ${URL}/c_ordered-crits.php
        Wait until page contains    ${found order ID}
        Wait until page contains element    //*[@id="BeginCriticism"]
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Execute JavaScript    window.document.getElementById("BeginCriticism").scrollIntoView(true)
        Element should contain    //*[@id="orders_list"]/tbody/tr[${index}]/td[${Status ID}]    In progress
        Log to console    "${found order ID}" is seen on order page.SD (status=IN PROGRESS)
        Continue scorecard.SD    Additional info - ${DD.MM.YY} RF TRY№2    2000    ${Free text message} TRY№2    ${Internal message} TRY№2    NO    id=finishCrit
        Go to    ${URL}/c_ordered-crits.php
        Log To Console    Go to ${URL}/c_ordered-crits.php
        Page should not contain    ${found order ID}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Review completed and requires approval.AD
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Open OP and filter reviews.AD
        Login as a Shopper
        Go to    ${URL}/c_ordered-crits.php
        Log To Console    Go to ${URL}/c_ordered-crits.php
        Wait until page contains    ${found order ID}
        Click element    //tr[${index}]/td[${Begin scorecard ID}]/form/input[1]
        #Wait until page contains element    //*[@id="continue"]
        Continue scorecard.SD    Additional info - ${DD.MM.YY} RF TRY№3    2000    ${Free text message} TRY№3    ${Internal message} TRY№3    YES    id=finishCrit
        Go to    ${URL}/c_ordered-crits.php
        Log To Console    Go to ${URL}/c_ordered-crits.php
        Page should not contain    ${found order ID}
        #    Get Review handling details page.AD    ${ReviewID}
        ${results}=    Run keyword and return status    GMAIL: GET ALERT EMAIL.SD    Email subject: ${AlertName}    RF Shopper
        Should Be Equal As Strings    ${results}    False
        Log to console    ---------Status---------: NO ALERT EMAIL IS RECEIVED (+)
    #
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Check Review handling details page.AD    Finished, awaiting approval    YES    ${Free text message} TRY№3    ${Internal message} TRY№3    46.40
        Approve review.AD
        Check Edit review page.AD    Approved    46.40    Yes
        Activate/Deactivate item on page.AD    ${URL}/alerts.php?page_var_filter_IsActive=&ClientID=${Client ID}    //*[@id="field_IsActive"]    None
    END
    Close Browser
    [Teardown]    Close Browser.AD

JOB: Manager disapproves a review
    [Tags]    Order    Job
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}=    Set variable    RF Order: M05 [To be disapproved by a manager, ${DD.MM.YY}]
        Set global variable    ${test order description}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: delete all INBOX emails.AD
        ${Free text message}    Set variable    Fee text entered by RF reviewer - ${DD.MM.YY}
        Set global variable    ${Free text message}
        ${Internal message}    Set variable    Internal message added by RF shopper ${DD.MM.YY}
        Set global variable    ${Internal message}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Create test order (MASS) - BASIC    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Assign order (via orders-management.php).AD    ${test order description}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Assignment notification.AD
        Search the Q-ry (via search bar).AD    ${RobotQ-ry SHOPPERS}
        Get question ID
        Login as a Shopper
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Accept job
        Run Keyword If    '${check emails?}'=='True'    GMAIL: ALERT (no email body).AD    Email subject: RF Alert 01 (Accepted) rev date (${DD.MM.YY}); Status${\n} (Accepted, awaiting implementation)
        Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF    2000    ${Free text message}    ${Internal message}    No
        Click element    id=finishCrit
        Reload page
        Wait until page contains    Thank you
        go to.AD    ${URL}/c_ordered-crits.php
        Log To Console    Go to ${URL}/c_ordered-crits.php
        Page should not contain    ${found order ID}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Log to console    CHECKING REPORT PAGES
        ${Review result}    Set variable    46.40
        Set global variable    ${Review result}
        Order page - check order status. AD    Finished, awaiting approval
        #    Page should contain    ${Internal message}    # works only on preprod
        Disapprove review.AD
        Order page - check order status. AD    Disapproved
        Check Edit review page.AD    Disapproved    ${Review result}    Do not check attached images!
        Run Keyword If    '${check reports?}'=='True'    Open PDF review    ${ReviewID}
        Run Keyword If    '${check reports?}'=='True'    HTML (old) page. AD    ${ReviewID}    ${Review result}
        Run Keyword If    '${check emails?}'=='True'    HTML (new) page. AD    ${ReviewID}    ${Free text message}
        Run Keyword If    '${check emails?}'=='True'    Show entire scorecard by question code page. AD    ${ReviewID}    ${RobotQ-ry SHOPPERS}    30.07.2021 14:19    ${RobotTestClient}    ${UpdatedShopperName}    ${Short auto branch name 01}    Disapproved    ${test order description}    ${Review result}
        Run Keyword If    '${check reports?}'=='True'    Review in print version page. AD    ${ReviewID}    ${RobotQ-ry SHOPPERS}    30.07.2021 14:19    ${RobotTestClient}    ${UpdatedShopperName}    ${Short auto branch name 01}    Disapproved    ${test order description}    ${Review result}
        Run Keyword If    '${check reports?}'=='True'    Full scorecard report.AD    ${ReviewID}    ${RobotQ-ry SHOPPERS}    30.07.2021 14:19    ${RobotTestClient}    ${UpdatedShopperName}    ${Short auto branch name 01}    Disapproved    ${test order description}    ${Review result}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: DISAPPROVED JOB.AD
    END
    Close Browser
    [Teardown]    Close Browser.AD

JOB: Shopper restarts a review
    [Tags]    Order    Job
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}=    Set variable    RF Order: M06 [To be restarted by a shopper, ${DD.MM.YY}]
        Set global variable    ${test order description}
        ${Internal message}    Set variable    Internal message added by RF shopper ${DD.MM.YY}
        Set global variable    ${Internal message}
        ${Free text message}    Set variable    Fee text entered by RF reviewer - ${DD.MM.YY}
        Set global variable    ${Free text message}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Make visible Job columns.AD    true    on
        Search shopper by AD    ${RobotTestShopper 02}
        Create test order (MASS) - BASIC    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Assign order (via orders-management.php).AD    ${test order description}
        Order page - check elements. AD    Assigned, awaiting shopper acceptance    ${DD.MM.YY}    ${Tday}    ${order start_time}    ${order end_time}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Assignment notification.AD
        Search the Q-ry (via search bar).AD    ${RobotQ-ry SHOPPERS}
        Get question ID
        Login as a Shopper
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Check job details.SD
        Accept job
        Run Keyword If    '${check emails?}'=='True'    GMAIL: ALERT (no email body).AD    Email subject: RF Alert 01 (Accepted) rev date (${DD.MM.YY}); Status${\n} (Accepted, awaiting implementation)
        Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF    2000    ${Free text message}    ${Internal message}    NO
        click element    //*[@id="askAboutRestartCrit"]
        click element    restartCrit
        Run keyword and ignore error    Click element    //*[@id="continue"]
        Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF    2000    ${Free text message}    ${Internal message}    NO
        Click element    id=finishCrit
        Go to    ${URL}/c_ordered-crits.php
        Page should not contain    ${found order ID}
        Log To Console    Go to ${URL}/c_ordered-crits.php and Page does not contain    ${test order description}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Message from an assessor.AD    Message from a shopper Client:AutoTests Client 01 Branch:RF Branch 01${\n} (short name)    ${Internal message}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
    #
        Order page - check order status. AD    Finished, awaiting approval
        Approve review.AD
        Order page - check order status. AD    Approved
        Check Edit review page.AD    Approved    46.4    Do not check attached images!
    END
    Close Browser
    [Teardown]    Close Browser.AD

JOB: Shopper saves and continue a review (+check order statuses)
    [Tags]    Order    Job
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}=    Set variable    RF Order: M07 [To be saved and continued by shopper, ${DD.MM.YY}]
        Set global variable    ${test order description}
        ${Internal message}    Set variable    Internal message added by RF shopper ${DD.MM.YY}
        Set global variable    ${Internal message}
        ${Free text message}    Set variable    Fee text entered by RF reviewer - ${DD.MM.YY}
        Set global variable    ${Free text message}
        ${Review result}    Set variable    46.40
        Set global variable    ${Review result}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Make visible Job columns.AD    true    on
        #    Search shopper by AD    ${RobotTestShopper 02}
        Create test order (MASS) - BASIC    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Assign order (via orders-management.php).AD    ${test order description}
        Order page - check elements. AD    Assigned, awaiting shopper acceptance    ${DD.MM.YY}    ${Tday}    ${order start_time}    ${order end_time}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Assignment notification.AD
        Search the Q-ry (via search bar).AD    ${RobotQ-ry SHOPPERS}
        Get question ID
        Login as a Shopper
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Check job details.SD
        Accept job
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Order page - check elements. AD    Accepted, awaiting implementation    ${DD.MM.YY}    ${Tday}    ${order start_time}    ${order end_time}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: ALERT (no email body).AD    Email subject: RF Alert 01 (Accepted) rev date (${DD.MM.YY}); Status${\n} (Accepted, awaiting implementation)
        Login as a Shopper
        go to.AD    ${URL}/c_ordered-crits.php
        Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF    2000    ${Free text message}    ${Internal message}    YES
        Click element    //*[@id="saveAndExit"]
        Wait until page contains    Data saved
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Order page - check elements. AD    In progress    NO    ${Free text message}    ${Internal message}    ${Review result}
        Login as a Shopper
        Go to    ${URL}/c_ordered-crits.php
        Page should contain    ${found order ID}
        Select unfinished review.SD
        Wait until page contains    Bonus qn description
        sleep    2
        Validate element attribute.AD    //select[@id='obj${Q4 ID}']/option[3]    selected    true
        Validate element attribute.AD    //select[@id='obj${Q4 ID}']/option[4]    selected    true
        Wait until page contains element    id=finishCrit
        Click element    id=finishCrit
        Reload page
        sleep    1
        Wait until page contains    Thank you for filling this review.    10
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Message from an assessor.AD    Message from a shopper Client:AutoTests Client 01 Branch:RF Branch 01${\n} (short name)    ${Internal message}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
    #
        Check Review handling details page.AD    Finished, awaiting approval    NO    ${Free text message}    ${Internal message}    ${Review result}
        Approve review.AD
        Check Review handling details page.AD    Approved    NO    ${Free text message}    ${Internal message}    ${Review result}
        Check Edit review page.AD    Approved    46.4    Yes
    END
    Close Browser
    [Teardown]    Close Browser.AD

JOB: Shopper rejects a review
    [Tags]    Order    Job
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}=    Set variable    RF Order: M08 [To be rejected by a shopper, (${DD.MM.YY}]
        Run Keyword If    '${check emails?}'=='True'    GMAIL: delete all INBOX emails.AD
        Set global variable    ${test order description}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Create test order (MASS) - BASIC    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Assign order (via orders-management.php).AD    ${test order description}
        Order page - check elements. AD    Assigned, awaiting shopper acceptance    ${DD.MM.YY}    ${Tday}    ${order start_time}    ${order end_time}
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Assignment notification.AD
        Login as a Shopper
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Reject job
        Run Keyword If    '${check emails?}'=='True'    GMAIL: Survey order refusal.AD
        Go to2.AD    ${URL}/c_ordered-crits.php
        Page should not contain    ${found order ID}
        Log to console    Page does not contain "${test order description}"; Order ID="${found order ID}"
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Order page - check elements. AD    Ordered, awaiting assignation    ${DD.MM.YY}    ${Tday}    ${order start_time}    ${order end_time}
        Click link    default=Cancel order
        Input text    reasonForCancelling    Not actual RF order (${DD.MM.YY})
        Click Element    //input[@id='cancelOrder']
        go to.AD    ${URL}//crit-order-assignments.php?OrderID=${found order ID}
        Element text should be    //table/tbody/tr/td[1]/span[@class='CritInfoItem'][9]    Canceled
        Log to console    Canceling the order... Order Status (="Canceled") - ok (+)
    END
    Close Browser
    [Teardown]    Close Browser.AD

JOB: Shopper rejects job due to not appr time (date policy enabled)
    [Tags]    Order    Job
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}=    Set variable    RF Order: M09 [To reject by a shopper due to not apr time, ${DD.MM.YY}]
        Set global variable    ${test order description}
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Go to2.AD    ${URL}/company-assignments.php
        Execute JavaScript    window.document.getElementById("field_EnforeOrderFillingdates").scrollIntoView(true)
        Select dropdown.AD    //*[@id="idAllowShoppersToRejectJobsEditbox"]/table/tbody/tr/td/span/button    //div[2]/ul/li[1]/label    #Always
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    Assignments settings saved successfully
        Create test order (MASS) - ADVANCED    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}    1    5    20    1    1    YES    Enforce WEO-NO    Date Policy-YES
        Assign order (via operation-panel.php).AD    ${test order description}
        #    Order page - check elements. AD    Assigned, awaiting shopper acceptance    11.12.2021    Saturday    07:01    07:02
        #    Run Keyword If    '${check emails?}'=='True'    GMAIL: Assignment notification.AD
        Login as a Shopper
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Accept and Reject job.SD
        #    Run Keyword If    '${check emails?}'=='True'    GMAIL: Survey order refusal.AD
        Go to    ${URL}/c_ordered-crits.php
        Wait until page contains element    //body/center/form/table/tbody/tr[1]/td[1]/table/tbody/tr/td/span/button
        Page should not contain    ${found order ID}
        Log to console    Order has been rejected by shopper. Page does not contain ${test order description}
        Check errors on page [-1]
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}/crit-order-assignments.php?OrderID=${found order ID}
        Element text should be    //td[1]/span[@class='CritInfoItem'][9]    Ordered, awaiting assignation
        Click link    default=Cancel order
        ${Cancel reason}    Set variable    Canceled by RF manager (date: ${DD.MM.YY})
        Input text    //tr/td[@class='middle-right']/form[1]/input[1]    ${Cancel reason}
        Click element    //input[@id='cancelOrder']
        Wait until page contains    Operation panel
        Log To Console    Order has been canceled with next reason: "${Cancel reason}"
        go to.AD    ${URL}/crit-order-assignments.php?OrderID=${found order ID}
        Element text should be    //table/tbody/tr/td[2]/span[@class='CritInfoItem'][15]    ${Cancel reason}
        Element text should be    //table/tbody/tr/td[2]/span[@class='critInfoItemTitle'][15]    Cancellation reason
        Element text should be    //td[1]/span[@class='CritInfoItem'][9]    Canceled
    END
    Close Browser
    [Teardown]    Close Browser.AD

JOB: Autoapproved applications is submitted and autoapproved successfully
    [Tags]    Order    Job    9
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${test order description}=    Set variable    RF Order: S01 [Published order, (${DD.MM.YY})]
        Set global variable    ${test order description}
        ${Free text message}    Set variable    Fee text entered by RF reviewer - ${DD.MM.YY}
        Set global variable    ${Free text message}
        ${Internal message}    Set variable    Internal message added by RF shopper ${DD.MM.YY}
        Set global variable    ${Internal message}
        ${Review result}    Set variable    25.37
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        #    Search profile.AD    ${RobotTestShopper 02}
        #    Edit shopper profile.AD    ${RobotTestShopper 02}
        Make visible Job columns.AD    true    on
        JOB board - set parameters while viewing job board.AD    None
        go to.AD    ${URL}/settings-jobboard.php
        Set checkbox.AD    //input[@id='field_JobBoardCheckerAutoApprove']    true
        Click element    //input[@id='save']
        Search the Q-ry (via search bar).AD    ${RobotQ-ry SHOPPERS}
        Get question ID
        Go to2.AD    ${URL}/sets.php?edit=${Qre ID}
        Wait until page contains element    //input[@id='field_AutomaticApproval']
        Set checkbox.AD    //input[@id='field_AutomaticApproval']    true
        Click Save/Add/Delete/Cancel button.AD
    #
        Search Client.AD
        Go to2.AD    ${URL}/clients.php?_&edit=${client ID}
        Wait until page contains element    //input[@id='field_AutomaticCritApproval']
        Set checkbox.AD    //input[@id='field_AutomaticCritApproval']    true
        Click Save/Add/Delete/Cancel button.AD
    #
        Create test order (Single)    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Order page - check order status. AD    Ordered, awaiting assignation
        Publish the order    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Order page - check order status. AD    Ordered, awaiting assignation
        Login as a Shopper
        Open Job Board and apply order.SD    ${test order description}    ${RobotTestClient}    ${RobotQ-ry SHOPPERS}
        Page should not contain    ${test order description}
        Page should contain    Hello, welcome to JOB BOARD
        Page should contain    (this is a message when the job board is empty)
        log to console    ---------------------------------
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
    #Check job details.SD
        Run keyword and ignore error    Click element    //*[@id="orders_list"]/tbody/tr[2]/td[${index}]
        Begin scorecard (OPlogic=no).SD    Additional info - ${DD.MM.YY} RF    2000    ${Free text message}    ${Internal message}    YES
        Click element    id=finishCrit
        Reload page
        Wait until page contains    Thank you for filling this review.
        #    ${URL}/c_ordered-crits.php?BranchFilter=&date_from=&date_to=&printMode=&showJobBoard=1&filters_submitted=1&Filter=Please+wait
        Log To Console    Go to ${URL}/c_ordered-crits.php
        Page should not contain    ${found order ID}
        Go to    ${URL}/c_ordered-crits.php?showJobBoard=1
        Log to console    Open ${URL}/c_ordered-crits.php?showJobBoard=1
        Set focus to element    name=frm
        Set focus to element    id=ClientID
        Select dropdown.AD    //center/form/table/tbody/tr[1]/td[1]/table/tbody/tr/td    xpath=//li[contains(.,'${RobotTestClient}')]
        #select from list by label    //select[@id='ClientID']    ${RobotTestClient}
        sleep    1
        #    Click element    //center/form/table/tbody/tr[1]/td[3]/table/tbody/tr/td/span/button
        #    Click element    //div[4]/div/ul/li[2]/a/span[2]
        #    Click element    //center/form/table/tbody/tr[1]/td[3]/table/tbody/tr/td/span/button
        Click element    //*[@id="BranchFilter"]
        Click element    id=Filter
        Wait until page contains    Job board    5
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        Page should not contain    ${test order description}
        #    Wait until page contains    Hello, welcome to JOB BOARD    10
    #
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Go to2.AD    ${URL}/sets.php?edit=${Qre ID}
        Wait until page contains element    //input[@id='field_AutomaticApproval']
        Set checkbox.AD    //input[@id='field_AutomaticApproval']    None
        Click Save/Add/Delete/Cancel button.AD
        Go to2.AD    ${URL}/clients.php?_&edit=${client ID}
        Wait until page contains element    //input[@id='field_AutomaticCritApproval']
        Set checkbox.AD    //input[@id='field_AutomaticCritApproval']    None
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    saved successfully
    #
        Order page - check order status. AD    Approved
        go to.AD    ${URL}/edit-entire-crit.php?CritID=${Review Number}
        Element text should be    //span[@class='CritInfoItem'][9]    Approved
        Validate value (text)    //textarea[@id='obj${Q1 ID}-mi']    ***
        Validate value (value)    //textarea[@id='obj${Q2 ID}-mi']    Additional info - ${DD.MM.YY} RF
        Validate value (value)    //input[@id='obj${Q3 ID}-mi']    2000
        Validate element attribute.AD    //input[@id='obj${Q1 ID}4']    checked    true
        Validate element attribute.AD    //input[@id='obj${Q2 ID}3']    checked    true
        Validate element attribute.AD    //input[@id='obj${Q3 ID}4']    checked    true
        Validate element attribute.AD    //select[@id='obj${Q4 ID}']/option[3]    selected    true
        Validate element attribute.AD    //select[@id='obj${Q4 ID}']/option[4]    selected    true
        Order page - check order status. AD    Approved
        go to.AD    ${URL}/crit-handling-details.php?CritID=${Review Number}
        Page should contain    ${test order description}
        Page should contain    Approved
        Page should contain    Automatically approved
        Log to console    Review is autoapproved (+)
    END
    Close Browser
    [Teardown]    Close Browser.AD

JOB: Shopper submits a review (random qns)
    [Tags]    Skip
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        ${expected answer index}    Set variable    4    # put here expected answer index number
        Set global variable    ${expected answer index}
        go to.AD    https://eu.checker-soft.com/testing/i_survey-fill.php?SurveyID=221
        Search QNs as shopper and select random answer.SD
    #    Run keyword if    "${value}">"0"
    END
    Close Browser
    #Get Element Count
    [Teardown]    Close Browser.AD

JOB: Finish review - Check Mystery Shopping logic (GLOBAL QRY)
    [Tags]    OPL
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${test order description}=    Set variable    RF Order: M031 [Check text codes, ${DD.MM.YY}]
        Set global variable    ${test order description}
        ${Robot q-ry}=    set variable    RF Questionnaire [GLOBAL]
        set global variable    ${Robot q-ry}
        Search Client.AD
        go to.AD    ${URL}/projects.php?ClientID=${client ID}
        Wait until page contains element    //*[@id="big_tedit_wrapping_table"]/tbody/tr[1]/td/table/tbody/tr/td/button
        ${Project ID}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[1]/a
        Set global variable    ${Project ID}
    #
        #    Make visible Job columns.AD    true    on
        Set Records per page    100
        #    Search shopper by AD    ${RobotTestShopper 02}
        Get BR property ID. AD    Manager
    #
    #
        #    Order page - check elements. AD    Assigned, awaiting shopper acceptance    ${DD.MM.YY}    ${Tday}    ${order start_time}    ${order end_time}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        #    Edit questionnaire.AD    RFQRY-SHO-03    Flat average - questions average only    //div[9]/ul/li[3]/label    allow both
        GET qns.AD    1
        Create test order (MASS) - BASIC    ${test order description}    ${RobotTestClient}    ${Robot q-ry}
        Assign order (via orders-management.php).AD    ${test order description}
    #
        Login as a Shopper
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Accept job
        Run keyword and ignore error    Click element    //tr[${index}]/td[${Begin scorecard ID}]/form/input[1]
        ${brif visible?}    Run keyword and return status    page should contain    (2 min read)
        Run keyword if    "${brif visible?}"=="True"    Check brif.SD
        Fill in review as a shopper(GLOBAL).SD    //*[@id="finishCrit"]
        Wait until page contains    Thank you for filling this review.
    END
    Close Browser
    [Teardown]    Close Browser.AD

JOB: Save and Exit - Check Mystery Shopping logic (GLOBAL QRY)
    [Tags]    OPL
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${test order description}=    Set variable    RF Order: M031 [Check text codes, ${DD.MM.YY}]
        Set global variable    ${test order description}
        ${Robot q-ry}=    set variable    RF Questionnaire [GLOBAL]
        set global variable    ${Robot q-ry}
        Search Client.AD
        go to.AD    ${URL}/projects.php?ClientID=${client ID}
        Wait until page contains element    //*[@id="big_tedit_wrapping_table"]/tbody/tr[1]/td/table/tbody/tr/td/button
        ${Project ID}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[1]/a
        Set global variable    ${Project ID}
    #
        #    Make visible Job columns.AD    true    on
        #    Set Records per page    100
        #    Search shopper by AD    ${RobotTestShopper 02}
        Get BR property ID. AD
        Create test order (MASS) - BASIC    ${test order description}    ${RobotTestClient}    ${Robot q-ry}
        Assign order (via orders-management.php).AD    ${test order description}
        #    Order page - check elements. AD    Assigned, awaiting shopper acceptance    ${DD.MM.YY}    ${Tday}    ${order start_time}    ${order end_time}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        GET qns.AD    1
        Login as a Shopper
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Accept job
        Run keyword and ignore error    Click element    //tr[${index}]/td[${Begin scorecard ID}]/form/input[1]
        ${brif visible?}    Run keyword and return status    page should contain    (2 min read)
        Run keyword if    "${brif visible?}"=="True"    Check brif.SD
        Fill in review as a shopper(GLOBAL).SD    id=saveAndExit
        Wait until page contains    Data saved
        #    go to.AD    ${URL}/c_v5-criticize.php?CritID=${ReviewID}
        Go to    ${URL}/c_ordered-crits.php
        Page should contain    ${found order ID}
        Select unfinished review.SD
        Click element    //input[@id='goBack']
        Click element    //input[@id='goBack']
        #    go to.AD    https://eu.checker-soft.com/testing/c_v5-criticize.php?CritID=${ReviewID}&ctmlg=1
        Check filled review (GLOBAL).SD
        Click element    //input[@id='goBack']
        Fill in review as a shopper(GLOBAL).SD    //*[@id="finishCrit"]
    #
        Wait until page contains    Thank you for filling this review.
        Element text should be    //center/table/tbody/tr[2]/td/a[1]    Back to main menu
        Element text should be    //center/table/tbody/tr[2]/td/a[2]    Back to review selection
        Element text should be    //center/table/tbody/tr[2]/td/a[3]    Log off
    END
    Close Browser
    [Teardown]    Close Browser.AD

JOB: Return back to shopper - Check Mystery Shopping logic (GLOBAL QRY)
    [Tags]    OPL
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${test order description}=    Set variable    RF Order: M031 [Check text codes, ${DD.MM.YY}]
        Set global variable    ${test order description}
        ${Robot q-ry}=    set variable    RF Questionnaire [GLOBAL]
        set global variable    ${Robot q-ry}
        Search Client.AD
        go to.AD    ${URL}/projects.php?ClientID=${client ID}
        Wait until page contains element    //*[@id="big_tedit_wrapping_table"]/tbody/tr[1]/td/table/tbody/tr/td/button
        ${Project ID}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[1]/a
        Set global variable    ${Project ID}
    #
        #    Make visible Job columns.AD    true    on
        #    Set Records per page    100
        #    Search shopper by AD    ${RobotTestShopper 02}
        Get BR property ID. AD
        Create test order (MASS) - BASIC    ${test order description}    ${RobotTestClient}    ${Robot q-ry}
        Assign order (via orders-management.php).AD    ${test order description}
        #    Order page - check elements. AD    Assigned, awaiting shopper acceptance    ${DD.MM.YY}    ${Tday}    ${order start_time}    ${order end_time}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        GET qns.AD    1
        Login as a Shopper
        JOB PAGE: get table titles and IDs
        Search job by order description.SD    ${test order description}
        Accept job
        Run keyword and ignore error    Click element    //tr[${index}]/td[${Begin scorecard ID}]/form/input[1]
        ${brif visible?}    Run keyword and return status    page should contain    (2 min read)
        Run keyword if    "${brif visible?}"=="True"    Check brif.SD
        Fill in review as a shopper(GLOBAL).SD    //*[@id="finishCrit"]
        Wait until page contains    Thank you for filling this review.
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Return review to shopper (handling page)
        Login as a Shopper
        go to.AD    ${URL}/c_ordered-crits.php
        Log To Console    Go to ${URL}/c_ordered-crits.php
        Wait until page contains    ${found order ID}
        Click element    //tr[${index}]/td[${Begin scorecard ID}]/form/input[1]
        Go to    ${URL}/c_ordered-crits.php
        Page should contain    ${found order ID}
        Select unfinished review.SD
        go to.AD    https://eu.checker-soft.com/testing/c_v5-criticize.php?CritID=${ReviewID}&ctmlg=1
        Click element    //input[@id='goBack']
        Check filled review (GLOBAL).SD    //*[@id="finishCrit"]
    END
    Close Browser
    [Teardown]    Close Browser.AD

JOB: Initiate review - Check Mystery Shopping logic (GLOBAL QRY)
    [Tags]    OPL
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${test order description}=    Set variable    RF Order: M031 [Check text codes, ${DD.MM.YY}]
        Set global variable    ${test order description}
        ${Robot q-ry}=    set variable    RF Questionnaire [GLOBAL]
        set global variable    ${Robot q-ry}
        Search Client.AD
        go to.AD    ${URL}/projects.php?ClientID=${client ID}
        Wait until page contains element    //*[@id="big_tedit_wrapping_table"]/tbody/tr[1]/td/table/tbody/tr/td/button
        ${Project ID}    Get text    //*[@id="table_rows"]/tbody/tr[1]/td[1]/a
        Set global variable    ${Project ID}
    #
        #    Make visible Job columns.AD    true    on
        Set Records per page    100
        #    Search shopper by AD    ${RobotTestShopper 02}
        Get BR property ID. AD    Manager
    #
    #
        #    Order page - check elements. AD    Assigned, awaiting shopper acceptance    ${DD.MM.YY}    ${Tday}    ${order start_time}    ${order end_time}
        Search the Q-ry (via search bar).AD    ${Robot q-ry}
        #    Edit questionnaire.AD    RFQRY-SHO-03    Flat average - questions average only    //div[9]/ul/li[3]/label    allow both
        GET qns.AD    1
    #
        Login as a Shopper
        go to.AD    ${URL}/c_choose-branch.php?ClientID=${client ID}
        Click element    //*[@id="blah"]/center/div/table/tbody/tr/td/span/button
        Wait until page contains element    //body/div[4]/ul/li[2]/label/span
        Click element    //body/div[4]/ul/li[2]/label/span
        Sleep    1
        Click element    //*[@id="SetID"]
        Sleep    1
        Click element    xpath=//option[contains(.,'RF Questionnaire [GLOBAL]')]
        #    Sleep    1
        ${brif visible?}    Run keyword and return status    page should contain    (2 min read)
        Run keyword if    "${brif visible?}"=="True"    Check brif.SD
        Fill in review as a shopper(GLOBAL).SD    //*[@id="finishCrit"]
        Wait until page contains    Thank you for filling this review.
    END
    Close Browser
    [Teardown]    Close Browser.AD
