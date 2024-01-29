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
                field("Sony Sales Email To2"; Rec."Sony Sales Email To2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sony Sales Email2 To field.';

                }
                field("Sony Sales Email To3"; Rec."Sony Sales Email To3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sony Sales Email3 To field.';

                }
                field("Sony Sales Email To4"; Rec."Sony Sales Email To4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sony Sales Email4 To field.';

                }
                field("Sony Sales Email To5"; Rec."Sony Sales Email To5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sony Sales Email5 To field.';

                }

                field("Sony Sales Email CC"; Rec."Sony Sales Email CC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sony Sales Email CC field.';
                }
                field("Sony Sales Email CC2"; Rec."Sony Sales Email CC2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sony Sales Email2 CC field.';

                }
                field("Sony Sales Email CC3"; Rec."Sony Sales Email CC3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sony Sales Email3 CC field.';

                }
                field("Sony Sales Email CC4"; Rec."Sony Sales Email CC4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sony Sales Email4 CC field.';
                }
                field("Sony Sales Email CC5"; Rec."Sony Sales Email CC5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sony Sales Email5 CC field.';

                }
                field("LG Sales File Date"; Rec."LG Sales File Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the LG Sales extraction date';
                }
            }
        }
    }
}
