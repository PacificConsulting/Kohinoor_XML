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
                column(No_SalesInvoiceLine; Item."No. 2")
                {
                }
                column(Description_SalesInvoiceLine; Item.Description)
                {
                }
                column(Quantity_SalesInvoiceLine; Quantity)
                {
                }
                /* column(City; SIH."Sell-to City")
                {
                }
                column(StateName; State.Description)
                {
                } */
                column(City; RecLocation.City)
                {
                }
                column(StateName; LocState.Description)
                {
                }
                column(StoreName; RecLocation.Name)
                {
                }
                column(SalesType; SalesType)
                {

                }
                trigger OnAfterGetRecord()
                var

                begin
                    Clear(SalesType);
                    SalesType := 'Sales Order';
                    IF SIH.get(SalesInvoiceLine."Document No.") then
                        IF State.Get(SIH.State) then;
                    IF RecLocation.Get(SalesInvoiceLine."Store No.") then
                        if LocState.Get(RecLocation."State Code") then; //pcpl-06429sep2023


                end;

                trigger OnPreDataItem()
                begin
                    /*
                                        StartDate := CalcDate('<-CM>', Today);

                                        if StartDate = Today then
                                            SetRange("Posting Date", StartDate, StartDate)
                                        else
                                            SetRange("Posting Date", StartDate, CalcDate('-1D', Today));

                                        // StartDate := 20230803D;
                                        // SetRange("Posting Date", StartDate);
                                        */

                    TD := TODAY;
                    StartDate := CALCDATE('<-CM>', TD);
                    IF StartDate = TD THEN BEGIN

                        //MESSAGE('TODAY' + FORMAT(TD));
                        StartDate := CALCDATE('-1M', StartDate);
                        //MESSAGE('StartDate' + FORMAT(StartDate));
                        //MESSAGE('EndtDate' + FORMAT(CALCDATE('-1D', TD)));
                        SetRange("Posting Date", StartDate, CALCDATE('-1D', TD))
                    END ELSE BEGIN
                        //MESSAGE('StartDay' + FORMAT(StartDate));
                        SetRange("Posting Date", StartDate, CalcDate('-1D', Today));
                        //MESSAGE('EndDay' + FORMAT(CALCDATE('-1D', TD)));
                    END;

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
                column(No_CR; Item."No. 2")
                {
                }
                column(Description_CR; Item.Description)
                {
                }
                column(Quantity_CR; Quantity)
                {
                }
                /*  column(CityCR; SIH."Sell-to City")
                 {
                 }
                 column(StateNameCR; State.Description)
                 {
                 } */
                column(CityCR; RecLocationCR.City) //pcpl-064 29sep2023
                {
                }
                column(StateNameCR; LocState_1.Description)  //pcpl-064 29sep2023
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
                    // IF RecLocationCR.Get("Sales Cr.Memo Line"."Store No.") then;
                    IF RecLocationCR.Get("Sales Cr.Memo Line"."Store No.") then
                        if LocState_1.Get(RecLocationCR."State Code") then; //pcpl-06429sep2023

                end;

                trigger OnPreDataItem()
                begin
                    /*
                                        StartDate := CalcDate('<-CM>', Today);
                                        if StartDate = Today then
                                            SetRange("Posting Date", StartDate, StartDate)
                                        else
                                            SetRange("Posting Date", StartDate, CalcDate('-1D', Today));


                                        // StartDate := 20230803D;
                                        // SetRange("Posting Date", StartDate);
                                        */
                    TD := TODAY;
                    StartDate := CALCDATE('<-CM>', TD);
                    IF StartDate = TD THEN BEGIN

                        //MESSAGE('TODAY' + FORMAT(TD));
                        StartDate := CALCDATE('-1M', StartDate);
                        //MESSAGE('StartDate' + FORMAT(StartDate));
                        //MESSAGE('EndtDate' + FORMAT(CALCDATE('-1D', TD)));
                        SetRange("Posting Date", StartDate, CALCDATE('-1D', TD))
                    END ELSE BEGIN
                        //MESSAGE('StartDay' + FORMAT(StartDate));
                        SetRange("Posting Date", StartDate, CalcDate('-1D', Today));
                        //MESSAGE('EndDay' + FORMAT(CALCDATE('-1D', TD)));
                    END;
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
        LocState: record State;
        LocState_1: record State;
        TD: Date;
}
