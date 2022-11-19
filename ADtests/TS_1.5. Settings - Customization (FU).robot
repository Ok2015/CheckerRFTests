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
Whitelisted IPs > Add IP to whitelist
    [Tags]    Critical
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    #Set Selenium speed    0.5
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Get My IP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Add IP whitelist
        go to.AD    ${URL}/index.php?Controller=IPWhiteList&Action=Add
        Input Text    //*[@id="side_menu"]/tbody/tr/td[3]/form/table/tbody/tr[1]/td[2]/input    ${My IP}
        Click element    //*[@id="side_menu"]/tbody/tr/td[3]/form/table/tbody/tr[2]/td[2]/input
        Wait until page contains    IP White List
        wait until page contains    ${My IP}
        Log to console    Adding same IP value "${My IP}" and saving. No errors. Page still shows ${My IP}. Export does not work on this page!!
    END
    Close Browser
    [Teardown]    Close Browser.AD

Blocked IPs > check page availaility
    [Tags]    Critical
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    #Set Selenium speed    0.5
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        go to.AD    ${URL}//index.php?Controller=BlockedIPs
        Wait until page contains    Blocked IPs
        wait until page contains element    //*[@id="BlockedIPs_wrapper"]/div[4]/button[1]/span
    END
    Close Browser
    [Teardown]    Close Browser.AD

Custom fields > Add custom field and edit it (1 item)
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    ${Test Custom Field}=    set variable    TIME - Custom RF Field [SHOPPER]
    set global variable    ${Test Custom Field}
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Set Records per page    500
        Search CF via table    ${Test Custom Field}    Shoppers    Time
        Edit CF.AD    true    None    true    true
        Open registration page and check agreement box(es)
        Page should contain    ${Test Custom Field}
        Log to console    Registration page does contain "${Test Custom Field}" (+)
        Edit CF.AD    None    None    None    None
        Open registration page and check agreement box(es)
        Page should not contain    ${Test Custom Field}
        Log to console    Registration page does not contain "${Test Custom Field}" (+)
    END
    Close Browser
    [Teardown]    Close Browser.AD

Custom fields > Add custom field (Shoppers)
    [Tags]    NotCritical
    [Template]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    Set CF variables
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        #    Set Records per page    500
        Set Display settings.AD    Select by hierarchy    Do not allow adding items
        Enable shopper registration
        Search profile.AD    ${RobotTestShopper 02}
        ${shopper found ID}    set variable    ${found ID}
        set global variable    ${shopper found ID}
    #Search CF 1
        Search CF via table    ${Test Custom Field1}    Shoppers    Number
        Edit CF.AD    true    None    true    true
        Edit shopper profile(CF).AD    57
        Open registration page and check agreement box(es)
        Wait until page contains    ${Test Custom Field1}
        Log to console    Registration page does contain "${Test Custom Field1}"
        #    Edit CF.AD    None    None    None    None
        #    Open registration page and check agreement box(es)
        #    Page should not contain    ${Test Custom Field1}
        #    Log to console    Registration page does not contain "${Test Custom Field1}"
    #Search CF 2
        Search CF via table    ${Test Custom Field2}    Shoppers    Text line
        Edit CF.AD    true    None    true    true
        Edit shopper profile(CF).AD    RFCF02.Text line value
        Open registration page and check agreement box(es)
        Wait until page contains    ${Test Custom Field2}
        Log to console    Registration page does contain "${Test Custom Field2}"
        #    Edit CF.AD    None    None    None    true
        #    Open registration page and check agreement box(es)
        #    Page should not contain    ${Test Custom Field2}
        #    Log to console    Registration page does not contain "${Test Custom Field2}"
    #Search CF 3
        Search CF via table    ${Test Custom Field3}    Shoppers    Text block
        Edit CF.AD    true    None    true    true
        Edit shopper profile(CF).AD    TextB1
        Open registration page and check agreement box(es)
        Wait until page contains    ${Test Custom Field3}
        Log to console    Registration page does contain "${Test Custom Field3}"
        #    Edit CF.AD    None    None    None    true
        #    Open registration page and check agreement box(es)
        #    Page should not contain    ${Test Custom Field3}
        #    Log to console    Registration page does not contain "${Test Custom Field3}"
    #Search CF 4
        Search CF via table    ${Test Custom Field4}    Shoppers    Date
        Edit CF.AD    true    None    true    true
        Edit shopper profile(CF).AD    05-06-2022
        Open registration page and check agreement box(es)
        Wait until page contains    ${Test Custom Field4}
        Log to console    Registration page does contain "${Test Custom Field4}"
        #    Edit CF.AD    None    None    None    true
        #    Open registration page and check agreement box(es)
        #    Page should not contain    ${Test Custom Field4}
        #    Log to console    Registration page does not contain "${Test Custom Field4}"
        #Search CF 5    ${Show in registration?} | ${Mandatory?} | ${Allow shopper to edit?} | ${Active?}
        Search CF via table    ${Test Custom Field5}    Shoppers    Time
        Edit CF.AD    true    None    true    true
        Run keyword and ignore error    Edit shopper profile(CF).AD    07:30
        Open registration page and check agreement box(es)
        Wait until page contains    ${Test Custom Field5}
        Log to console    Registration page does contain "${Test Custom Field5}"
        #    Edit CF.AD    None    None    None    true
        #    Open registration page and check agreement box(es)
        #    Page should not contain    ${Test Custom Field5}
        #    Log to console    Registration page does not contain "${Test Custom Field5}"
    #Search CF 6
        Search CF via table    ${Test Custom Field6}    Shoppers    Phone
        Edit CF.AD    true    None    true    true
        go to.AD    ${URL}/checkers.php?edit=${shopper found ID}
        Wait until page contains    ${Test Custom Field6}
        Log to console    Shopper profile page does contain "${Test Custom Field6}". Let`s add a value and save
        Execute JavaScript    window.document.getElementById("id${found ID}Editbox").scrollIntoView(true)
        Input text    //*[@id="id${found ID}Editbox"]/input    +972 4 622 81 49
        Wait until page contains element    //*[@id="tabs"]/ul/li[2]
        Click element    //*[@id="tabs"]/ul/li[2]
        Wait until page contains    Robot city 01    8
        Wait until page contains element    //*[@id="tabs"]/ul/li[1]
        Click element    //*[@id="tabs"]/ul/li[1]
        sleep    1
        Wait until page contains    ShopperID
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    saved successfully
        go to.AD    ${URL}/checkers.php?edit=${shopper found ID}
        Wait until page contains    ${Test Custom Field6}
        ${actual value}    Get value    //*[@id="id${found ID}Editbox"]/input
        Should Be Equal    ${actual value}    +972 4 622 81 49
        Log to console    Saved properly "${Test Custom Field6}" = +972 4 622 81 49
        Open registration page and check agreement box(es)
        Wait until page contains    ${Test Custom Field6}
        Log to console    Registration page does contain "${Test Custom Field6}"
        #    Edit CF.AD    None    None    None    true
        #    Open registration page and check agreement box(es)
        #    Page should not contain    ${Test Custom Field6}
        #    Log to console    Registration page does not contain "${Test Custom Field6}"
    #Search CF 7
        Search CF via table    ${Test Custom Field7}    Shoppers    Checkbox
        Edit CF.AD    true    None    true    true
        go to.AD    ${URL}/checkers.php?edit=${shopper found ID}
        Wait until page contains    ${Test Custom Field7}
        Execute JavaScript    window.document.getElementById("id${found ID}Editbox").scrollIntoView(true)
        Set checkbox.AD    //input[@id='field_${found ID}']    true
        Checkbox Should Be Selected    //input[@id='field_${found ID}']
        Wait until page contains element    //*[@id="tabs"]/ul/li[2]
        Click element    //*[@id="tabs"]/ul/li[2]
        Wait until page contains    Robot city 01    8
        Wait until page contains element    //*[@id="tabs"]/ul/li[1]
        Click element    //*[@id="tabs"]/ul/li[1]
        sleep    1
        Wait until page contains    ShopperID
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    saved successfully
        go to.AD    ${URL}/checkers.php?edit=${shopper found ID}
        Wait until page contains    ${Test Custom Field7}
        Checkbox Should Be Selected    //input[@id='field_${found ID}']
        Log to console    Saved properly "${Test Custom Field7}" to '"checked"
        #    Edit CF.AD    None    None    None    true
        #    Open registration page and check agreement box(es)
        #    Page should not contain    ${Test Custom Field7}
        #    Log to console    Registration page does not contain "${Test Custom Field7}"
    #Search CF 8
        Search CF via table    ${Test Custom Field8}    Shoppers    File upload
        Edit CF.AD    true    None    true    true
        go to.AD    ${URL}/checkers.php?edit=${shopper found ID}
        Wait until page contains    ${Test Custom Field8}
        Choose file    //*[@id="id${found ID}Editbox"]/input[7]    ${CURDIR}\\Resources\\Extra files\\Images\\RF good.png
        SLEEP    1
        Wait until page contains element    //*[@id="tabs"]/ul/li[2]
        Click element    //*[@id="tabs"]/ul/li[2]
        Wait until page contains    Robot city 01    8
        sleep    2
        Wait until page contains element    //*[@id="tabs"]/ul/li[1]
        Click element    //*[@id="tabs"]/ul/li[1]
        sleep    2
        Wait until page contains    ShopperID
        Click Save/Add/Delete/Cancel button.AD
        Run keyword and ignore error    Click element    //*[@id="save"]
        Wait until page contains    File RF good.png uploaded successfully!    25
        Wait until page contains    saved successfully    20
        go to.AD    ${URL}/checkers.php?edit=${shopper found ID}
        Wait until page contains    ${Test Custom Field8}
        Execute JavaScript    window.document.getElementById("field_CheckerPriority").scrollIntoView(true)
        Wait until page contains    The following files are attached:
        Page should contain element    xpath=(//a[contains(text(),'RF good.png')])
        Log to console    Saved properly ${Test Custom Field8}. Attached file: RF good.png
    #    Open registration page and check agreement box(es)
    #    Page should contain    ${Test Custom Field8}
    #    Log to console    Registration page does contain "${Test Custom Field8}"
    #    Edit CF.AD    None    None    None    true
    #    Open registration page and check agreement box(es)
    #    Page should not contain    ${Test Custom Field8}
    #    Log to console    Registration page does not contain "${Test Custom Field8}"
    END
    Close Browser
    [Teardown]    Close Browser.AD

Custom fields > Add custom field (Clients)
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    ${Test Custom Field1}=    set variable    RFCF01.Number [Clients]
    set global variable    ${Test Custom Field1}
    ${Test Custom Field2}=    set variable    RFCF02.Text line [Clients]
    set global variable    ${Test Custom Field2}
    ${Test Custom Field3}=    set variable    RFCF03.Text block [Clients]
    set global variable    ${Test Custom Field3}
    ${Test Custom Field4}=    set variable    RFCF04.Date [Clients]
    set global variable    ${Test Custom Field4}
    ${Test Custom Field5}=    set variable    RFCF05.Time [Clients]
    set global variable    ${Test Custom Field5}
    ${Test Custom Field6}=    set variable    RFCF06.Phone [Clients]
    set global variable    ${Test Custom Field6}
    ${Test Custom Field7}=    set variable    RFCF07.Checkbox [Clients]
    set global variable    ${Test Custom Field7}
    ${Test Custom Field8}=    set variable    RFCF08.Fileupload [Clients]
    set global variable    ${Test Custom Field8}
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD
    #Search CF 1
        Search CF via table    ${Test Custom Field1}    Clients    Number
        Edit CF.AD    None    None    None    true
        Enter CF[CLIENT+BRANCH] info.AD    ${Test Custom Field1}    100
    #Search CF 2
        Search CF via table    ${Test Custom Field2}    Clients    Text line
        Edit CF.AD    None    None    None    true
        Enter CF[CLIENT+BRANCH] info.AD    ${Test Custom Field2}    RFCF02.Text line value
    #Search CF 3
        Search CF via table    ${Test Custom Field3}    Clients    Text block
        Edit CF.AD    None    None    None    true
        Enter CF[CLIENT+BRANCH] info.AD    ${Test Custom Field3}    RFCF03.Text block value
    #Search CF 4
        Search CF via table    ${Test Custom Field4}    Clients    Date
        Edit CF.AD    None    None    None    true
        Enter CF[CLIENT+BRANCH] info.AD    ${Test Custom Field4}    21-01-2025
    #Search CF 5
        Search CF via table    ${Test Custom Field5}    Clients    Time
        Edit CF.AD    None    None    None    true
        Enter CF[CLIENT+BRANCH] info.AD    ${Test Custom Field5}    12:25
    #Search CF 6
        Search CF via table    ${Test Custom Field6}    Clients    Phone
        Edit CF.AD    None    None    None    true
        go to    ${URL}/clients.php?edit=${client ID}
        Wait until page contains    ${Test Custom Field6}
        Log to console    Client page does contain "${Test Custom Field6}". Let`s add a value and save
        Execute JavaScript    window.document.getElementById("id${found ID}Editbox").scrollIntoView(true)
        Input text    //*[@id="id${found ID}Editbox"]/input    +972 4 622 81 49
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    saved successfully
        go to    ${URL}/clients.php?edit=${client ID}
        Wait until page contains    ${Test Custom Field6}
        ${actual value}    Get value    //*[@id="id${found ID}Editbox"]/input
        Should Be Equal    ${actual value}    +972 4 622 81 49
        Log to console    Saved properly "${Test Custom Field6}" = +972 4 622 81 49
    #Search CF 7
        Search CF via table    ${Test Custom Field7}    Clients    Checkbox
        Edit CF.AD    None    None    None    true
        go to    ${URL}/clients.php?edit=${client ID}
        Wait until page contains    ${Test Custom Field7}
        Log to console    Client page does contain "${Test Custom Field7}". Let`s add a value and save
        Execute JavaScript    window.document.getElementById("id${found ID}Editbox").scrollIntoView(true)
        Set checkbox.AD    //input[@id='field_${found ID}']    true
        Checkbox Should Be Selected    //input[@id='field_${found ID}']
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    saved successfully
        go to    ${URL}/clients.php?edit=${client ID}
        Wait until page contains    ${Test Custom Field7}
        Checkbox Should Be Selected    //input[@id='field_${found ID}']
        Log to console    Saved properly "${Test Custom Field7}" to '"checked"
    #Search CF 8
        Search CF via table    ${Test Custom Field8}    Clients    File upload
        Edit CF.AD    None    None    None    true
        go to    ${URL}/clients.php?edit=${client ID}
        Wait until page contains    ${Test Custom Field8}
        Log to console    Client page does contain "${Test Custom Field8}". Let`s add a file and save
        Execute JavaScript    window.document.getElementById("id${found ID}Editbox").scrollIntoView(true)
        Choose file    //*[@id="id${found ID}Editbox"]/input[7]    ${CURDIR}\\Resources\\Extra files\\Images\\RF good.png
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    saved successfully
        go to    ${URL}/clients.php?edit=${client ID}
        Wait until page contains    ${Test Custom Field8}
        Page should contain    The following files are attached:
        Page should contain element    xpath=(//a[contains(text(),'RF good.png')])
        Page should contain    Attach media file (max size: 6.50 M)
        Log to console    Saved properly ${Test Custom Field8}. Attached file: \\RF good.png
    END
    Close Browser
    [Teardown]    Close Browser.AD

Custom fields > Add custom field (Branches)
    [Tags]    (FIX?)
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    ${Test Custom Field1}=    set variable    RFCF01.Number [Branches]
    set global variable    ${Test Custom Field1}
    ${Test Custom Field2}=    set variable    RFCF02.Text line [Branches]
    set global variable    ${Test Custom Field2}
    ${Test Custom Field3}=    set variable    RFCF03.Text block [Branches]
    set global variable    ${Test Custom Field3}
    ${Test Custom Field4}=    set variable    RFCF04.Date [Branches]
    set global variable    ${Test Custom Field4}
    ${Test Custom Field5}=    set variable    RFCF05.Time [Branches]
    set global variable    ${Test Custom Field5}
    ${Test Custom Field6}=    set variable    RFCF06.Phone [Branches]
    set global variable    ${Test Custom Field6}
    ${Test Custom Field7}=    set variable    RFCF07.Checkbox [Branches]
    set global variable    ${Test Custom Field7}
    ${Test Custom Field8}=    set variable    RFCF08.Fileupload [Branches]
    set global variable    ${Test Custom Field8}
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD
        Search Element.AD    ${Short auto branch name 01}    id=client_branches_table
        ${branch ID}    Get text    //*[@id="client_branches_table"]/tbody/tr/td[1]
        Log to console    ${branch ID}
        Set global variable    ${branch ID}
    #Search CF 1
        Search CF via table    ${Test Custom Field1}    Branches    Number
        Edit CF.AD    None    None    None    true
        Enter CF[CLIENT+BRANCH] info.AD    ${Test Custom Field1}    100
    #Search CF 2
        Search CF via table    ${Test Custom Field2}    Branches    Text line
        Edit CF.AD    None    None    None    true
        Enter CF[CLIENT+BRANCH] info.AD    ${Test Custom Field2}    RFCF02.Text line value
    #Search CF 3
        Search CF via table    ${Test Custom Field3}    Branches    Text block
        Edit CF.AD    None    None    None    true
        Enter CF[CLIENT+BRANCH] info.AD    ${Test Custom Field3}    RFCF03.Text block value
    #Search CF 4
        Search CF via table    ${Test Custom Field4}    Branches    Date
        Edit CF.AD    None    None    None    true
        Enter CF[CLIENT+BRANCH] info.AD    ${Test Custom Field3}    01-02-2022
    #Search CF 5
        Search CF via table    ${Test Custom Field5}    Branches    Time
        Edit CF.AD    None    None    None    true
        Enter CF[CLIENT+BRANCH] info.AD    ${Test Custom Field5}    12:25
    #Search CF 6
        Search CF via table    ${Test Custom Field6}    Branches    Phone
        Edit CF.AD    None    None    None    true
        go to    ${URL}/branches.php?edit=${branch ID}&client=${client ID}
        Wait until page contains    ${Test Custom Field6}
        Log to console    Page does contain "${Test Custom Field6}". Let`s add a value and save
        Execute JavaScript    window.document.getElementById("id${found ID}Editbox").scrollIntoView(true)
        Input text    //*[@id="id${found ID}Editbox"]/input    +972 4 622 81 49
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    saved successfully
        go to    ${URL}/branches.php?edit=${branch ID}&client=${client ID}
        Wait until page contains    ${Test Custom Field6}
        ${actual value}    Get value    //*[@id="id${found ID}Editbox"]/input
        Should Be Equal    ${actual value}    +972 4 622 81 49
        Log to console    Saved properly "${Test Custom Field6}" = +972 4 622 81 49
    #Search CF 7
        Search CF via table    ${Test Custom Field7}    Branches    Checkbox
        Edit CF.AD    None    None    None    true
        go to    ${URL}/branches.php?edit=${branch ID}&client=${client ID}
        Wait until page contains    ${Test Custom Field7}
        Log to console    Page does contain "${Test Custom Field7}". Let`s add a value and save
        Execute JavaScript    window.document.getElementById("id${found ID}Editbox").scrollIntoView(true)
        Set checkbox.AD    //input[@id='field_${found ID}']    true
        Checkbox Should Be Selected    //input[@id='field_${found ID}']
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    saved successfully
        go to    ${URL}/branches.php?edit=${branch ID}&client=${client ID}
        Wait until page contains    ${Test Custom Field7}
        Checkbox Should Be Selected    //input[@id='field_${found ID}']
        Log to console    Saved properly "${Test Custom Field7}" to '"checked"
    #Search CF 8
        Search CF via table    ${Test Custom Field8}    Branches    File upload
        Edit CF.AD    None    None    None    true
        go to    ${URL}/branches.php?edit=${branch ID}&client=${client ID}
        Wait until page contains    ${Test Custom Field8}
        Log to console    Page does contain "${Test Custom Field8}". Let`s add a file and save
        Execute JavaScript    window.document.getElementById("id${found ID}Editbox").scrollIntoView(true)
        Choose file    //*[@id="id${found ID}Editbox"]/input[8]    ${CURDIR}\\Resources\\Extra files\\Images\\RF good.png
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    saved successfully
        go to    ${URL}/branches.php?edit=${branch ID}&client=${client ID}
        Wait until page contains    ${Test Custom Field8}
        Page should contain    The following files are attached:
        Page should contain element    xpath=(//a[contains(text(),'RF good.png')])
        Page should contain    Attach media file (max size: 6.50 M)
        Log to console    Saved properly ${Test Custom Field8}. Attached file: "RF good.png"
    END
    Close Browser
    [Teardown]    Close Browser.AD

Custom fields > Add custom field (Users)
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    ${Test Custom Field1}=    set variable    RFCF01.Number [Users]
    set global variable    ${Test Custom Field1}
    ${Test Custom Field2}=    set variable    RFCF02.Text line [Users]
    set global variable    ${Test Custom Field2}
    ${Test Custom Field3}=    set variable    RFCF03.Text block [Users]
    set global variable    ${Test Custom Field3}
    ${Test Custom Field4}=    set variable    RFCF04.Date [Users]
    set global variable    ${Test Custom Field4}
    ${Test Custom Field5}=    set variable    RFCF05.Time [Users]
    set global variable    ${Test Custom Field5}
    ${Test Custom Field6}=    set variable    RFCF06.Phone [Users]
    set global variable    ${Test Custom Field6}
    ${Test Custom Field7}=    set variable    RFCF07.Checkbox [Users]
    set global variable    ${Test Custom Field7}
    ${Test Custom Field8}=    set variable    RFCF08.Fileupload [Users]
    set global variable    ${Test Custom Field8}
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD
    #Search CF 1
        Search CF via table    ${Test Custom Field1}    Users    Number
        Edit CF.AD    None    None    None    None
        go to    ${URL}/users.php?&addnew=yup&upClientName=${client ID}
        Page should contain    ${Test Custom Field1}
        Log to console    User page does contain "${Test Custom Field1}"
    #Search CF 2
        Search CF via table    ${Test Custom Field2}    Users    Text line
        Edit CF.AD    None    None    None    None
        go to    ${URL}/users.php?&addnew=yup&upClientName=${client ID}
        Page should contain    ${Test Custom Field2}
        Log to console    User page does contain "${Test Custom Field2}"
    #Search CF 3
        Search CF via table    ${Test Custom Field3}    Users    Text block
        Edit CF.AD    None    None    None    None
        go to    ${URL}/users.php?&addnew=yup&upClientName=${client ID}
        #    Page should contain    ${Test Custom Field3}
        Log to console    User page does contain "${Test Custom Field3}"
    #Search CF 4
        Search CF via table    ${Test Custom Field4}    Users    Date
        Edit CF.AD    None    None    None    None
        go to    ${URL}/users.php?&addnew=yup&upClientName=${client ID}
        #    Page should contain    ${Test Custom Field4}
        Log to console    User page does contain "${Test Custom Field4}"
    #Search CF 5
        Search CF via table    ${Test Custom Field5}    Users    Time
        Edit CF.AD    None    None    None    None
        go to    ${URL}/users.php?&addnew=yup&upClientName=${client ID}
        #    Page should contain    ${Test Custom Field5}
        Log to console    User page does contain "${Test Custom Field5}"
    #Search CF 6
        Search CF via table    ${Test Custom Field6}    Users    Phone
        Edit CF.AD    None    None    None    None
        go to    ${URL}/users.php?&addnew=yup&upClientName=${client ID}
        #    Page should contain    ${Test Custom Field6}
        Log to console    User
    #Search CF 7
        Search CF via table    ${Test Custom Field7}    Users    Checkbox
        Edit CF.AD    None    None    None    None
        go to    ${URL}/users.php?&addnew=yup&upClientName=${client ID}
        #    Page should contain    ${Test Custom Field7}
        Log to console    User page does contain "${Test Custom Field7}"
    #Search CF 8
        Search CF via table    ${Test Custom Field8}    Users    File upload
        Edit CF.AD    None    None    None    None
        go to    ${URL}/users.php?&addnew=yup&upClientName=${client ID}
        #    Page should contain    ${Test Custom Field8}
        Log to console    User page does contain "${Test Custom Field8}"
    END
    Close Browser
    [Teardown]    Close Browser.AD

Custom fields > Add custom field (Panelists)
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    ${Test Custom Field1}=    set variable    RFCF01.Number [Panelists]
    set global variable    ${Test Custom Field1}
    ${Test Custom Field2}=    set variable    RFCF02.Text line [Panelists]
    set global variable    ${Test Custom Field2}
    ${Test Custom Field3}=    set variable    RFCF03.Text block [Panelists]
    set global variable    ${Test Custom Field3}
    ${Test Custom Field4}=    set variable    RFCF04.Date [Panelists]
    set global variable    ${Test Custom Field4}
    ${Test Custom Field5}=    set variable    RFCF05.Time [Panelists]
    set global variable    ${Test Custom Field5}
    ${Test Custom Field6}=    set variable    RFCF06.Phone [Panelists]
    set global variable    ${Test Custom Field6}
    ${Test Custom Field7}=    set variable    RFCF07.Checkbox [Panelists]
    set global variable    ${Test Custom Field7}
    ${Test Custom Field8}=    set variable    RFCF08.Fileupload [Panelists]
    set global variable    ${Test Custom Field8}
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD
    #Search CF 1
        Search CF via table    ${Test Custom Field1}    Panelists    Number
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=Panelists
        Page should contain    ${Test Custom Field1}
    #Search CF 2
        Search CF via table    ${Test Custom Field2}    Panelists    Text line
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=Panelists
        Page should contain    ${Test Custom Field2}
    #Search CF 3
        Search CF via table    ${Test Custom Field3}    Panelists    Text block
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=Panelists
        Page should contain    ${Test Custom Field3}
    #Search CF 4
        Search CF via table    ${Test Custom Field4}    Panelists    Date
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=Panelists
        Page should contain    ${Test Custom Field4}
    #Search CF 5
        Search CF via table    ${Test Custom Field5}    Panelists    Time
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=Panelists
        Page should contain    ${Test Custom Field5}
    #Search CF 6
        Search CF via table    ${Test Custom Field6}    Panelists    Phone
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=Panelists
        Page should contain    ${Test Custom Field6}
    #Search CF 7
        Search CF via table    ${Test Custom Field7}    Panelists    Checkbox
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=Panelists
        Page should contain    ${Test Custom Field7}
    #Search CF 8
        Search CF via table    ${Test Custom Field8}    Panelists    File upload
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=Panelists
        Page should contain    ${Test Custom Field8}
    END
    Close Browser
    [Teardown]    Close Browser.AD

Custom fields > Add custom field (Orders)
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    ${Test Custom Field1}=    set variable    RFCF01.Number [Orders]
    set global variable    ${Test Custom Field1}
    ${Test Custom Field2}=    set variable    RFCF02.Text line [Orders]
    set global variable    ${Test Custom Field2}
    ${Test Custom Field3}=    set variable    RFCF03.Text block [Orders]
    set global variable    ${Test Custom Field3}
    ${Test Custom Field4}=    set variable    RFCF04.Date [Orders]
    set global variable    ${Test Custom Field4}
    ${Test Custom Field5}=    set variable    RFCF05.Time [Orders]
    set global variable    ${Test Custom Field5}
    ${Test Custom Field6}=    set variable    RFCF06.Phone [Orders]
    set global variable    ${Test Custom Field6}
    ${Test Custom Field7}=    set variable    RFCF07.Checkbox [Orders]
    set global variable    ${Test Custom Field7}
    ${Test Custom Field8}=    set variable    RFCF08.Fileupload [Orders]
    set global variable    ${Test Custom Field8}
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search Client.AD
    #Search CF 1
        Search CF via table    ${Test Custom Field1}    Orders    Number
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=CritOrders
        Page should contain    ${Test Custom Field1}
    #Search CF 2
        Search CF via table    ${Test Custom Field2}    Orders    Text line
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=CritOrders
        Page should contain    ${Test Custom Field2}
    #Search CF 3
        Search CF via table    ${Test Custom Field3}    Orders    Text block
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=CritOrders
        Page should contain    ${Test Custom Field3}
    #Search CF 4
        Search CF via table    ${Test Custom Field4}    Orders    Date
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=CritOrders
        Page should contain    ${Test Custom Field4}
    #Search CF 5
        Search CF via table    ${Test Custom Field5}    Orders    Time
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=CritOrders
        Page should contain    ${Test Custom Field5}
    #Search CF 6
        Search CF via table    ${Test Custom Field6}    Orders    Phone
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=CritOrders
        Page should contain    ${Test Custom Field6}
    #Search CF 7
        Search CF via table    ${Test Custom Field7}    Orders    Checkbox
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=CritOrders
        Page should contain    ${Test Custom Field7}
    #Search CF 8
        Search CF via table    ${Test Custom Field8}    Orders    File upload
        Edit CF.AD    None    None    None    None
        go to    ${URL}/table-fields.php?page_var_filter_TableLink=CritOrders
        Page should contain    ${Test Custom Field8}
    END
    Close Browser
    [Teardown]    Close Browser.AD

Attachment types > Add Attachment types (all types)
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Add attachment type name.AD    Video [RF]    1000.00    10000    10000    webm, mkv, flv, flv, vob, ogv, ogg, drc, gif, gifv, mng, avi, MTS, M2TS, TS, mov, qt, wmv, yuv, rm, \ rmvb, viv, asf, amv, mp4, m4p, m4v, mpg, mp2, mpeg, mpe, mpv, mpg, mpeg, m2v, svi, 3gp, 3g2, mxf, roq, nsv, flv, f4v, f4p, f4a, f4b    None    Video
        Add attachment type name.AD    Picture [RF]    1000.00    10000    10000    .apng, .avif, .gif, .jpg, .jpeg, .jfif, .pjpeg, .pjp, .png, .svg, .webp    None    Picture
        Add attachment type name.AD    General [RF]    1000.00    10000    10000    exe, php, xlsx, xls    None    General
        Add attachment type name.AD    Recording [RF]    1000.00    10000    10000    .mp3, .dss, .wma, .wav    None    Recording
        Add attachment type name.AD    Document [RF]    1000.00    10000    10000    .doc, .docm, .docx, .docx, .dot, .dotm, .dotx, .htm, .html, .mht, .mhtml, .odt, .pdf, .rtf, .txt, .wps, .xml, .xps    None    Document
    END
    Close Browser
    [Teardown]    Close Browser.AD
