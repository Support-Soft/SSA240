permissionset 72000 SSAEDElectronicDoc
{
    Assignable = true;
    Permissions = tabledata "SSAEDE-Documents Details" = RIMD,
        tabledata "SSAEDE-Documents Log Entry" = RIMD,
        tabledata "SSAEDEDocuments Setup" = RIMD,
        table "SSAEDE-Documents Details" = X,
        table "SSAEDE-Documents Log Entry" = X,
        table "SSAEDEDocuments Setup" = X,
        codeunit "SSAEDANAF API Mgt" = X,
        codeunit "SSAEDEFactura Mgt." = X,
        codeunit "SSAEDETransport Mgt." = X,
        codeunit "SSAEDExport EFactura" = X,
        codeunit "SSAEDExport ETransport" = X,
        codeunit "SSAEDJob EFactura Email" = X,
        codeunit "SSAEDJob EFactura StareMesaj" = X,
        codeunit "SSAEDProcess Import E-Doc" = X,
        xmlport "SSAEDE-Factura" = X,
        xmlport "SSAEDE-Transport" = X,
        page "SSAEDE-Documents Details List" = X,
        page "SSAEDE-Documents Log Entries" = X,
        page "SSAEDEDocuments Setup" = X,
        codeunit "SSAEDJob Export E-Documents" = X,
        codeunit "SSAEDJob GetListaMesaje" = X,
        codeunit "SSAEDJob Import E-Documents" = X;
}