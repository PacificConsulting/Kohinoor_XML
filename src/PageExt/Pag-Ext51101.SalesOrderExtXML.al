pageextension 51101 "Sales Order Ext XML" extends "Posted Sales Invoice"
{
    layout

    {

    }
    actions
    {
        addafter("&Invoice")
        {
            action(XMLGenrate)
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    XML: Codeunit 51101;
                    NXML: Codeunit 51102;
                begin
                    XML.XMLCreation();
                    //NXML.XMLCreation();
                end;
            }
        }
    }
}

