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
                begin
                    XML.XMLCreation();
                end;
            }
        }
    }
}

