permissionset 71900 SSAFT
{
    Assignable = true;
    Permissions = tabledata "SSAFT Export Header" = RIMD,
        tabledata "SSAFT Export Line" = RIMD,
        tabledata "SSAFT Mapping Range" = RIMD,
        tabledata "SSAFT Mapping Values" = RIMD,
        tabledata "SSAFT-NAV Mapping" = RIMD,
        table "SSAFT Export Header" = X,
        table "SSAFT Export Line" = X,
        table "SSAFT Mapping Range" = X,
        table "SSAFT Mapping Values" = X,
        table "SSAFT-NAV Mapping" = X,
        report "SSAFT Copy Mapping" = X,
        codeunit "SSAFT Export Error Handler" = X,
        codeunit "SSAFT Export Check" = X,
        codeunit "SSAFT Export Mgt." = X,
        codeunit "SSAFT Generate File" = X,
        codeunit "SSAFT Mapping Helper" = X,
        codeunit "SSAFT XML Helper" = X,
        page "SSAFT Export Card" = X,
        page "SSAFT Export Subpage" = X,
        page "SSAFT Exports" = X,
        page "SSAFT Mapping" = X,
        page "SSAFT Mapping Range" = X,
        page "SSAFT Mapping Values" = X;
}