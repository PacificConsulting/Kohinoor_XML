codeunit 51102 "Stock Qty"
{
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
        ILE11: Record 32;
        RecLocation: Record 14;
        ABSBlobClient: Codeunit "ABS Blob Client";
        Authorization: Interface "Storage Service Authorization";
        ABSCSetup: Record "Azure Storage Container Setup";
        StorageServiceAuth: Codeunit "Storage Service Authorization";
        FileName: Text;
        response: Codeunit "ABS Operation Response";
    begin

        XMLDoc := XmlDocument.Create();
        RootNode := XmlElement.Create('ST');
        XMLDoc.Add(RootNode);

        RecItem.Reset();
        RecItem.SetRange("Category 1", 'LG');
        IF RecItem.FindSet() then
            repeat
                ILE.Reset();
                ILE.SetRange("Item No.", RecItem."No.");
                ILE.SetRange("Posting Date", CalcDate('-1D', Today));
                //ILE.SetRange("Posting Date", 20230630D);
                IF ILE.FindSet() then
                    repeat
                        VL.Reset();
                        VL.SetRange("Document No.", SalesInvLine."Document No.");
                        VL.SetRange("Item No.", SalesInvLine."No.");
                        if VL.FindFirst() then begin
                            ILE11.Reset();
                            ILE11.SetRange("Entry No.", VL."Item Ledger Entry No.");
                            if ILE11.FindFirst() then;
                            //serialno := ILE."Serial No.";
                        end;
                        SalInvHdr.Reset();
                        SalInvHdr.SetRange("No.", SalesInvLine."Document No.");
                        IF SalInvHdr.FindFirst() then;
                        Clear(TotalAmount);
                        CalcSta.GetPostedSalesInvStatisticsAmount(SalInvHdr, TotalAmount);

                        ParentNood := XmlElement.Create('ST_REC');
                        RootNode.Add(ParentNood);

                        ChildNood := XmlElement.Create('BATCH_NO');
                        XMLTxt := XmlText.Create(FORMAT(ILE."Posting Date"));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('STOCK_DATE');
                        XMLTxt := XmlText.Create(FORMAT(ILE."Posting Date"));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('SITECODE');
                        XMLTxt := XmlText.Create(Format(ILE."Global Dimension 1 Code"));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('MT_CUST');
                        XMLTxt := XmlText.Create(Format('KTVP'));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        IF RecLocation.get(ILE."Location Code") then begin
                            IF RecLocation.Store then begin
                                ChildNood := XmlElement.Create('SITECODE_TYPE');
                                XMLTxt := XmlText.Create(Format(RecLocation.Code));
                                ChildNood.Add(XMLTxt);
                                ParentNood.Add(ChildNood);
                            end else begin
                                ChildNood := XmlElement.Create('SITECODE_TYPE');
                                XMLTxt := XmlText.Create(Format('DC'));
                                ChildNood.Add(XMLTxt);
                                ParentNood.Add(ChildNood);
                            end;
                        end;

                        IF RecLocation.get(ILE."Location Code") then;
                        ChildNood := XmlElement.Create('SITECODE_INFO');
                        XMLTxt := XmlText.Create(Format(RecLocation.Name));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('ITEMCODE');
                        XMLTxt := XmlText.Create(Format(ILE."Item No."));
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

                        /*
                        ChildNood := XmlElement.Create('LG_MODEL');
                        XMLTxt := XmlText.Create(Format(RecItem."No."));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);
                        */

                        ChildNood := XmlElement.Create('FAMILYNAME');
                        XMLTxt := XmlText.Create(Format(RecItem."Category 1"));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('PARTNO');
                        XMLTxt := XmlText.Create(Format(RecItem."No. 2")); //Iten No 2
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('SERIALNO');
                        XMLTxt := XmlText.Create(Format(ILE."Serial No."));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('STOCK');
                        XMLTxt := XmlText.Create(Format(ILE.Quantity));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('SALEABLE');
                        XMLTxt := XmlText.Create(Format(''));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('DEFECT');
                        XMLTxt := XmlText.Create(Format('0'));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('DISPLAY');
                        XMLTxt := XmlText.Create(Format('0'));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('TRANSIT_QTY');
                        XMLTxt := XmlText.Create(Format('0'));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);
                    until ILE.Next() = 0;
            until RecItem.next() = 0;
        TB.CreateInStream(Istr);
        TB.CreateOutStream(Ostr);
        XMLDoc.WriteTo(Ostr);
        Ostr.WriteText(WriteTxt);
        Istr.ReadText(WriteTxt);
        ReadTXT := 'KTVP_Stock_Qty.XML' + '_' + Format(Today);
        DownloadFromStream(Istr, '', '', '', ReadTXT);

        ABSCSetup.Get();
        //ABSCSetup.TestField("Container Name Demo");
        Authorization := StorageServiceAuth.CreateSharedKey(ABSCSetup."Access key");
        ABSBlobClient.Initialize(ABSCSetup."Account Name", 'lgstockqty', Authorization);
        FileName := ReadTXT;
        response := ABSBlobClient.PutBlobBlockBlobStream(FileName, Istr);
    end;
}
