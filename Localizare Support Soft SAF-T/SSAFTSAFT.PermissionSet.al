permissionset 71900 SSAFTSAFT
{
    Assignable = true;
    Permissions = tabledata "SSAFTSAFT Export Header" = RIMD,
        tabledata "SSAFTSAFT Export Line" = RIMD,
        tabledata "SSAFTSAFT Mapping Range" = RIMD,
        tabledata "SSAFTSAFT Mapping Values" = RIMD,
        tabledata "SSAFTSAFT-NAV Mapping" = RIMD,
        table "SSAFTSAFT Export Header" = X,
        table "SSAFTSAFT Export Line" = X,
        table "SSAFTSAFT Mapping Range" = X,
        table "SSAFTSAFT Mapping Values" = X,
        table "SSAFTSAFT-NAV Mapping" = X,
        report "SSAFTSAFT Copy Mapping" = X,
        codeunit "SSAFTSAFT Export Error Handler" = X,
        codeunit "SSAFTSAFT Export Check" = X,
        codeunit "SSAFTSAFT Export Mgt." = X,
        codeunit "SSAFTSAFT Generate File" = X,
        codeunit "SSAFTSAFT Mapping Helper" = X,
        codeunit "SSAFTSAFT XML Helper" = X,
        page "SSAFTSAFT Export Card" = X,
        page "SSAFTSAFT Export Subpage" = X,
        page "SSAFTSAFT Exports" = X,
        page "SSAFTSAFT Mapping" = X,
        page "SSAFTSAFT Mapping Range" = X,
        page "SSAFTSAFT Mapping Values" = X;
}