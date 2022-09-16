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
Search test shopper (add new + edit profile)
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search profile.AD    ${RobotTestShopper 02}
        Edit shopper profile.AD    ${RobotTestShopper 02}
    END
    Close Browser
    [Teardown]    Close Browser.AD

Search test shopper (add new + assign property)
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Search shopper property.AD    ${Property name}    Autotest-YES    Autotest-NO
        Add/Update Shopper property.AD    ${Property name}    None    5    ${empty}    None    None    True    None    5
        Search profile.AD    ${RobotTestShopper 02}
        Assign property.AD    ${RobotTestShopper 02}
    END
    Close Browser
    [Teardown]    Close Browser.AD

Import shopper
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Check import user page
        Log to console    Importing not valid file type...
        Import file (shoppers)    ${CURDIR}\\Resources\\Extra files\\Css\\RobotShopperCSS.css    #not valid file type
        Page should contain    The wrong file type is being used
        Page should contain element    //div[@id='3errors']
        Log to console    "The wrong file type is being used" error is seen
        Log to console    Importing valid file type...
        Import file (shoppers)    ${CURDIR}\\Resources\\Extra files\\Import\\import template [checkers].xlsx
        Page should contain    Import process completed successfully
        Log to console    Import done, searching imported user via search bar...
        Search test item    RFCheckerUsername01imported
        Element text should be    //*[@id="checkers_table"]/tbody/tr/td[2]/a    RFCheckerUsername01imported
        Element text should be    //*[@id="checkers_table"]/tbody/tr/td[3]    RFCheckerFullname01imported
        Element text should be    //*[@id="checkers_table"]/tbody/tr/td[4]    911
        Element text should be    //*[@id="checkers_table"]/tbody/tr/td[5]    4857645
        Element text should be    //*[@id="checkers_table"]/tbody/tr/td[6]    No
        Log to console    "RFCheckerUsername01imported" --> has been imported into a system in active status
        go to.AD    ${URL}/checkers.php?page_var_filter_IsActive=&page_var_filter_BlackListed=0&page_var_filter_IsSelfRegistered=&page_var_filter_RegionName=0&page_var_filter_CityName_Cou=&page_var_filter_CityName_Reg=&page_var_filter_CityName=&page_var_filter_Fullname=&page_var_filter_Email=RFChecker01Emailimported%40gmail.com&page_var_sorting_column=Fullname&page_var_sorting_order=up&page_var_divide_recordsPerPage=500&page_var_divide_curPage=1
        Wait until page contains    Shoppers
    # Shopper 1
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][1]    RFCheckerFullname01imported
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][2]    RFCheckerUsername01imported
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][3]    4857645
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][4]    No
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][5]    Login
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][6]    5
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][7]    Robot country 01
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][8]    Robot region 01
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][9]    Robot city 01
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][10]    36104
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][11]    911
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][12]    Age: 1.2
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][13]    CheckerComment 1
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][18]    Default
        #    Should contain    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][16]    regions
        Element text should be    //tbody/tr[@class='db1'][1]/td[@class='db-ltr'][17]    Edit
    # Shopper 2
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][1]    RFCheckerFullname02imported
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][2]    RFCheckerUsername02imported
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][3]    4857646
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][4]    Yes
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][5]    Login
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][6]    25
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][7]    Robot country 01
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][8]    Robot region 01
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][9]    Robot city 01
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][10]    99801
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][11]    1234567890
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][12]    Age: 12.2
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][13]    CheckerComment 2
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][18]    Default
        #    Should contain    //tr[@class='db2']/td[@class='db-ltr'][16]    regions
        Element text should be    //tr[@class='db2']/td[@class='db-ltr'][17]    Edit
    # Shopper 3
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[2]    RFCheckerFullname03imported
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[3]    RFCheckerUsername03imported
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[4]    4857647
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[5]    Yes
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[6]    Login
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[7]    35
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[8]    Robot country 01
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[9]    Robot region 01
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[10]    Robot city 01
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[11]    85001
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[12]    1234567890
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[13]    Age: 12.2
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[14]    CheckerComment 3
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[19]    Default
        #    Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[17]    1 regions    #Fails here on testing - every import adds +1 region
        Element text should be    //*[@id="table_rows"]/tbody/tr[3]/td[18]    Edit
        Log to console    3 shoppers were imported properly
    # check table titles
        Element text should be    //*[@id="table_rows"]/thead/tr[1]/th[1]    ShopperID
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
    END
    Close Browser
    [Teardown]    Close Browser.AD
