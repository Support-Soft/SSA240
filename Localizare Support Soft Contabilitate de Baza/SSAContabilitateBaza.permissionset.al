permissionset 70000 SSAContabilitateBaza
{
    Assignable = true;
    Permissions = tabledata "SSA Adjust Exch. Rate Buffer" = RIMD,
        tabledata "SSA Comment Line" = RIMD,
        tabledata "SSA Localization Setup" = RIMD,
        tabledata "SSA Pstd. Int. Cons. Header" = RIMD,
        tabledata "SSA Report Selections" = RIMD,
        tabledata "SSAInternal Consumption Header" = RIMD,
        tabledata "SSAInternal Consumption Line" = RIMD,
        tabledata "SSAPstd. Int. Consumption Line" = RIMD,
        table "SSA Adjust Exch. Rate Buffer" = X,
        table "SSA Comment Line" = X,
        table "SSA Localization Setup" = X,
        table "SSA Pstd. Int. Cons. Header" = X,
        table "SSA Report Selections" = X,
        table "SSAInternal Consumption Header" = X,
        table "SSAInternal Consumption Line" = X,
        table "SSAPstd. Int. Consumption Line" = X,
        report "SSA Adjust Exchange Rates" = X,
        report "SSA Close Income Statement" = X,
        report "SSA Generare cor 6D 7C" = X,
        report "SSA Get Item Ledger Entries" = X,
        report "SSA NIR Achizitii" = X,
        report "SSA Pstd Int. Cons." = X,
        report "SSAPosted Internal Consumption" = X,
        codeunit "SSA C12 Gen. Jnl.-Post Line" = X,
        codeunit "SSA C22 Item Jnl.-Post Line" = X,
        codeunit "SSA C5802 Inventory Posting" = X,
        codeunit "SSA C900 Assembly-Post" = X,
        codeunit "SSA Charge Assignment" = X,
        codeunit "SSA Correct Documents" = X,
        codeunit "SSA CU80 Sales-Post" = X,
        codeunit "SSA CU90 Purchase-Post" = X,
        codeunit "SSA D394 Subscribers" = X,
        codeunit "SSA Enable Localizare SS" = X,
        codeunit "SSA Fixed Asset Mgt" = X,
        codeunit "SSA General Functions" = X,
        codeunit "SSA General Subscribers" = X,
        codeunit "SSA Global Variables" = X,
        codeunit "SSA IBAN Validator" = X,
        codeunit "SSA Install Localizare SS" = X,
        codeunit "SSA Int. Cons-Post (Yes/No)" = X,
        codeunit "SSA Int. Cons-Post + Print" = X,
        codeunit "SSA Int. Consumption-Printed" = X,
        codeunit "SSA Internal Consumption Post" = X,
        codeunit "SSA Intrastat" = X,
        codeunit "SSA Invoice Post. Buffer Subs" = X,
        codeunit "SSA Item-Check Avail." = X,
        codeunit "SSA Leasing Mgt." = X,
        codeunit "SSA Tables Subscribers" = X,
        codeunit "SSA TransferOrder" = X,
        codeunit "SSA User Setup Management" = X,
        codeunit "SSA VAT Registration No." = X,
        xmlport "SSAExport Intrast Jnl to XML" = X,
        page "SSA Bank Journal" = X,
        page "SSA Closing Page" = X,
        page "SSA Comment List" = X,
        page "SSA Comment Sheet" = X,
        page "SSA Fixed Asset Card" = X,
        page "SSA Fixed Asset Inventory Card" = X,
        page "SSA Fixed Asset Inventory List" = X,
        page "SSA Fixed Asset List" = X,
        page "SSA Internal Consumptions" = X,
        page "SSA Leasing Journal" = X,
        page "SSA Localization Setup" = X,
        page "SSA Posted Int. Consumptions" = X,
        page "SSA Pretty Cash Journal" = X,
        page "SSA Pstd Int. Cons. List" = X,
        page "SSA Report Selection" = X,
        page "SSAInt. Consumption FactBox" = X,
        page "SSAInt. Consumption Subform" = X,
        page "SSAInternal Consumption List" = X,
        page "SSAPstd. Int. Cons. Subform" = X;
}