permissionset 71100 "SSA NiceToHave"
{
    Assignable = true;
    Permissions = tabledata "SSA Non-Invoiced Purch. Rcpt." = RIMD,
        tabledata "SSA Non-Invoiced Sales Ship" = RIMD,
        table "SSA Non-Invoiced Purch. Rcpt." = X,
        table "SSA Non-Invoiced Sales Ship" = X,
        report "SSA Inv. Non-Inv Purch. Rcpt." = X,
        report "SSA Inv. Non-Inv Sales Shpt." = X,
        report "SSA Sug. Non-Inv Purch. Rcpt." = X,
        report "SSA Sug. Non-Inv Sales Shpt." = X,
        report "SSA Test BNR" = X,
        codeunit "SSA Actualizare Cursuri BNR" = X,
        codeunit "SSA Interogare TVA Anaf" = X,
        codeunit "SSA VerificareTVA.ro" = X,
        page "SSA Non-Inv Sales Shipment" = X,
        page "SSA Non-Invoiced Purch. Rcpt." = X,
        page "SSA Search Items" = X;
}