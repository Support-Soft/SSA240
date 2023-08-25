codeunit 71904 "SSAFTSAFT XML Helper"
{
    // SSM2101 SSCAT 04.01.2023 SAF-T


    trigger OnRun()
    begin
    end;

    var
        SAFTNameSpaceTxt: Label 'mfp:anaf:dgti:d406:declaratie:v1', Locked = true;
        SAFTShortNameSpaceTxt: Label 'nsSAFT', Locked = true;
        NoFileGeneratedErr: Label 'No file generated.';
        XMLDOMManagement: Codeunit "XML DOM Management";
        NamespaceFullName: Text;
        NamespaceShortName: Text;
        XMLDoc: XmlDocument;
        CurrXMLElement: array[100] of XmlElement;


    procedure Initialize()
    begin
        Clear(XMLDoc);
        Clear(RootXMLNode);
        Clear(CurrentXMLNode);
        XMLDoc := XMLDoc.XmlDocument;
        SetNamespace(SAFTNameSpaceTxt, SAFTShortNameSpaceTxt);
        CreateRootWithNamespace('AuditFile');
    end;


    procedure SetNamespace(NewNamespace: Text; NewNamespaceShortName: Text)
    begin
        NamespaceFullName := NewNamespace;
        NamespaceShortName := NewNamespaceShortName;
    end;


    procedure CreateRootWithNamespace(RootNodeName: Text)
    begin
        XMLDOMManagement.AddRootElementWithPrefix(XMLDoc, RootNodeName, NamespaceShortName, NamespaceFullName, RootXMLNode);

        //debug
        /*
        XMLDOMManagement.AddAttribute(RootXMLNode,'xmlns:' + NamespaceShortName,NamespaceFullName);
        XMLDOMManagement.AddAttribute(RootXMLNode,'xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
        XMLDOMManagement.AddAttribute(RootXMLNode,'xsi:schemaLocation','mfp:anaf:dgti:d406t:declaratie:v1 Romanian_SAF-T_Financial_Schema_v_2.4.5.xsd');
        */
        //
        XMLDOMManagement.AddAttribute(RootXMLNode, 'xmlns:' + NamespaceShortName, NamespaceFullName);
        XMLDOMManagement.AddAttribute(RootXMLNode, 'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
        //XMLDOMManagement.AddAttribute(RootXMLNode,'xsi:schemaLocation','mfp:anaf:dgti:d406t:declaratie:v1 Romanian_SAF-T_Financial_Schema_v_2.4.5.xsd');
        //xsi:schemaLocation="mfp:anaf:dgti:d406t:declaratie:v1 Romanian_SAF-T_Financial_Schema_v_2_4_6_09032022.xsd"

        XMLDOMManagement.AddDeclaration(XMLDoc, '1.0', 'UTF-8', '');
        XMLNamespaceManager := XMLNamespaceManager.XmlNamespaceManager(RootXMLNode.OwnerDocument.NameTable);
        XMLNamespaceManager.AddNamespace(NamespaceShortName, NamespaceFullName);
        CurrentXMLNode := RootXMLNode;

    end;


    procedure AddNewXMLNode(Name: Text; NodeText: Text)
    begin
        InsertXMLNode(CurrentXMLNode, CurrentXMLNode, Name, NodeText);
    end;


    procedure AppendXMLNode(Name: Text; NodeText: Text)
    var
        NewXMLNode: DotNet SSAXmlNode;
    begin
        if NodeText = '' then
            exit;
        InsertXMLNode(CurrentXMLNode, NewXMLNode, Name, NodeText);
    end;


    procedure FinalizeXMLNode()
    begin
        XMLDOMManagement.FindNode(CurrentXMLNode, '..', CurrentXMLNode);
    end;

    local procedure InsertXMLNode(var XMLNode: DotNet SSAXmlNode; var CreatedXMLNode: DotNet SSAXmlNode; Name: Text; NodeText: Text)
    begin
        if XMLDOMManagement.AddElementWithPrefix(XMLNode, Name, NodeText, NamespaceShortName, NamespaceFullName, CreatedXMLNode) <> 0 then
            Error(StrSubstNo('Not possible to insert element %1', NodeText));
    end;


    procedure ExportXMLDocument(var SAFTExportLine: Record "SSAFTSAFT Export Line"; SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        SAFTExportMgt: Codeunit "SSAFTSAFT Export Mgt.";
        FileOutStream: OutStream;
    begin
        if not SAFTExportMgt.SaveXMLDocToFolder(SAFTExportHeader, XMLDoc, SAFTExportLine."Line No.") then begin
            SAFTExportLine."SAF-T File".CreateOutStream(FileOutStream);
            XmlDoc.WriteTo(FileOutStream);
        end;
    end;


    procedure ExportSAFTExportLineBlobToFile(SAFTExportLine: Record "SSAFTSAFT Export Line"; FilePath: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
    begin
        SAFTExportLine.CalcFields("SAF-T File");
        if not SAFTExportLine."SAF-T File".HasValue then
            Error(NoFileGeneratedErr);
        TempBlob.FromRecord(SAFTExportLine, SAFTExportLine.FieldNo("SAF-T File"));
        FileManagement.BLOBExportToServerFile(TempBlob, FilePath);
    end;


    procedure GetFilePath(ServerDestinationFolder: Text; VATRegistrationNo: Text[20]; CreatedDateTime: DateTime; NumberOfFile: Integer; TotalNumberOfFiles: Integer): Text
    var
        FileName: Text;
    begin
        FileName :=
          StrSubstNo(
            'SAF-T Financial_%1_%2_%3_%4.xml', VATRegistrationNo,
            DateTimeOfFileCreation(CreatedDateTime), NumberOfFile, TotalNumberOfFiles);
        exit(ServerDestinationFolder + '\' + FileName);
    end;

    local procedure DateTimeOfFileCreation(CreatedDateTime: DateTime): Text
    begin
        exit(Format(CreatedDateTime, 0, '<Year4><Month,2><Day,2><Hours24><Minutes,2><Seconds,2>'));
    end;


    procedure ExportXMLSingleDocument(SAFTExportHeader: Record "SSAFTSAFT Export Header")
    var
        SAFTExportMgt: Codeunit "SSAFTSAFT Export Mgt.";
        FileOutStream: OutStream;
    begin
        //SSM1724>>
        if not SAFTExportMgt.SaveSingleXMLDocToFolder(SAFTExportHeader, XMLDoc) then begin
            SAFTExportHeader."SAF-T File".CreateOutStream(FileOutStream);
            XMLDOMManagement. .SaveXMLDocumentToOutStream(FileOutStream, RootXMLNode);
        end;
        //SSM1724<<
    end;


    procedure GetSingleFilePath(ServerDestinationFolder: Text; VATRegistrationNo: Text[20]): Text
    var
        FileName: Text;
    begin
        //SSM1724>>
        FileName :=
          StrSubstNo(
            'SAF-T Financial_%1_%2.xml', VATRegistrationNo,
            DateTimeOfFileCreation(CurrentDateTime));
        exit(ServerDestinationFolder + '\' + FileName);
        //SSM1724<<
    end;
}

