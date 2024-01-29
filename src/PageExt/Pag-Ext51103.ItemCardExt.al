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
    actions
    {
        addafter("Dimensions")
        {
            action(GenerateLGSellOut)
            {
                ApplicationArea = all;
                Promoted = True;
                PromotedIsBig = True;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    cduSellOut: Codeunit 51101;
                begin
                    Clear(cduSellOut);
                    cduSellOut.Run();
                end;

            }
            action(GenerateLGStock)
            {
                ApplicationArea = all;
                Promoted = True;
                PromotedIsBig = True;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    cduStock: Codeunit 51102;
                begin
                    Clear(cdustock);
                    cduStock.Run();
                end;

            }

            action(GenerateLGSellOutDatewise)
            {
                ApplicationArea = all;
                Promoted = True;
                PromotedIsBig = True;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    cduSellOut: Codeunit 51101;
                begin
                    Clear(cduSellOut);
                    cduSellOut.XMLCreationDate();
                end;

            }

        }
    }
}
