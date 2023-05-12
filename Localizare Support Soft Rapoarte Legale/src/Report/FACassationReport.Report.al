report 71322 "SSA FA Cassation Report"
{
    // SSA1006 SSCAT 14.10.2019 73.Rapoarte legale-Fisa MF
    DefaultLayout = Word;
    //RDLCLayout = './src/rdlc/SSAFixedAssetsCard.rdlc';
    WordLayout = './src/rdlc/SSA FA Cassation Report.docx';
    Caption = 'Fixed Assets Cassation Report';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.", "FA Posting Date Filter";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, '<Day,2>-<Month,2>-<Year4>'))
            {
            }
            column(USERID; UserId)
            {
            }
            column(COMPANYNAME; CompanyInfo.Name)
            {
            }
            column(Fixed_Asset__FA_Class_Code_; "FA Class Code")
            {
            }
            column(Fixed_Asset__FA_Subclass_Code_; "FA Subclass Code")
            {
            }

            column(Fixed_Asset__No__; "No.")
            {
            }
            column(Description____Description_2_; Description + "Description 2")
            {
            }

            column(Fixed_Asset__FA_Location_Code_; "FA Location Code")
            {
            }
            column(Fixed_Asset__FA_Location_Code__Control66; "FA Location Code")
            {
            }

            column(Fixed_Asset__Global_Dimension_1_Code_; "Global Dimension 1 Code")
            {
            }

            column(Fixed_Asset__FA_Subclass_Code__Control78; "FA Subclass Code")
            {
            }

            column(Fixed_Asset__FA_Class_Code_Caption; FieldCaption("FA Class Code"))
            {
            }
            column(Fixed_Asset__FA_Subclass_Code_Caption; FieldCaption("FA Subclass Code"))
            {
            }

            column(Fixed_Asset__No__Caption; FieldCaption("No."))
            {
            }

            column(Fixed_Asset__FA_Location_Code_Caption; FieldCaption("FA Location Code"))
            {
            }
            column(Fixed_Asset_FA_Posting_Date_Filter; "FA Posting Date Filter")
            {
            }
            column(FADepreciationBook_Depreciation; -FADepreciationBook.Depreciation)
            {

            }
            column(CompanyInfo_VATRegistrationNumber; CompanyInfo.GetVATRegistrationNumber())
            {

            }
            dataitem("FA Ledger Entry"; "FA Ledger Entry")
            {
                DataItemLink = "FA No." = FIELD("No."), "Posting Date" = FIELD("FA Posting Date Filter");
                DataItemTableView = SORTING("FA No.", "Depreciation Book Code", "FA Posting Category", "FA Posting Type", "FA Posting Date", "Part of Book Value", "Reclassification Entry")
                    WHERE("FA Posting Category" = const(Disposal));
                RequestFilterFields = "Document No.";

                column(FA_Ledger_Entry__Posting_Date_; Format("Posting Date", 0, '<Day,2>-<Month,2>-<Year4>'))
                {
                }
                column(FA_Ledger_Entry__Document_Type_; "Document Type")
                {
                }
                column(FA_Ledger_Entry__FA_Posting_Type_; "FA Posting Type")
                {
                }
                column(FA_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(FA_Ledger_Entry__Debit_Amount_; "Debit Amount")
                {
                }
                column(FA_Ledger_Entry__Credit_Amount_; "Credit Amount")
                {
                }

                column(FA_Ledger_Entry_Description; Description)
                {
                }

                column(FA_Ledger_Entry__Debit_Amount__Control51; "Debit Amount")
                {
                }
                column(FA_Ledger_Entry__Credit_Amount__Control62; "Credit Amount")
                {
                }

                column(FA_Ledger_Entry__Posting_Date_Caption; FieldCaption("Posting Date"))
                {
                }
                column(FA_Ledger_Entry__Document_No__Caption; FieldCaption("Document No."))
                {
                }
                column(FA_Ledger_Entry__Document_Type_Caption; FieldCaption("Document Type"))
                {
                }
                column(FA_Ledger_Entry__FA_Posting_Type_Caption; FieldCaption("FA Posting Type"))
                {
                }
                column(FA_Ledger_Entry__Debit_Amount_Caption; FieldCaption("Debit Amount"))
                {
                }
                column(FA_Ledger_Entry__Credit_Amount_Caption; FieldCaption("Credit Amount"))
                {
                }
                column(FA_Ledger_Entry_DescriptionCaption; FieldCaption(Description))
                {
                }
                column(FA_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(FA_Ledger_Entry_FA_No_; "FA No.")
                {
                }
                column(Quantity; Quantity)
                {
                    IncludeCaption = true;
                }
                column(User_ID; "User ID")
                {

                }
                column(Amount; -Amount)
                {

                }
                column(Amount__LCY_; "Amount (LCY)")
                {

                }


                trigger OnAfterGetRecord()
                begin

                end;

                trigger OnPostDataItem()
                begin

                end;

                trigger OnPreDataItem()
                begin

                end;
            }
            dataitem(FALedgerEntry_Aquisition; "FA Ledger Entry")
            {
                DataItemLink = "FA No." = FIELD("No."), "Posting Date" = FIELD("FA Posting Date Filter");
                DataItemTableView = SORTING("FA No.", "Depreciation Book Code", "FA Posting Category", "FA Posting Type", "FA Posting Date", "Part of Book Value", "Reclassification Entry")
                    WHERE("FA Posting Type" = const("Acquisition Cost"));
                column(Amount_FALedgerEntry_Aquisition; Amount)
                {

                }
            }
            trigger OnAfterGetRecord()

            begin
                Clear(FADepreciationBook);
                FADepreciationBook.reset;
                FADepreciationBook.SetRange("FA No.", "Fixed Asset"."No.");
                FADepreciationBook.SetRange("Depreciation Book Code", SSASetup."SSA Accounting Depr. Book");
                if FADepreciationBook.FindFirst() then begin
                    FADepreciationBook.SetFilter("FA Posting Date Filter", "Fixed Asset".GetFilter("FA Posting Date Filter"));
                    FADepreciationBook.CalcFields(Depreciation);
                end;

            end;

            trigger OnPreDataItem()
            begin

            end;
        }
    }


    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        SSASetup.Get();
        SSASetup.TestField("SSA Accounting Depr. Book");
        CompanyInfo.Get();
    end;

    var
        FADepreciationBook: Record "FA Depreciation Book";
        SSASetup: Record "SSA Localization Setup";
        CompanyInfo: Record "Company Information";
}

