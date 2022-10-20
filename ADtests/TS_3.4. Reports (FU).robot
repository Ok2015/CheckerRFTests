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
Reports. Check report page elements
    [Tags]    Report
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        #    Final score report: check elements
        Reports: check if charts are visible    ${URL}/report-property.php    xpath=//li[contains(.,'AUTO 01 [RF CLIENT]')]    //*[@id="PropID"]/option[1]    //*[@id="showClientColorGroup"]/option[1]    None    //*[@id="slo"]/option[2]    #no grouping, default legend, past cycles = none, Show Client Color Group    =none
        Reports: check if charts are visible    ${URL}/report-property.php    xpath=//li[contains(.,'AUTO 01 [RF CLIENT]')]    //*[@id="PropID"]/option[1]    //*[@id="showClientColorGroup"]/option[4]    None    //*[@id="slo"]/option[2]    #no grouping, default legend, past cycles = none, Show Client Color Group= as background
        Reports: check if charts are visible    ${URL}/report-property.php    xpath=//li[contains(.,'AUTO 01 [RF CLIENT]')]    //*[@id="PropID"]/option[1]    //*[@id="showClientColorGroup"]/option[1]    None    //*[@id="slo"]/option[2]    #no grouping, legend under chat, past cycles = none, Show Client Color Group=none
        Reports: check if charts are visible    ${URL}/report-property.php    xpath=//li[contains(.,'AUTO 01 [RF CLIENT]')]    //*[@id="PropID"]/option[6]    //*[@id="showClientColorGroup"]/option[1]    true    //*[@id="slo"]/option[2]    #grouping by survey, legend under chat, past cycles = off, Show Client Color Group=none
        Reports: check if charts are visible    ${URL}/report-property.php    xpath=//li[contains(.,'AUTO 01 [RF CLIENT]')]    //*[@id="PropID"]/option[1]    //*[@id="showClientColorGroup"]/option[1]    true    //*[@id="slo"]/option[4]    #no grouping, legend default, past cycles = on, Show Client Color Group=none
    #    Reports: check if charts are visible    ${URL}/report-property-benchmark.php    xpath=//li[contains(.,'AUTO 01 [RF CLIENT]')]    //*[@id="PropID"]/option[1]    //*[@id="showClientColorGroup"]/option[1]    None    //*[@id="slo"]/option[2]
    #    Reports: check if charts are visible    ${URL}/report-network-status.php    xpath=//li[contains(.,'AUTO 01 [RF CLIENT]')]    //*[@id="PropID"]/option[1]    //*[@id="showClientColorGroup"]/option[1]    None    //*[@id="slo"]/option[2]
    #    Reports: check if charts are visible    ${URL}/report-question-comparison.php    xpath=//li[contains(.,'AUTO 01 [RF CLIENT]')]    //*[@id="PropID"]/option[1]    //*[@id="showClientColorGroup"]/option[1]    None    //*[@id="slo"]/option[2]
    #    Reports: check if charts are visible    ${URL}/report-subchapter-comparison.php    xpath=//li[contains(.,'AUTO 01 [RF CLIENT]')]    //*[@id="PropID"]/option[1]    //*[@id="showClientColorGroup"]/option[1]    None    //*[@id="slo"]/option[2]
    #    Reports: check if charts are visible    ${URL}/report-prop-xref.php    xpath=//li[contains(.,'AUTO 01 [RF CLIENT]')]    //*[@id="PropID"]/option[1]    //*[@id="showClientColorGroup"]/option[1]    None    //*[@id="slo"]/option[2]
    #    Reports: check if charts are visible    ${URL}/report-performance-concentr.php    xpath=//li[contains(.,'AUTO 01 [RF CLIENT]')]    //*[@id="PropID"]/option[1]    //*[@id="showClientColorGroup"]/option[1]    None    //*[@id="slo"]/option[2]
    #    Reports: check if charts are visible    ${URL}/report-results-breakdown.php    xpath=//li[contains(.,'AUTO 01 [RF CLIENT]')]    //*[@id="PropID"]/option[1]    //*[@id="showClientColorGroup"]/option[1]    None    //*[@id="slo"]/option[2]
    #    Reports: check if charts are visible    ${URL}/report-browser.php    xpath=//li[contains(.,'AUTO 01 [RF CLIENT]')]    //*[@id="PropID"]/option[1]    //*[@id="showClientColorGroup"]/option[1]    None    //*[@id="slo"]/option[2]
    #    Reports: check if charts are visible    ${URL}/report-grade-by-question.php    xpath=//li[contains(.,'AUTO 01 [RF CLIENT]')]    //*[@id="PropID"]/option[1]    //*[@id="showClientColorGroup"]/option[1]    None    //*[@id="slo"]/option[2]
    END
    Close Browser
    [Teardown]    Close Browser.AD

Finall score report. Compare report values vs OP
    @{urls}=    String.Split String    ${TestURLs}    ,
    SeleniumLibrary.Open Browser    ${urls[0]}    browser=${BROWSER}
    Run keyword if    "${Max brows win?}"=="YES"    Maximize Browser Window
    FOR    ${URL}    IN    @{urls}
        Set global variable    ${URL}
        SET UP
        Login as a Manager    ${ManagerUsername}    ${ManagerPassword}
        Grab values from OP
        Reports: Final score - table
        Reports: check if charts are visible
    END
    Close Browser
    [Teardown]    Close Browser.AD
