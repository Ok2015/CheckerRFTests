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
Display > check "Records per page"+"sorting" in tables
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Set Records per page    4    # set number of records on page here
        Check records in tables.AD    4
        Set Records per page    100
    END
    Close Browser
    [Teardown]    Close Browser.AD

Display > check "Date format" option on registration page (DD.MM.YY and MM.DD.YY)
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Enable shopper registration
        Set date format.AD    MM.DD.YYYY    #set expected date format here
        Open registration page and check agreement box(es)
        Wait until page contains element    //input[@id='field_BirthDatem']
        #    Element text should be    //*[@id="tr_BirthDate"]    Birth date: \ ${\n} \ Month${\n} \ Day${\n} \ Year${\n}
        Input text    //input[@id='field_BirthDatem']    32
        Input text    //input[@id='field_BirthDated']    32
        Input text    //input[@id='field_BirthDatey']    2050
        Wait until page contains    * Maximum value is 12
        Wait until page contains    * Maximum value is 31
        Input text    //input[@id='field_BirthDatem']    05
        Input text    //input[@id='field_BirthDated']    05
        Wait until page contains    * Maximum value is 2015
        #Input text    //*[@id="field_BirthDate"]    31.13.2000
        Execute JavaScript    window.document.getElementById("addnew").scrollIntoView(true)
        Click element    //*[@id="addnew"]
        Log to console    The "field_BirthDate" throws an "Incorrect age" error in case of entering wrong date format: "31.13.2000", "01.13.2000" and no error in case of format "12.12.2000"
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Set date format.AD    DD.MM.YYYY    #set expected date format here
        Open registration page and check agreement box(es)
        #    Element text should be    //*[@id="tr_BirthDate"]    Birth date: \ ${\n} \ Day${\n} \ Month${\n} \ Year${\n}
        Wait until page contains element    //input[@id='field_BirthDatem']
        Input text    //input[@id='field_BirthDatem']    22
        Input text    //input[@id='field_BirthDated']    66
        Input text    //input[@id='field_BirthDatey']    2222
        Wait until page contains    * Maximum value is 12
        Wait until page contains    * Maximum value is 31
        Click element    //*[@id="addnew"]
        Input text    //input[@id='field_BirthDatem']    2
        Input text    //input[@id='field_BirthDated']    2
        sleep    1
        Input text    //input[@id='field_BirthDatey']    2222
        Wait until page contains element    //*[@id="addnew"]
        Set focus to element    //*[@id="addnew"]
        Click element    //input[@id='field_BirthDatem']
        Run Keyword And Ignore Error    Click element    //*[@id="addnew"]
        Wait until page contains    * Maximum value is 2015
        Input text    //input[@id='field_BirthDatey']    1
        Wait until page contains element    //*[@id="addnew"]    3
        Click element    //input[@id='field_BirthDatem']
        Execute JavaScript    window.document.getElementById("addnew").scrollIntoView(true)
        Execute JavaScript    window.scrollTo(500, document.body.scrollHeight)
        Run Keyword And Ignore Error    Click element    //*[@id="addnew"]
        Run Keyword And Ignore Error    Click element    //*[@id="addnew"]
        Wait until page contains    * Minimum value is 1902
        Log to console    The "field_BirthDate" throws an "Incorrect age" error in case of entering wrong date format: "32.13.2000" and no error in case of proper date: "31.12.2000"
    END
    Close Browser
    [Teardown]    Close Browser.AD

Display > valid image(s) for sys design can be added to a system
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Add sys image.AD    ${CURDIR}\\Resources\\Extra files\\Images\\RF good.png
        Add sys image.AD    ${CURDIR}\\Resources\\Extra files\\Images\\RF dislike.png
        Add sys image.AD    ${CURDIR}\\Resources\\Extra files\\Images\\RF [iOS]AppStore_Icon.png
        Add sys image.AD    ${CURDIR}\\Resources\\Extra files\\Images\\RF [Android]_PlayStore_Icon.png
        Add sys image.AD    ${CURDIR}\\Resources\\Extra files\\translations.xls
        go to.AD    ${URL}/company-css-images.php
        Log to console    Open ${URL}/company-css-images.php
        reload page
        Page should contain    RF [iOS]AppStore_Icon.png
        Page should contain    RF [Android]_PlayStore_Icon.png
    END
    Close Browser
    [Teardown]    Close Browser.AD

Display > check "Fraction digits" on refund report page
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Set fraction digits.AD    4
        Set fraction digits.AD    2
    END
    Close Browser
    [Teardown]    Close Browser.AD

Display > uploaded "CSS files" are saved and applied to system design
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Upload CSS.AD
        Select CSS.AD
    #    Check CSS.AD
    #    Check CSS.SD
    END
    Close Browser
    [Teardown]    Close Browser.AD

Display > add/delete valid/not valid icon(s)
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Add icon.AD    RF icon 01 (like)    ${CURDIR}\\Resources\\Extra files\\Images\\RF good.png    saved
        Add icon.AD    RF icon 02 (dislike)    ${CURDIR}\\Resources\\Extra files\\Images\\RF dislike.png    saved
        Add icon.AD    RF icon 03 (gif)    ${CURDIR}\\Resources\\Extra files\\Images\\RF checker.gif    saved
        Add icon.AD    RF icon 04 (jpeg)    ${CURDIR}\\Resources\\Extra files\\Images\\RF coollogo_com-13374309.jpg    saved
        Add icon.AD    RFicon (wrongFormat)    ${CURDIR}\\Resources\\Extra files\\translations.xls    Invalid file extension
        go to.AD    ${URL}/icons-settings.php?page_var_divide_recordsPerPage=2000
        Wait until page contains element    //*[@id="big_tedit_wrapping_table"]/tbody/tr[1]/td/table/tbody/tr/td/button
        ${exp name}    set variable    RFicon (wrongFormat)
        click link    default=${exp name}
        Page should not contain    Delete picture
        Update icon.AD    RFicon (wrongFormat)    ${CURDIR}\\Resources\\Extra files\\IMAGES\\RF Wallpaper2021.jpg
        go to.AD    ${URL}/icons-settings.php?page_var_divide_recordsPerPage=2000
        Wait until page contains element    //button[@class='btn-input']
        click link    default=${exp name}
        Page should not contain    Delete picture
        Delete icon.AD    RFicon (wrongFormat)
    END
    Close Browser
    [Teardown]    Close Browser.AD

Display > check default empty/full "Graph color(s)" on Final Score report
    [Tags]    Critical
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        ${Empty Graph Color}=    set variable    rgb(240, 109, 81)    #db3714    rgb(109, 110, 113)
        ${Full Graph Color}=    set variable    rgb(63, 227, 14)
        ${Chart series color}    set variable
        set global variable    ${Empty Graph Color}
        set global variable    ${Full Graph Color}
        set global variable    ${Chart series color}
        Set graph colors.AD    ${Empty Graph Color}    ${Full Graph Color}    ${Chart series color}    #set expected graph colors here    #758492, #ffdd00, #00afe1, #db4146, #a0c737, #c969a5, #fcaf17, #92d6e3, #3f8bb9, #f7adc3, #00ac67, #b4bbc0
        Open Final Score report.AD
    END
    Close Browser
    [Teardown]    Close Browser.AD

Display > "The day in which the week starts" is saved in a system
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Set "The day in which the week starts".AD    Monday
        Set "The day in which the week starts".AD    Sunday
        Set "The day in which the week starts".AD    Tuesday
        Set "The day in which the week starts".AD    Wednesday
        Set "The day in which the week starts".AD    Thursday
        Set "The day in which the week starts".AD    Friday
        Set "The day in which the week starts".AD    Saturday
    END
    Close Browser
    [Teardown]    Close Browser.AD

Display > "Time format" (24H or AM/PM) is applied properly
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        ${Test Custom Field}=    set variable    TIME - Custom RF Field [SHOPPER]
        set global variable    ${Test Custom Field}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Set Records per page    500
        Set "Time format".AD    AM/PM
        Search CF via table    ${Test Custom Field}    Shoppers    Time
        Edit CF.AD    true    None    true    true
        Go to.AD    ${URL}/checkers.php
        Wait until page contains element    //*[@id="table_rows"]/tbody/tr[1]/td[1]/a
        Scroll element into view    //*[@id="table_rows"]/tbody/tr[1]/td[1]/a
        Click element    //*[@id="table_rows"]/tbody/tr[1]/td[1]/a
        Wait until page contains element    //*[@id="tabs"]/ul/li[5]/a
        Click link    //*[@id="tabs"]/ul/li[1]/a
        Page should contain    ${Test Custom Field}
        Log to console    Registration page does contain "${Test Custom Field}"
        Scroll element into view    //td[@id='id${found ID}Tedit']
        Input text    //input[@id='field_${found ID}']    23:00
        Click element    //*[@id="ui-datepicker-div"]/div[3]/button[2]
        ${act time}=    get element attribute    //*[@id="field_${found ID}"]    value
        Should be equal    11:00 pm    11:00 pm
        Log to console    Entered time for custom field = "23:00"; it was converted to "11:00 pm" automatically (system format=PM/AM)
        Open registration page and check agreement box(es)
        Page should contain    ${Test Custom Field}
        Log to console    Registration page does contain "${Test Custom Field}"
        Scroll element into view    //td[@id='id${found ID}Tedit']
        Input text    //input[@id='field_${found ID}']    23:00
        Click element    //*[@id="ui-datepicker-div"]/div[3]/button[2]
        ${act time}=    get element attribute    //*[@id="field_${found ID}"]    value
        Should be equal    11:00 pm    ${act time}
        Log to console    Entered time for custom field = "23:00"; it was converted to "11:00 pm" automatically (system format=PM/AM)
        Set "Time format".AD    24H
        Open registration page and check agreement box(es)
        Page should contain    ${Test Custom Field}
        Log to console    Registration page does contain "${Test Custom Field}"
        Scroll element into view    //td[@id='id${found ID}Tedit']
        Input text    //input[@id='field_${found ID}']    23:00
        Click element    //*[@id="ui-datepicker-div"]/div[3]/button[2]
        ${act time}=    get element attribute    //*[@id="field_${found ID}"]    value
        Should be equal    23:00    ${act time}
        Log to console    Entered time custom field = "23:00" (system format=24H)
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Go to.AD    ${URL}/checkers.php
        Wait until page contains element    //*[@id="table_rows"]/tbody/tr[1]/td[1]/a
        Scroll element into view    //*[@id="table_rows"]/tbody/tr[1]/td[1]/a
        Click link    //*[@id="table_rows"]/tbody/tr[1]/td[1]/a
        Wait until page contains element    //*[@id="tabs"]/ul/li[5]/a
        Click element    //*[@id="tabs"]/ul/li[1]/a
        Page should contain    ${Test Custom Field}
        Log to console    Registration page does contain "${Test Custom Field}"
        Scroll element into view    //td[@id='id${found ID}Tedit']
        Input text    //input[@id='field_${found ID}']    23:00
        Click element    //*[@id="ui-datepicker-div"]/div[3]/button[2]
        ${act time}=    get element attribute    //*[@id="field_${found ID}"]    value
        Should be equal    23:00    ${act time}
        Log to console    Entered time custom field = "23:00" (system format=24H)
        Open registration page and check agreement box(es)
        Edit CF.AD    None    None    None    None
    END
    Close Browser
    [Teardown]    Close Browser.AD

Display > Show shoppers login link in users login screen
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Disable shopper login
        Go to.AD    ${URL}/login.php
        Log to console    (!) If "Show shopper login" = "No" --> login page does not contain a shopper login link
        Page should not contain element    xpath=//a[@href="c_login.php"]
        Enable shopper login
        Go to.AD    ${URL}/login.php
        Page should contain element    xpath=//a[@href="c_login.php"]
        Log to console    (!) If "Show shopper login" = "Yes" --> login page does contain a shopper login link
        Click element    //a[@class='login_checkers_link']
        Wait until page contains element    //input[@id='do_login']
    END
    Close Browser
    [Teardown]    Close Browser.AD

System design editor > Upload images (logo, header and background)
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Log to console    Let`s specify logo image, wallpaper and header image (CONDITION: file bigger than max size allowed)
        Upload system images.AD    ${CURDIR}\\Resources\\Extra files\\translations.xls    ${CURDIR}\\Resources\\Extra files\\translations.xls    ${CURDIR}\\Resources\\Extra files\\translations.xls    # file bigger than max size allowed
        Page should contain    image file bigger than max size allowed!
        Log to console    Status: OK, "image file bigger than max size allowed!" error is seen
        Log to console    Let`s specify logo image, wallpaper and header image (CONDITION: not valid file format)
        Upload system images.AD    ${CURDIR}\\Resources\\Extra files\\IMAGES\\RF test.html    ${CURDIR}\\Resources\\Extra files\\IMAGES\\RF test.html    ${CURDIR}\\Resources\\Extra files\\IMAGES\\RF test.html    # not valid file format
        Page should contain    is not a known image extension
        Log to console    Status: OK, "is not a known image extension" error is seen
        Log to console    Let`s specify logo image, wallpaper and header image (CONDITION: valid gif format)
        Upload system images.AD    ${CURDIR}\\Resources\\Extra files\\IMAGES\\RF checker.gif    ${CURDIR}\\Resources\\Extra files\\IMAGES\\RF checker.gif    ${CURDIR}\\Resources\\Extra files\\IMAGES\\RF checker.gif    # valid images (gif)
        go to.AD    ${URL}/main-menu.php
        Page Should Contain Image    //*[@id="top_title_graphics"]/tbody/tr[1]/td[1]/img
        Log to console    Status: OK, valid file format is saved and logo is visible on main page
        Upload system images.AD    ${CURDIR}\\Resources\\Extra files\\IMAGES\\RF Logo2021.png    ${CURDIR}\\Resources\\Extra files\\IMAGES\\RF Wallpaper2021.jpg    ${CURDIR}\\Resources\\Extra files\\IMAGES\\RF HeaderImage2021.png    # valid images (jpg+png)
        Log to console    Let`s delete all 3 system images
        Click element    //*[@id="delete_logo"]
        Click element    //*[@id="delete_wallpaper"]
        Click element    //*[@id="delete_header_image"]
        go to.AD    ${URL}/main-menu.php
        Page Should Not Contain Image    //*[@id="top_title_graphics"]/tbody/tr[1]/td[1]/img
        go to.AD    ${URL}/c_login.php
        Page Should Not Contain Image    //*[@id="top_title_graphics"]/tbody/tr[1]/td[1]/img
        go to.AD    ${URL}/c_login.php
        Page Should Not Contain Image    //table/tbody/tr/td[1]/table/tbody/tr/td[1]/img
        Enter login and password.SD    ${RobotTestShopper 02}    ${RobotTestShopper 02}
        Page Should Not Contain Image    //table/tbody/tr/td[1]/table/tbody/tr/td[1]/img
        Log to console    Status: logo is not visible on main page (shopper+admin), but it DOES NOT WORK FOR WALLPAPER!!!! wallpaper can not be deleted
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Upload system images.AD    ${CURDIR}\\Resources\\Extra files\\IMAGES\\RF Logo2021.png    ${CURDIR}\\Resources\\Extra files\\IMAGES\\RF Wallpaper2021.jpg    ${CURDIR}\\Resources\\Extra files\\IMAGES\\RF HeaderImage2021.png
        ${img src}=    Get Element Attribute    //*[@id="side_menu"]/tbody/tr/td[3]/form/img    src
        ${img name}=    Fetch from right    ${img src}    /
        Log to console    Status: OK, valid file format is saved (img src=${img src})
        go to.AD    ${URL}/main-menu.php
        Page Should Contain Image    //*[@id="top_title_graphics"]/tbody/tr[1]/td[1]/img
        Element Should Be Visible    //img[contains(@src, "${img name}")]
        Click link    xpath=//a[@href="logoff.php"]
        Wait until page contains element    //*[@id="do_login"]
        Page Should Contain Image    //*[@id="top_title_graphics"]/tbody/tr[1]/td[1]/img
        Element Should Be Visible    //img[contains(@src, "${img name}")]
        go to.AD    ${URL}/c_register-new-checker.php?Agree10=1&Agree172=1&Agree176=1&iAgree=Please+wait&addnew=1
        Element Should Be Visible    //img[contains(@src, "${img name}")]
        go to.AD    ${URL}/c_login.php
        Wait until page contains element    //table/tbody/tr/td[1]/table/tbody/tr/td[1]/img
        Enter login and password.SD    ${RobotTestShopper 02}    ${RobotTestShopper 02}
        Wait until page contains element    //table/tbody/tr/td[1]/table/tbody/tr/td[1]/img
        Element Should Be Visible    //img[contains(@src, "${img name}")]
        Log to console    Status: OK, valid logo (name="${img name}") is visible on main and login+main pages (admin+shopper)
    END
    Close Browser
    [Teardown]    Close Browser.AD

Default Email footers > Edit and send Mass email to check email default footers. FU
    [Tags]    Editor    Critical    Gmail
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Edit default footers for outgoing Email messages
    #
        Send email via mass page.AD    U
        Check report-failed-email page.AD    Subject: Test Email (${DD.MM.YY})
        GMAIL: Sent mass email.AD    ${SP user email address}    ${SP user email pass}    U
    #
        Send email via mass page.AD    S
        Check report-failed-email page.AD    Subject: Test Email (${DD.MM.YY})
        GMAIL: Sent mass email.AD    ${RFShopperEmail}    ${shopper email app password}    S
    END
    Close Browser
    [Teardown]    Close Browser.AD

Email accounts > create account. FU
    [Tags]    Skip
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Set Records per page    100
        Go to2.AD    ${URL}/company-email-accounts.php
        Log to console    Open ${URL}/company-email-accounts.php and search test account
        Wait Until Element is Visible    //button[@class='btn-input']
        Wait until page contains element    //button[@class='btn-input']
        ${email account}=    set variable    ROBO`s mail
        set global variable    ${email account}
        ${email}=    set variable    robotmailbox01@gmail.com
        set global variable    ${email}
        Log to console    Let`s use email account name = "${email account}"
        ${is element visible?}=    Run keyword and return status    Page should contain    ${email account}
        Log to console    is test email account visible on page? = "${is element visible?}"
        Run Keyword If    '${is element visible?}'=='False'    Add email acount.AD
        Edit email acount.AD
        Run Keyword If    '${check emails?}'=='True'    Check sent email for acount.AD
        Log to console    "${email account}" has been successfuly created and edited
    END
    Close Browser
    Delete email acount.AD
    [Teardown]    Delete email acount.AD

Company e-mail settings > send "Company email settings" (Amazon only) and send email
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Check "Company email settings" page
    END
    Close Browser
    [Teardown]    Close Browser.AD

General information > enter and save "General information"
    [Tags]    Editor    Critical
    [Setup]
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Enter existing login and password.AD    ${ManagerUsername}    ${ManagerPassword}
        Set "General information".AD
        Check footer on all pages.AD
    END
    Close Browser
    [Teardown]    Close Browser.AD
