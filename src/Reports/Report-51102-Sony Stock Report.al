report 51102 "Stock Report Sony"
{
    ApplicationArea = All;
    Caption = 'Stock Report Sony ';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'src/Report Layout/Sony Stock Report.rdl';
    dataset
    {

        dataitem(Item; Item)
        {
            DataItemTableView = where("Category 1" = filter('SONY'));
            column(GlobalDimension1Code_Item; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_Item; "Global Dimension 2 Code")
            {
            }
            column(No_Item; "No.")
            {
            }
            column(Description_Item; Description)
            {
            }
            column(Qty; Qty)
            {

            }
            column(Location; ILE."Location Code")
            {

            }
            column(Site; ILE."Global Dimension 1 Code")
            {

            }
            column(WH; ILE."Global Dimension 1 Code")
            {

            }
            trigger OnPreDataItem()

            begin

                StartDate := CalcDate('<-CM>', Today);
                if StartDate = Today then
                    SetRange("Date Filter", StartDate, StartDate)
                else
                    SetRange("Date Filter", StartDate, CalcDate('-1D', Today));

                // StartDate := 20230630D;
                //Edate := 20230721D;
                SetRange("Date Filter", StartDate, Edate);
                StartDate := Item.GETRANGEMIN(Item."Date Filter");
                EDate := Item.GETRANGEMAX(Item."Date Filter");


            end;

            trigger OnAfterGetRecord()
            begin
                Clear(Qty);
                // Clear(Site);
                // Clear(WareHouse);
                // Clear(Location);
                ILE.Reset();
                ILE.SetRange("Item No.", "No.");
                ILE.SetRange("Posting Date", StartDate, Edate);
                ILE.SetFilter("Remaining Quantity", '<>%1', 0);
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
        Location: Code[20];
        Site: Code[20];
        WareHouse: Code[20];

}
