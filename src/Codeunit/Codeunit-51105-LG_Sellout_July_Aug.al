codeunit 51105 "Sell Out Qty_July_Aug"
{
    trigger OnRun()
    begin
        XMLCreation();
    end;

    procedure XMLCreation(/*SIH: Record 112*/)
    var
        XMLDoc: XmlDocument;
        XMLDecl: XmlDeclaration;
        RootNode: XmlElement;
        ParentNood: XmlElement;
        SalesInvLine: Record 113;
        ChildNood: XmlElement;
        FieldCap: Text;
        XMLTxt: XmlText;
        SalInvHdr: Record 112;
        SalesCrHdr: Record 114;
        TB: Codeunit "Temp Blob";
        Ostr: OutStream;
        Istr: InStream;
        ReadTXT: Text;
        WriteTxt: Text;
        VL: Record "Value Entry";
        ILE: Record 32;
        TotalAmount: Decimal;
        CalcSta: Codeunit "Calculate Statistics";
        RecItem: Record 27;
        ABSBlobClient: Codeunit "ABS Blob Client";
        Authorization: Interface "Storage Service Authorization";
        ABSCSetup: Record "Azure Storage Container Setup";
        StorageServiceAuth: Codeunit "Storage Service Authorization";
        FileName: Text;
        response: Codeunit "ABS Operation Response";
        RecLocation: Record 14;

        SalesCrmemoLine: Record 115;
    begin

        XMLDoc := XmlDocument.Create();
        RootNode := XmlElement.Create('SO');
        XMLDoc.Add(RootNode);

        RecItem.Reset();
        RecItem.SetRange("Category 1", 'LG');
        //RecItem.SetRange("No.", 'KTVGIF00016');
        IF RecItem.FindSet() then
            repeat
                // SalesInvLine.Reset();
                // SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
                // //SalesInvLine.SetFilter("Document No.", '%1|%2', 'VASTI23241100478', 'VASTI23241100477');
                // SalesInvLine.SetRange("Posting Date", CalcDate('-1D', Today));
                // SalesInvLine.SetRange("No.", RecItem."No.");
                // IF SalesInvLine.FindSet() then
                //repeat
                VL.Reset();
                VL.SetRange("Item Ledger Entry Type", VL."Item Ledger Entry Type"::Sale);
                VL.SetFilter("Document Type", '%1|%2', VL."Document Type"::"Sales Invoice", VL."Document Type"::"Sales Credit Memo");

                //VL.SetRange("Item No.", SalesInvLine."No.");
                //VL.SetRange("Document Type", VL."Document Type"::"Sales Invoice");
                //VL.SetRange("Posting Date", CalcDate('-1D', Today));
                VL.SetRange("Posting Date", 20230909D);//, 20230903D);  //Date change as per requirement
                VL.SetRange("Item No.", RecItem."No.");
                if VL.FindFirst() then
                    repeat
                        ILE.Reset();
                        ILE.SetRange("Entry No.", VL."Item Ledger Entry No.");
                        if ILE.FindFirst() then;
                        // serialno := ILE."Serial No.";
                        Clear(TotalAmount);
                        SalInvHdr.Reset();
                        SalInvHdr.SetRange("No.", VL."Document No.");
                        IF SalInvHdr.FindFirst() then;
                        // for Unit price
                        SalesInvLine.Reset();
                        SalesInvLine.SetRange("Document No.", VL."Document No.");
                        SalesInvLine.SetRange("Line No.", VL."Document Line No.");
                        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
                        if SalesInvLine.FindFirst() then
                            TotalAmount := SalesInvLine."Unit Price Incl. of Tax"
                        else begin
                            SalesCrmemoLine.Reset();
                            SalesCrmemoLine.SetRange("Document No.", VL."Document No.");
                            SalesCrmemoLine.SetRange("Line No.", VL."Document Line No.");
                            SalesCrmemoLine.SetRange(Type, SalesCrmemoLine.Type::Item);
                            if SalesCrmemoLine.FindFirst() then
                                TotalAmount := SalesCrmemoLine."Unit Price Incl. of Tax";
                        end;


                        SalesCrHdr.Reset();
                        SalesCrHdr.SetRange("No.", VL."Document No.");
                        if SalesCrHdr.FindFirst() then;

                        //Clear(TotalAmount);
                        //CalcSta.GetPostedSalesInvStatisticsAmount(SalInvHdr, TotalAmount);

                        ParentNood := XmlElement.Create('SO_REC');
                        RootNode.Add(ParentNood);
                        if VL."Document Type" = vl."Document Type"::"Sales Invoice" then begin
                            ChildNood := XmlElement.Create('BATCH_NO');
                            XMLTxt := XmlText.Create(Format(SalInvHdr."Posting Date", 0, '<Year4><month,2><Day,2>'));
                            ChildNood.Add(XMLTxt);
                            ParentNood.Add(ChildNood);
                        end else begin
                            ChildNood := XmlElement.Create('BATCH_NO');
                            XMLTxt := XmlText.Create(Format(SalesCrHdr."Posting Date", 0, '<Year4><month,2><Day,2>'));
                            ChildNood.Add(XMLTxt);
                            ParentNood.Add(ChildNood);
                        end;

                        ChildNood := XmlElement.Create('MT_CUST');
                        XMLTxt := XmlText.Create('KTVP');
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        if VL."Document Type" = vl."Document Type"::"Sales Invoice" then begin
                            ChildNood := XmlElement.Create('SELLOUT_DATE');
                            XMLTxt := XmlText.Create(Format(SalInvHdr."Posting Date", 0, '<Year4><month,2><Day,2>'));
                            ChildNood.Add(XMLTxt);
                            ParentNood.Add(ChildNood);

                            ChildNood := XmlElement.Create('SITECODE');
                            if SalInvHdr."Shortcut Dimension 1 Code" = 'NAVI MUMBAI' then
                                XMLTxt := XmlText.Create('NAV MUM')
                            else
                                XMLTxt := XmlText.Create(Format(SalInvHdr."Shortcut Dimension 1 Code"));
                            ChildNood.Add(XMLTxt);
                            ParentNood.Add(ChildNood);
                        end else
                            if VL."Document Type" = vl."Document Type"::"Sales Credit Memo" then begin
                                ChildNood := XmlElement.Create('SELLOUT_DATE');
                                XMLTxt := XmlText.Create(Format(SalesCrHdr."Posting Date", 0, '<Year4><month,2><Day,2>'));
                                ChildNood.Add(XMLTxt);
                                ParentNood.Add(ChildNood);

                                ChildNood := XmlElement.Create('SITECODE');
                                if SalesCrHdr."Shortcut Dimension 1 Code" = 'NAVI MUMBAI' then
                                    XMLTxt := XmlText.Create('NAV MUM')
                                else
                                    XMLTxt := XmlText.Create(Format(SalesCrHdr."Shortcut Dimension 1 Code"));
                                ChildNood.Add(XMLTxt);
                                ParentNood.Add(ChildNood);
                            end;

                        IF RecLocation.get(SalInvHdr."Store No.") then; //begin
                        IF RecLocation.Store = true then begin
                            ChildNood := XmlElement.Create('SITECODE_TYPE');
                            XMLTxt := XmlText.Create(Format(RecLocation.Code)); //
                            ChildNood.Add(XMLTxt);
                            ParentNood.Add(ChildNood);
                        end else begin
                            ChildNood := XmlElement.Create('SITECODE_TYPE');
                            XMLTxt := XmlText.Create(Format('DC')); //
                            ChildNood.Add(XMLTxt);
                            ParentNood.Add(ChildNood);
                        end;
                        // end;

                        if VL."Document Type" = vl."Document Type"::"Sales Invoice" then begin
                            ChildNood := XmlElement.Create('SITECODE_INFO');
                            XMLTxt := XmlText.Create(Format(SalInvHdr."Shortcut Dimension 2 Code"));
                            ChildNood.Add(XMLTxt);
                            ParentNood.Add(ChildNood);
                        end else begin
                            ChildNood := XmlElement.Create('SITECODE_INFO');
                            XMLTxt := XmlText.Create(Format(SalesCrHdr."Shortcut Dimension 2 Code"));
                            ChildNood.Add(XMLTxt);
                            ParentNood.Add(ChildNood);
                        end;
                        ChildNood := XmlElement.Create('ITEMCODE');
                        XMLTxt := XmlText.Create(Format(RecItem."No. 2"));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('EAN');
                        XMLTxt := XmlText.Create(Format(RecItem."EAN Code"));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('ITEMDESC');
                        XMLTxt := XmlText.Create(Format(RecItem.Description));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('LG_MODEL');
                        XMLTxt := XmlText.Create(Format(RecItem."No. 2"));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('FAMILYNAME');
                        XMLTxt := XmlText.Create(Format(RecItem."Category 1"));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('REGULARITY');
                        XMLTxt := XmlText.Create(Format('Daily'));// blank 
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        if VL."Document Type" = vl."Document Type"::"Sales Invoice" then begin
                            ChildNood := XmlElement.Create('INVOICE_NO');
                            XMLTxt := XmlText.Create(Format(SalInvHdr."No."));
                            ChildNood.Add(XMLTxt);
                            ParentNood.Add(ChildNood);

                            ChildNood := XmlElement.Create('CUSTOMER_NAME');
                            XMLTxt := XmlText.Create(Format(SalInvHdr."Sell-to Customer Name"));
                            ChildNood.Add(XMLTxt);
                            ParentNood.Add(ChildNood);
                        end else begin
                            ChildNood := XmlElement.Create('INVOICE_NO');
                            XMLTxt := XmlText.Create(Format(SalesCrHdr."No."));
                            ChildNood.Add(XMLTxt);
                            ParentNood.Add(ChildNood);

                            ChildNood := XmlElement.Create('CUSTOMER_NAME');
                            XMLTxt := XmlText.Create(Format(SalesCrHdr."Sell-to Customer Name"));
                            ChildNood.Add(XMLTxt);
                            ParentNood.Add(ChildNood);
                        end;


                        ChildNood := XmlElement.Create('GTM_CODE');
                        XMLTxt := XmlText.Create(Format(RecLocation."GTM CODE"));//New Fields Create on Location 
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('INVOICE_AMOUNT');
                        XMLTxt := XmlText.Create(Format(TotalAmount));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('SELLOUT_QTY');
                        XMLTxt := XmlText.Create(Format(ABS(VL."Invoiced Quantity")));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);
                        if VL."Document Type" = vl."Document Type"::"Sales Invoice" then begin
                            ChildNood := XmlElement.Create('SELLOUT_TYPE');
                            XMLTxt := XmlText.Create(Format('Sales Order'));
                            ChildNood.Add(XMLTxt);
                            ParentNood.Add(ChildNood);
                        end else begin
                            ChildNood := XmlElement.Create('SELLOUT_TYPE');
                            XMLTxt := XmlText.Create(Format('Sales Return Order'));
                            ChildNood.Add(XMLTxt);
                            ParentNood.Add(ChildNood);
                        end;
                        ChildNood := XmlElement.Create('SERIALNO');
                        XMLTxt := XmlText.Create(Format(ILE."Serial No."));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                    until VL.Next() = 0;
            until RecItem.next() = 0;
        TB.CreateInStream(Istr);
        TB.CreateOutStream(Ostr);
        XMLDoc.WriteTo(Ostr);
        Ostr.WriteText(WriteTxt);
        Istr.ReadText(WriteTxt);
        // ReadTXT := 'KTVP_Sellout_Qty.XML' + '_' + Format(Today);
        ReadTXT := 'LG Sellout 9th Sept 2023.XML';// + '_' + Format(Today);
        // DownloadFromStream(Istr, '', '', '', ReadTXT);

        ABSCSetup.Get();
        Authorization := StorageServiceAuth.CreateSharedKey(ABSCSetup."Access key");
        ABSBlobClient.Initialize(ABSCSetup."Account Name", 'lgselloutqty', Authorization);
        FileName := ReadTXT;
        response := ABSBlobClient.PutBlobBlockBlobStream(FileName, Istr);

    end;
}
