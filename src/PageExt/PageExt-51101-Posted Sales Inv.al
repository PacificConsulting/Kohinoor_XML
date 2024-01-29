pageextension 51101 "Sales Order Ext XML" extends "Posted Sales Invoice"
{
    layout

    {

    }
    actions
    {
        addafter("&Invoice")
        {
            action(XMLGenerateStock)
            {
                ApplicationArea = all;
                //Visible = false;
                trigger OnAction()
                var
                    XML: Codeunit 51101;
                    NXML: Codeunit 51102;
                begin
                    // XML.XMLCreation();
                    //XML.XMLCreation();
                    NXML.Run();

                end;
            }
            action(XMLGenerateSell)
            {
                ApplicationArea = all;
                //Visible = false;
                trigger OnAction()
                var
                    XML: Codeunit 51101;
                    NXML: Codeunit 51102;
                begin
                    // XML.XMLCreation();
                    //XML.XMLCreation();
                    XML.Run();

                end;
            }
        }
    }
}

