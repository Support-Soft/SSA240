tableextension 70008 "SSA G/L Entry70008" extends "G/L Entry"
{
    // SSA973 SSCAT 06.09.2019 39.Rapoarte legale- Localizare Declaratia 394
    // SSA946 SSCAT 26.09.2019 12.Funct. functionalitate DVI la achizitii
    fields
    {
        field(70000; "SSA Tip Partener"; Option)
        {
            Caption = 'Tip Partener';
            DataClassification = CustomerContent;
            Description = 'SSA973';
            OptionCaption = ' ,1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO,2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA,3-Fara CUI valid din UE fara RO,4-Fara CUI valid din afara UE fara RO';
            OptionMembers = " ","1-CUI Valid din RO si din afara inreg. in scopuri de TVA in RO","2-CNP PFA din RO sau CUI neinregistrat in scopuri de TVA","3-Fara CUI valid din UE fara RO","4-Fara CUI valid din afara UE fara RO";
        }
        field(70001; "SSA Cod Judet D394"; Option)
        {
            Caption = 'Cod Judet D394';
            DataClassification = CustomerContent;
            Description = 'SSA973';
            OptionCaption = ' ,1-Alba,2-Arad,3-Arges,4-Bacau,5-Bihor,6-Bistrita-Nasaud,7-Botosani,8-Brasov,9-Braila,10-Buzau,11-Caras-Severin,12-Cluj,13-Constanta,14-Covasna,15-Dambovita,16-Dolj,17-Galati,18-Gorj,19-Harghita,20-Hunedoara,21-Ialomita,22-Iasi,23-Ilfov,24-Maramures,25-Mehedinti,26-Mures,27-Neamt,28-Olt,29-Prahova,30-Satu Mare,31-Salaj,32-Sibiu,33-Suceava,34-Teleorman,35-Timis,36-Tulcea,37-Vaslui,38-Valcea,39-Vrancea,40-Municipiul Bucuresti,,,,,,,,,,,51-Calarasi,52-Giurgiu';
            OptionMembers = " ","1-Alba","2-Arad","3-Arges","4-Bacau","5-Bihor","6-Bistrita-Nasaud","7-Botosani","8-Brasov","9-Braila","10-Buzau","11-Caras-Severin","12-Cluj","13-Constanta","14-Covasna","15-Dambovita","16-Dolj","17-Galati","18-Gorj","19-Harghita","20-Hunedoara","21-Ialomita","22-Iasi","23-Ilfov","24-Maramures","25-Mehedinti","26-Mures","27-Neamt","28-Olt","29-Prahova","30-Satu Mare","31-Salaj","32-Sibiu","33-Suceava","34-Teleorman","35-Timis","36-Tulcea","37-Vaslui","38-Valcea","39-Vrancea","40-Municipiul Bucuresti",,,,,,,,,,,"51-Calarasi","52-Giurgiu";
        }
        field(70002; "SSA Organization type"; Option)
        {
            Caption = 'Organization type';
            DataClassification = CustomerContent;
            Description = 'SSA973';
            OptionCaption = ' ,Private Legal Person,Natural Person,Authorised Natural Person,Public Legal Person';
            OptionMembers = " ","Private Legal Person","Natural Person","Authorised Natural Person","Public Legal Person";
        }
        field(70003; "SSA Custom Invoice No."; Code[20])
        {
            Caption = 'Custom Invoice No.';
            DataClassification = CustomerContent;
            Description = 'SSA946';
        }
    }
}
