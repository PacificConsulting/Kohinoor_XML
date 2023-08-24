pageextension 51103 "Item Card Ext XML" extends "Item Card"
{
    layout
    {
        addafter("Category 8")
        {

            field("GTM CODE"; Rec."GTM CODE")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GTM CODE field.';
            }
        }
    }
}
