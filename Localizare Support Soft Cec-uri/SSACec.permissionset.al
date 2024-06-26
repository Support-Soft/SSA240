permissionset 70500 "SSA Cec"
{
    Assignable = true;
    Permissions = tabledata "SSA Payment Address" = RIMD,
        tabledata "SSA Payment Class" = RIMD,
        tabledata "SSA Payment Header" = RIMD,
        tabledata "SSA Payment Header Archive" = RIMD,
        tabledata "SSA Payment Line" = RIMD,
        tabledata "SSA Payment Line Archive" = RIMD,
        tabledata "SSA Payment Post. Buffer" = RIMD,
        tabledata "SSA Payment Status" = RIMD,
        tabledata "SSA Payment Step" = RIMD,
        tabledata "SSA Payment Step Ledger" = RIMD,
        tabledata "SSA Pmt. Tools AppLedg. Entry" = RIMD,
        table "SSA Payment Address" = X,
        table "SSA Payment Class" = X,
        table "SSA Payment Header" = X,
        table "SSA Payment Header Archive" = X,
        table "SSA Payment Line" = X,
        table "SSA Payment Line Archive" = X,
        table "SSA Payment Post. Buffer" = X,
        table "SSA Payment Status" = X,
        table "SSA Payment Step" = X,
        table "SSA Payment Step Ledger" = X,
        table "SSA Pmt. Tools AppLedg. Entry" = X,
        report "SSA Duplicate parameter" = X,
        report "SSA Payment List" = X,
        report "SSA Suggest Customer Payments" = X,
        report "SSA Suggest Vendor Payments" = X,
        codeunit "SSA CEC Subscribers" = X,
        codeunit "SSA Gen. Jnl.-Post" = X,
        codeunit "SSA Payment Management" = X,
        codeunit "SSA Payment-Apply" = X,
        page "SSA CEC & BO Customer" = X,
        page "SSA CEC & BO Vendor" = X,
        page "SSA Look/Edit Payment Line" = X,
        page "SSA Payment Addresses" = X,
        page "SSA Payment Archive List" = X,
        page "SSA Payment Bank" = X,
        page "SSA Payment Bank Archive" = X,
        page "SSA Payment Class" = X,
        page "SSA Payment Class List" = X,
        page "SSA Payment Header FactBox" = X,
        page "SSA Payment Headers" = X,
        page "SSA Payment Headers Archive" = X,
        page "SSA Payment Line Modification" = X,
        page "SSA Payment Lines" = X,
        page "SSA Payment Lines Archive" = X,
        page "SSA Payment Lines Archive List" = X,
        page "SSA Payment Lines List" = X,
        page "SSA Payment List" = X,
        page "SSA Payment Report" = X,
        page "SSA Payment Status" = X,
        page "SSA Payment Status List" = X,
        page "SSA Payment Step Card" = X,
        page "SSA Payment Step Ledger" = X,
        page "SSA Payment Steps" = X,
        page "SSA Payment Steps List" = X,
        page "SSA Pmt. Tools App-Ledg. Entry" = X;
}