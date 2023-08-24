codeunit 51103 "Sony Sales Mail"
{
    trigger OnRun()
    begin
        SendMail();
    end;

    procedure SendMail();//(SIH: Record "Sales Invoice Header"; PayMethodCode: Code[10])
    var
        Recref: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        Instr: InStream;
        EMail: Codeunit Email;
        Emailmessage: Codeunit "Email Message";
        VarRecipient: list of [Text];
        Char: Char;
        ETF: Record "Email to Finance";
        SIHNEW: Record 112;
        VCount: Integer;
        PPL: record "Posted Payment Lines";
        FileName: Text[250];
        DocumentNo: Code[20];
        PaymentMethod: Record "Payment Method";
        Store: Record Location;
        SentmailBool: Boolean;
        SIL: Record 113;
        SCL: Record 115;
        StartDate: Date;
        ToDate: Date;
        GL: Record 98;
        VarRecipientCC: list of [Text];
        VarRecipientBCC: list of [Text];
        RItem: Record 27;
    begin
        GL.Get();
        VarRecipient.RemoveRange(1, VarRecipient.Count);
        VarRecipientCC.RemoveRange(1, VarRecipientCC.Count);
        GL.TestField("Sony Sales Email To");
        GL.TestField("Sony Sales Email CC");
        VarRecipient.Add(GL."Sony Sales Email To");
        VarRecipientCC.Add(GL."Sony Sales Email CC");
        //**** Email Create ****     
        VCount := VarRecipient.Count();
        IF VCount <> 0 then begin
            Emailmessage.Create(VarRecipient, 'Sony Stock ' + ' Dated ' + FORMAT(CalcDate('-1D', Today)), '', true, VarRecipientCC, VarRecipientBCC);
            //**** Report SaveAsPDF and Attached in Mail
            Clear(SentmailBool);
            //*****SAVE As PDF Code*****
            // StartDate := CalcDate('<-CM>', Today);
            // SIL.Reset();
            // SIL.SetRange("Posting Date", 20230803D, 20280803D);
            // /*
            // if StartDate = Today then
            //     SIL.SetRange("Posting Date", StartDate, StartDate)
            // else
            //     SIL.SetRange("Posting Date", StartDate, CalcDate('-1D', Today));
            //     */
            // IF SIL.FindFirst() then;
            // SCL.Reset();
            // SCL.SetRange("Posting Date", 20230803D, 20280803D);
            // /*
            // if StartDate = Today then
            //     SCL.SetRange("Posting Date", StartDate, StartDate)
            // else
            //     SCL.SetRange("Posting Date", StartDate, CalcDate('-1D', Today));
            //     */
            // IF SCL.FindFirst() then;
            RItem.Reset();
            RItem.SetRange("Category 1", 'Sony');
            IF RItem.Find() then;
            Recref.GetTable(RItem);
            TempBlob.CreateOutStream(OutStr);
            Report.SaveAs(Report::"Sony Sale Report", '', ReportFormat::Excel, OutStr, Recref);
            TempBlob.CreateInStream(InStr);
            FileName := 'Sales ReportSONY' + '_' + FORMAT(Today) + '.xlsx';
            Emailmessage.AddAttachment(FileName, '.xlsx', InStr);
            SentmailBool := true;

            //**** Email Body Creation *****
            Emailmessage.AppendToBody('<p><font face="Georgia">Dear <B>Sir,</B></font></p>');
            Char := 13;
            Emailmessage.AppendToBody(FORMAT(Char));
            Emailmessage.AppendToBody('<p><font face="Georgia"> <B>!!!Greetings!!!</B></font></p>');
            Emailmessage.AppendToBody(FORMAT(Char));
            Emailmessage.AppendToBody(FORMAT(Char));
            Emailmessage.AppendToBody('<p><font face="Georgia"><BR>Please find enclosed Sony Sale data.</BR></font></p>');
            Emailmessage.AppendToBody(FORMAT(Char));
            Emailmessage.AppendToBody(FORMAT(Char));
            Emailmessage.AppendToBody('<p><font face="Georgia"><BR>Thanking you,</BR></font></p>');
            Emailmessage.AppendToBody('<p><font face="Georgia"><BR>Warm Regards,</BR></font></p>');
            Emailmessage.AppendToBody('<p><font face="Georgia"><BR><B>For Kohinoor</B></BR></font></p>');
            Emailmessage.AppendToBody(FORMAT(Char));
            Emailmessage.AppendToBody(FORMAT(Char));
            Emailmessage.AppendToBody(FORMAT(Char));
            Emailmessage.AppendToBody(FORMAT(Char));
            //**** Email Send Function
            if SentmailBool = true then
                EMail.Send(Emailmessage, Enum::"Email Scenario"::Default);
        end;
        //until PaymentMethod.Next() = 0;
        //until Store.Next() = 0;
    end;

}
