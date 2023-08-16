report 51101 "Sony Sale Report"
{
    ApplicationArea = All;
    Caption = 'Sony Sale Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'src/Report Layout/Sony Sale Report.rdl';
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = where("Category 1" = filter('SONY'));

            dataitem(SalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemLink = "No." = field("No.");
                DataItemTableView = where(Type = filter('Item'));
                column(ShortcutDimension1Code; "Shortcut Dimension 1 Code")
                {
                }
                column(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
                {
                }
                column(StoreNo_SalesInvoiceLine; "Store No.")
                {
                }
                column(PostingDate_SalesInvoiceLine; "Posting Date")
                {
                }
                column(No_SalesInvoiceLine; "No.")
                {
                }
                column(Description_SalesInvoiceLine; Description)
                {
                }
                column(Quantity_SalesInvoiceLine; Quantity)
                {
                }
                column(City; SIH."Sell-to City")
                {
                }
                column(StateName; State.Description)
                {
                }
                column(StoreName; RecLocation.Name)
                {
                }
                column(SalesType; SalesType)
                {

                }
                trigger OnAfterGetRecord()
                begin
                    Clear(SalesType);
                    SalesType := 'Sales Order';
                    IF SIH.get(SalesInvoiceLine."Document No.") then
                        IF State.Get(SIH.State) then;
                    IF RecLocation.Get(SalesInvoiceLine."Store No.") then;
                end;

                trigger OnPreDataItem()
                begin

                    StartDate := CalcDate('<-CM>', Today);

                    if StartDate = Today then
                        SetRange("Posting Date", StartDate, StartDate)
                    else
                        SetRange("Posting Date", StartDate, CalcDate('-1D', Today));

                    // StartDate := 20230803D;
                    // SetRange("Posting Date", StartDate);
                end;
            }
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "No." = field("No.");
                DataItemTableView = where(Type = filter('Item'));
                column(ShortcutDimension1CodeCR; "Shortcut Dimension 1 Code")
                {
                }
                column(ShortcutDimension2CodeCR; "Shortcut Dimension 2 Code")
                {
                }
                column(Store_No_CR; "Store No.")
                {
                }
                column(Posting_Date_CR; "Posting Date")
                {
                }
                column(No_CR; "No.")
                {
                }
                column(Description_CR; Description)
                {
                }
                column(Quantity_CR; Quantity)
                {
                }
                column(CityCR; SIH."Sell-to City")
                {
                }
                column(StateNameCR; State.Description)
                {
                }
                column(StoreNameCR; RecLocation.Name)
                {
                }
                column(SalesTypeCR; SalesType)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    Clear(SalesType);
                    SalesType := 'Returned order';
                    IF SCH.get("Sales Cr.Memo Line"."Document No.") then
                        IF StateCR.Get(SCH.State) then;
                    IF RecLocationCR.Get("Sales Cr.Memo Line"."Store No.") then;
                end;

                trigger OnPreDataItem()
                begin

                    StartDate := CalcDate('<-CM>', Today);
                    if StartDate = Today then
                        SetRange("Posting Date", StartDate, StartDate)
                    else
                        SetRange("Posting Date", StartDate, CalcDate('-1D', Today));


                    // StartDate := 20230803D;
                    // SetRange("Posting Date", StartDate);
                end;
            }
        }
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
        RecLocation: Record 14;
        SIH: Record 112;
        State: Record State;
        SalesType: Text;
        SCH: Record 114;
        RecLocationCR: Record 14;
        StateCR: Record State;
        SalesTypeCR: Text;
        StartDate: Date;
}
