pageextension 70053 "SSA Currencies" extends Currencies  //5
{

    actions
    {
        modify("Adjust Exchange Rate")
        {
            Visible = false;
        }
        addlast("F&unctions")
        {
            action("SSA AdjustExchangeRate")
            {
                Caption = 'Adjust Exchange Rate';
                ApplicationArea = All;
                Image = AdjustExchangeRates;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = report "SSA Adjust Exchange Rates";
                ToolTip = 'Executes the Adjust Exchange Rate action.';
            }
        }
    }
}