report 51103 "Stock Report Sony1"
{
    ApplicationArea = All;
    Caption = 'Stock Report Sony old';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'src/Report Layout/Sony Stock Report.rdl';
    dataset
    {
        // dataitem(Item; Item)
        // {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            column(GlobalDimension1Code_ItemLedgerEntry; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_ItemLedgerEntry; "Global Dimension 2 Code")
            {
            }
            column(LocationCode_ItemLedgerEntry; "Location Code")
            {
            }
            column(ItemNo_ItemLedgerEntry; "Item No.")
            {
            }
            column(Description_ItemLedgerEntry; Description)
            {
            }
            column(Qty; Qty)
            {

            }

            trigger OnPreDataItem()

            begin
                // StartDate := CalcDate('<-CM>', Today);

                // if StartDate = Today then
                //     SetRange("Posting Date", StartDate, StartDate)
                // else
                //     SetRange("Posting Date", StartDate, CalcDate('-1D', Today));
                StartDate := "Item Ledger Entry".GETRANGEMIN("Item Ledger Entry"."Posting Date");
                EDate := "Item Ledger Entry".GETRANGEMAX("Item Ledger Entry"."Posting Date");


            end;

            trigger OnAfterGetRecord()
            begin
                Clear(Qty);
                ILE.Reset();
                ILE.SetRange("Item No.", "Item No.");
                ILE.SetRange("Posting Date", StartDate, Edate);
                IF ILE.FindSet() then
                    repeat
                        Qty += ILE.Quantity;
                    until ILE.Next() = 0;
            end;
        }
        //}

    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        StartDate: Date;
        Edate: Date;
        Qty: Decimal;
        ILE: Record 32;

}
