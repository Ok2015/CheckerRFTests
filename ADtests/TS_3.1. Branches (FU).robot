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
Client. Add/Update branch
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
    #
        Set "City selection style".AD    Instant search box    Do not allow adding items
    #
        Search Client.AD    ${RobotTestClient}
        Search branch.AD
        Add/edit new branch.AD    ${Short auto branch name 01}    ${Full auto branch name 01}
        Set "City selection style".AD    Select by hierarchy    Do not allow adding items
        Search branch.AD
        Add/edit new branch.AD    ${Short auto branch name 01}    ${Full auto branch name 01}
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Add branch characteristic (Optional+Mandatory)
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${Bproperty 01}    Set variable    Manager
        ${Bproperty 02}    Set variable    Model
        Set global variable    ${Bproperty 01}
        Set global variable    ${Bproperty 02}
        Search client using search bar.AD    ${RobotTestClient}
        Add branch characteristic    ${Client ID}    ${Bproperty 01}    Mandatory=0
        Add branch characteristic value    ${found branch characteristic ID}    ${Bproperty 01} 1    78a805    1    1.000000
        Add branch characteristic value    ${found branch characteristic ID}    ${Bproperty 01} 2    05a871    2    2.000000
        go to.AD    ${URL}/client-prop-values.php?prop=${found branch characteristic ID}
        Page Should Contain    ${Bproperty 01} 1
        Page Should Contain    ${Bproperty 01} 2
    #
        Add branch characteristic    ${Client ID}    ${Bproperty 02}    Mandatory
        Add branch characteristic value    ${found branch characteristic ID}    ${Bproperty 02} 1    15d589    1    1.000000
        Add branch characteristic value    ${found branch characteristic ID}    ${Bproperty 02} 2    34ba14    2    2.000000
        go to.AD    ${URL}/client-prop-values.php?prop=${found branch characteristic ID}
        Page Should Contain    ${Bproperty 02} 1
        Page Should Contain    ${Bproperty 02} 2
        Search branch.AD
        Wait until page contains element    //input[@id='field_branchName']
        Select dropdown.AD    //*[@id="prop${Dictionary2}[${Bproperty 01}]"]    //*[@id="prop${Dictionary2}[${Bproperty 01}]"]/option[2]
        Select dropdown.AD    //*[@id="prop${Dictionary2}[${Bproperty 02}]"]    //*[@id="prop${Dictionary2}[${Bproperty 02}]"]/option[2]
        Click Save/Add/Delete/Cancel button.AD
        Wait until page contains    successfully
        go to.AD    ${URL}/branches.php?page_var_filter_IsActive&edit=${found ID}&client=${client ID}
        Validate value (value)    //*[@id="prop${Dictionary2}[${Bproperty 01}]"]    ${Dictionary2}[${Bproperty 01} 1]
        Validate value (value)    //*[@id="prop${Dictionary2}[${Bproperty 02}]"]    ${Dictionary2}[${Bproperty 02} 1]
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Add branch contact
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        ${Bcontact 01}    Set variable    Branch contact RF 01
        ${Bcontact 02}    Set variable    Branch contact RF 02
    #
        Search Client.AD    ${RobotTestClient}
        Search branch.AD
    #
        Add branch contact.AD    ${Bcontact 01}    true
        Add branch contact.AD    ${Bcontact 02}    None
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Branch characteristic value is deleted successfully
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        ${Name}    Set variable    A - will be deleted
        Add branch characteristic    ${found ID}    ${Name}    Mandatory=1
        Add branch characteristic value    ${found branch characteristic ID}    B - value will be deleted by RF    15d589    1    1.000000
        go to.AD    ${URL}/client-props.php?client=${Client ID}
        Page Should Contain    ${Name}
        Log to console    Created branch property: ${RF property} (its ID: ${found branch characteristic ID})
        Remove branch characteristic
        go to.AD    ${URL}/client-props.php?client=${Client ID}
        Page Should Not Contain    ${Name}
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Branch import throws error in case wrong file format
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        Search Element.AD    ${RobotTestClient}    id=clients_table
        Check import page (dafault state)
        go to.AD    ${URL}/import-branches.php
        Log to console    Let`s import wrong file format
        Import file (branches)    ${CURDIR}\\Resources\\Extra files\\Css\\RobotShopperCSS.css    #not valid file type
        Wait until page contains    The wrong file type is being used
        Wait until page contains    Cannot find mandatory field in file: BranchName Please fix the problem and upload again.
        Wait until page contains    Cannot find mandatory field in file: BranchFullname Please fix the problem and upload again.
        Wait until page contains    Cannot find mandatory field in file: CityName Please fix the problem and upload again.
        Log to console    "The wrong file type is being used" error can be seen
        Log to console    Let`s import valid file format - 4 branches in a file
    END
    Close Browser
    [Teardown]    Close Browser.AD

Client. Branch import updates mandat+opt fields
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        Prepare download folder.AD
        SET UP
        Excel: process file.AD    ${CURDIR}\\Resources\\Extra files\\Import\\import template [branches].xlsx    Checker Report    2
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search client using search bar.AD    ${RobotTestClient}
        Search Element.AD    ${RobotTestClient}    id=clients_table
        Check import page (dafault state)
        go to.AD    ${URL}/import-branches.php
        Import file (branches)    ${CURDIR}\\Resources\\Extra files\\Import\\import template [branches].xlsx
        Wait until page contains    Import process completed successfully, added 4 branches
        Log to console    Import process completed successfully, added 4 branches
        go to.AD    ${URL}/branches.php?page_var_filter_IsActive=&page_var_filter_RegionName=0&page_var_filter_CityName_Cou=&page_var_filter_CityName_Reg=&page_var_filter_CityName=&page_var_filter_branchName=&page_var_sorting_column=branchName&page_var_sorting_order=up&page_var_divide_recordsPerPage=100&page_var_divide_curPage=1&client=${found ID}
        Log to console    Checking results on client branches page (${URL}/branches.php?client=${found ID})
    #
        Wait until page contains element    //input[@id='page_var_filter_branchName']
        Input text    //input[@id='page_var_filter_branchName']    ${Dictionary}[BranchName]
        Log to console    Searching "${Dictionary}[BranchName]"
        Click element    //*[@id="update"]
        Wait until page contains element    //*[@id="table_rows"]/thead/tr[1]/th[1]
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[1]    ID
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[2]    Short branch name
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[3]    Full name
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[4]    Branch code
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[5]    Active?
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[6]    Address
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[7]    House number
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[8]    City
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[9]    Region name
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[10]    Postcode
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[11]    Phone
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[12]    Users
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[13]    Branch contacts
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[14]    Set geolocation coordinates manually
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[15]    Latitude
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[16]    Longitude
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[17]    Target final grade
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[18]    Edit branch task contacts
    #
        Validate value (text)    //td[@class='db-ltr'][1]    ${Dictionary}[BranchName]
        Validate value (text)    //td[@class='db-ltr'][2]    ${Dictionary}[BranchFullname]
        Validate value (text)    //td[@class='db-ltr'][3]    ${Dictionary}[BranchCode]
        Validate value (text)    //td[@class='db-ltr'][4]    No
        Validate value (text)    //td[@class='db-ltr'][5]    ${Dictionary}[Address]
        Validate value (text)    //*[@id="table_rows"]/tbody/tr/td[8]    ${Dictionary}[CityName]
        Validate value (number)    //*[@id="table_rows"]/tbody/tr/td[10]    ${Dictionary}[Zipcode](string)
        Validate value (number)    //*[@id="table_rows"]/tbody/tr/td[11]    ${Dictionary}[Phone]
    END
    Close Browser
    [Teardown]    Close Browser.AD
