codeunit 51102 "XML File Creation1"
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
    begin
        SalInvHdr.Reset();
        SalInvHdr.SetFilter("No.", '%1|%2', 'VASTI23241100478', 'VASTI23241100477');
        IF SalInvHdr.FindSet() then
            repeat
                XMLDoc := XmlDocument.Create();
                RootNode := XmlElement.Create('SO');
                XMLDoc.Add(RootNode);

                ParentNood := XmlElement.Create('SO_REC');
                RootNode.Add(ParentNood);
                SalesInvLine.Reset();
                SalesInvLine.SetRange("Document No.", SalInvHdr."No.");
                SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
                IF SalesInvLine.FindSet() then
                    repeat
                        VL.Reset();
                        VL.SetRange("Document No.", SalesInvLine."Document No.");
                        VL.SetRange("Item No.", SalesInvLine."No.");
                        if VL.FindFirst() then begin
                            ILE.Reset();
                            ILE.SetRange("Entry No.", VL."Item Ledger Entry No.");
                            if ILE.FindFirst() then;
                            //serialno := ILE."Serial No.";
                        end;
                        Clear(TotalAmount);
                        CalcSta.GetPostedSalesInvStatisticsAmount(SalInvHdr, TotalAmount);


                        // FieldCap := SalesLine.FieldCaption("Posting Date");
                        ChildNood := XmlElement.Create('BATCH_NO');
                        XMLTxt := XmlText.Create(ILE."Serial No.");
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('MT_CUST');
                        XMLTxt := XmlText.Create(SalesInvLine."Sell-to Customer No.");
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('SELLOUT_DATE');
                        XMLTxt := XmlText.Create(Format(SalInvHdr."Posting Date"));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('SITECODE');
                        XMLTxt := XmlText.Create(Format(SalInvHdr."Shortcut Dimension 1 Code"));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('SITECODE_TYPE');
                        XMLTxt := XmlText.Create(Format(''));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('SITECODE_INFO');
                        XMLTxt := XmlText.Create(Format(SalInvHdr."Shortcut Dimension 2 Code"));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('ITEMCODE');
                        XMLTxt := XmlText.Create(Format(SalesInvLine."No."));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('EAN');
                        XMLTxt := XmlText.Create(Format(''));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('ITEMDESC');
                        XMLTxt := XmlText.Create(Format(SalesInvLine.Description));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('LG_MODEL');
                        XMLTxt := XmlText.Create(Format(''));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('FAMILYNAME');
                        XMLTxt := XmlText.Create(Format(''));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('REGULARITY');
                        XMLTxt := XmlText.Create(Format(''));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('INVOICE_NO');
                        XMLTxt := XmlText.Create(Format(SalesInvLine."Document No."));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('CUSTOMER_NAME');
                        XMLTxt := XmlText.Create(Format(SalInvHdr."Sell-to Customer Name"));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('GTM_CODE');
                        XMLTxt := XmlText.Create(Format(''));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('INVOICE_AMOUNT');
                        XMLTxt := XmlText.Create(Format(TotalAmount));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('SELLOUT_QTY');
                        XMLTxt := XmlText.Create(Format(SalesInvLine.Quantity));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);

                        ChildNood := XmlElement.Create('SELLOUT_QTY');
                        XMLTxt := XmlText.Create(Format('Sales order'));
                        ChildNood.Add(XMLTxt);
                        ParentNood.Add(ChildNood);
                    until SalesInvLine.Next() = 0;

            until SalInvHdr.Next() = 0;
        TB.CreateInStream(Istr);
        TB.CreateOutStream(Ostr);
        XMLDoc.WriteTo(Ostr);
        Ostr.WriteText(WriteTxt);
        Istr.ReadText(WriteTxt);
        ReadTXT := 'SO.XML';
        DownloadFromStream(Istr, '', '', '', ReadTXT);

    end;
}
