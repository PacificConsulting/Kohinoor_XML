pageextension 51102 "Gen ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        addafter("Slab Approval Users")
        {
            group("Sony Sales Email Setup")
            {
                field("Sony Sales Email To"; Rec."Sony Sales Email To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sony Sales Email To field.';
                }
                field("Sony Sales Email CC"; Rec."Sony Sales Email CC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sony Sales Email CC field.';
                }
            }
        }
    }
}
