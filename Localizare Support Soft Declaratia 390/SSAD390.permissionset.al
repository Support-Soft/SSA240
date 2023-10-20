permissionset 71500 SSAD390
{
    Assignable = true;
    Permissions = tabledata "SSA VIES Header" = RIMD,
        tabledata "SSA VIES Line" = RIMD,
        table "SSA VIES Header" = X,
        table "SSA VIES Line" = X,
        report "SSA Suggest VIES Lines" = X,
        report "SSA VAT- VIES Declaration" = X,
        codeunit "SSA Release VIES Declaration" = X,
        page "SSA VIES Declaration" = X,
        page "SSA VIES Declaration Subform" = X,
        page "SSA VIES Declarations" = X,
        page "SSA VIES Lines" = X;
}