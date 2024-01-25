tableextension 70074 "SSA Invt. Shipment Header" extends "Invt. Shipment Header"
{
    fields
    {
        field(70000; "SSA Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(70001; "SSA Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(70002; "SSA Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
        }
        field(70003; "SSA Sell-to Address"; Text[100])
        {
            Caption = 'Sell-to Address';
        }
        field(70004; "SSA Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2';
        }
        field(70005; "SSA Sell-to City"; Text[30])
        {
            Caption = 'Sell-to City';
        }
        field(70006; "SSA Sell-to Contact"; Text[100])
        {
            Caption = 'Sell-to Contact';
        }
        field(70007; "SSA Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to Post Code';
        }
        field(70008; "SSA Sell-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "SSA Sell-to Country/Reg Code";
            Caption = 'Sell-to County';
        }
        field(70009; "SSA Sell-to Country/Reg Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(70010; "SSA Sell-to Phone No."; Text[30])
        {
            Caption = 'Sell-to Phone No.';
            ExtendedDatatype = PhoneNo;
        }

        field(70011; "SSA Sell-to E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;
        }
        field(70012; "SSA Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.';
            TableRelation = Contact;
        }

        field(70013; "SSA Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("SSA Sell-to Customer No."));
        }
        field(70014; "SSA Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
        }
        field(70015; "SSA Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(70016; "SSA Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
        }
        field(70017; "SSA Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(70018; "SSA Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
        }
        field(70019; "SSA Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
        }
        field(70020; "SSA Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
        }
        field(70021; "SSA Ship-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "SSA Ship-to Country/Reg Code";
            Caption = 'Ship-to County';
        }
        field(70022; "SSA Ship-to Country/Reg Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
    }
}