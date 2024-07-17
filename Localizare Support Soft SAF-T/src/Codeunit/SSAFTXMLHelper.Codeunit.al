codeunit 71904 "SSAFT XML Helper"
{
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        CurrRecRef: RecordRef;
        XMLDoc: XmlDocument;
        CurrXMLElement: array[100] of XmlElement;
        SavedXMLElement: XmlElement;
        Depth: Integer;
        AdditionalParams: Dictionary of [Text, Text];
        XPathParent: Text;
        UTF8BOMSymbols: Text;
        NamespaceUri: Text;
        DataHandlInterfaceInitialized: Boolean;
        AddPrevSiblingsAllowed: Boolean;
        AddNextSiblingsAllowed: Boolean;
        AddChildNodesAllowed: Boolean;
        SetNameValueAllowed: Boolean;
        RemoveNodeAllowed: Boolean;
        NotPossibleToInsertErr: label 'Not possible to insert element %1', Comment = '%1 - node text';
        XmlFileNameSAFTTxt: label 'SAF-T Financial_%1_%2_%3_%4.xml', Comment = '%1 - VAT Reg No., %2 - file create datetime, %3 - number of file, %4 - total number of files', Locked = true;

    procedure Initialize()
    begin
        Clear(XMLDoc);
        Clear(CurrXMLElement);
        Depth := 0;

        NamespaceUri := 'mfp:anaf:dgti:d406:declaratie:v1';
        CreateRootWithNamespace('AuditFile');
    end;

    procedure SetCurrentRec(RecVariant: Variant)
    begin
        if RecVariant.IsRecordRef then
            CurrRecRef := RecVariant
        else
            if RecVariant.IsRecord then
                CurrRecRef.GetTable(RecVariant)
            else
                Error('RecVariant must be Record or RecordRef');
    end;

    procedure CreateRootWithNamespace(RootNodeName: Text)
    begin
        /*
        XMLDOMManagement.AddRootElementWithPrefix(XMLDoc, RootNodeName, NamespaceShortName, NamespaceFullName, RootXMLNode);
        XMLDOMManagement.AddAttribute(RootXMLNode, 'xmlns:' + NamespaceShortName, NamespaceFullName);
        XMLDOMManagement.AddAttribute(RootXMLNode, 'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
        //XMLDOMManagement.AddAttribute(RootXMLNode,'xsi:schemaLocation','mfp:anaf:dgti:d406t:declaratie:v1 Romanian_SAF-T_Financial_Schema_v_2.4.5.xsd');
        //xsi:schemaLocation="mfp:anaf:dgti:d406t:declaratie:v1 Romanian_SAF-T_Financial_Schema_v_2_4_6_09032022.xsd"

        XMLDOMManagement.AddDeclaration(XMLDoc, '1.0', 'UTF-8', '');
        XMLNamespaceManager := XMLNamespaceManager.XmlNamespaceManager(RootXMLNode.OwnerDocument.NameTable);
        XMLNamespaceManager.AddNamespace(NamespaceShortName, NamespaceFullName);
        CurrentXMLNode := RootXMLNode;
        */

        Depth += 1;
        CurrXMLElement[Depth] := XmlElement.Create(RootNodeName, NamespaceUri);
        AddElementNameToXPath(RootNodeName);
        CurrXMLElement[Depth].Add(XmlAttribute.CreateNamespaceDeclaration('nsSAFT', NamespaceUri));
        CurrXMLElement[Depth].Add(XmlAttribute.CreateNamespaceDeclaration('xsi', 'http://www.w3.org/2001/XMLSchema-instance'));
        XMLDoc.Add(CurrXMLElement[Depth]);
        XMLDoc.GetRoot(CurrXMLElement[Depth]);
    end;

    procedure AddNewXmlNode(NodeName: Text; NodeText: Text)
    var
        NewXMLElement: XmlElement;
    begin

        AddXmlElement(NewXMLElement, NodeName, NodeText);
        Depth += 1;
        CurrXMLElement[Depth] := NewXMLElement;
        AddElementNameToXPath(NodeName);
    end;

    procedure AppendXmlNode(NodeName: Text; NodeText: Text)
    var
        NewXMLElement: XmlElement;
        XPath: Text;
        EmptyContentAllowed: Boolean;
        RemoveCurrElement: Boolean;
    begin
        XPath := XPathParent + '/' + NodeName;

        if NodeText <> '' then
            AddXmlElement(NewXMLElement, NodeName, NodeText)
        else
            if EmptyContentAllowed then
                AddXmlElement(NewXMLElement, NodeName, NodeText);
    end;

    procedure AppendXmlNodeEmptyContentAllowed(NodeName: Text; NodeText: Text)
    var
        NewXMLElement: XmlElement;
    begin
        AddXmlElement(NewXMLElement, NodeName, NodeText);
    end;

    procedure AppendXmlNodeIfNotZero(NodeName: Text; NodeValue: Decimal)
    var
        NewXMLElement: XmlElement;
        NodeText: Text;
    begin
        if NodeValue = 0 then
            exit;
        NodeText := Format(NodeValue, 0, 9);
        AddXmlElement(NewXMLElement, NodeName, NodeText);
    end;

    procedure AppendToSavedXmlNode(NodeName: Text; NodeText: Text)
    var
        NewXMLElement: XmlElement;
    begin
        ClearUTF8BOMSymbols(NodeText);
        if NodeText = '' then
            exit;
        NewXMLElement := XmlElement.Create(NodeName, NamespaceUri, NodeText);
        if (not SavedXMLElement.AddFirst(NewXMLElement)) then
            Error(NotPossibleToInsertErr, NodeText);
    end;

    procedure SaveCurrXmlElement()
    begin
        SavedXMLElement := CurrXMLElement[Depth];
    end;

    procedure FinalizeXmlNode()
    begin
        Depth -= 1;
        RemoveLastElementNameFromXPath();
        if Depth < 0 then
            Error('Incorrect XML structure');
    end;

    local procedure AddXmlElement(var NewXMLElement: XmlElement; Name: Text; NodeText: Text)
    begin
        ClearUTF8BOMSymbols(NodeText);
        NewXMLElement := XmlElement.Create(Name, NamespaceUri, NodeText);
        if not CurrXMLElement[Depth].Add(NewXMLElement) then
            Error(NotPossibleToInsertErr, NodeText);
    end;

    procedure WriteXmlDocToAuditLine(var SAFTExportLine: Record "SSAFT Export Line")
    var
        FileOutStream: OutStream;
    begin
        SAFTExportLine."SAF-T File".CreateOutStream(FileOutStream, TextEncoding::UTF8);
        XmlDoc.WriteTo(FileOutStream);
    end;

    procedure WriteXmlDocToAuditHeader(var SAFTExportHeader: Record "SSAFT Export Header")
    var
        FileOutStream: OutStream;
    begin
        SAFTExportHeader."SAF-T File".CreateOutStream(FileOutStream, TextEncoding::UTF8);
        XmlDoc.WriteTo(FileOutStream);
    end;

    procedure WriteXmlDocToTempBlob(var TempBlob: Codeunit "Temp Blob")
    var
        BlobOutStream: OutStream;
    begin
        TempBlob.CreateOutStream(BlobOutStream);
        XMLDoc.WriteTo(BlobOutStream);
    end;

    procedure GetFilePath(ServerDestinationFolder: Text; VATRegistrationNo: Text[20]; CreatedDateTime: DateTime; NumberOfFile: Integer; TotalNumberOfFiles: Integer): Text;
    var
        FileName: Text;
    begin
        FileName := StrSubstNo(XmlFileNameSAFTTxt, VATRegistrationNo, DateTimeOfFileCreation(CreatedDateTime), NumberOfFile, TotalNumberOfFiles);
        exit(ServerDestinationFolder + '\' + FileName);
    end;

    local procedure DateTimeOfFileCreation(CreatedDateTime: DateTime): Text
    begin
        exit(Format(CreatedDateTime, 0, '<Year4><Month,2><Day,2><Hours24><Minutes,2><Seconds,2>'));
    end;

    local procedure ClearUTF8BOMSymbols(var RawXmlText: Text)
    begin
        if StrPos(RawXmlText, UTF8BOMSymbols) = 1 then
            RawXmlText := DelStr(RawXmlText, 1, StrLen(UTF8BOMSymbols));
    end;

    procedure GetXmlEscapeCharsAdditionalLength(NodeText: Text) AdditionalLength: Integer
    var
        currChar: Char;
        i: Integer;
    begin
        // xml escape chars < > & are replaced with &lt; &gt; &amp; which are 3 or 4 chars longer
        AdditionalLength := 0;
        for i := 1 to StrLen(NodeText) do begin
            currChar := NodeText[i];
            case currChar of
                '<', '>':
                    AdditionalLength += 3;
                '&':
                    AdditionalLength += 4;
            end;
        end;
    end;

    local procedure AddElementNameToXPath(ElementName: Text)
    begin
        XPathParent += ('/' + ElementName);
    end;

    local procedure RemoveLastElementNameFromXPath()
    begin
        XPathParent := XPathParent.Substring(1, XPathParent.LastIndexOf('/') - 1);
    end;
}