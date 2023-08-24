codeunit 51104 "Sony Stock Mail"
{
    trigger OnRun()
    begin
        SendMail();
    end;

    procedure SendMail();
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
        ILE: Record 32;
    begin
        GL.Get();
        VarRecipient.RemoveRange(1, VarRecipient.Count);
        VarRecipientCC.RemoveRange(1, VarRecipientCC.Count);
        VarRecipient.Add(GL."Sony Sales Email To");
        VarRecipientCC.Add(GL."Sony Sales Email CC");
        //**** Email Create ****     
        VCount := VarRecipient.Count();
        IF VCount <> 0 then begin
            Emailmessage.Create(VarRecipient, 'Sony Stock Report ' + ' Dated ' + FORMAT(CalcDate('-1D', Today)), '', true, VarRecipientCC, VarRecipientBCC);
            //**** Report SaveAsPDF and Attached in Mail
            Clear(SentmailBool);
            //*****SAVE As PDF Code*****
            //StartDate := CalcDate('<-CM>', Today);
            /*
            if StartDate = Today then
                ILE.SetRange("Posting Date", StartDate, StartDate)
            else
                ILE.SetRange("Posting Date", StartDate, CalcDate('-1D', Today));
            */
            RItem.Reset();
            RItem.SetRange("Category 1", 'SONY');
            //RItem.SetFilter("No.", '%1|%2', 'KTVACI00163', 'KTVITL00598');
            Recref.GetTable(RItem);
            TempBlob.CreateOutStream(OutStr);
            Report.SaveAs(Report::"Stock Report Sony", '', ReportFormat::Excel, OutStr, Recref);
            TempBlob.CreateInStream(InStr);
            FileName := 'Stock ReportSONY' + '_' + FORMAT(Today) + '.xlsx';
            Emailmessage.AddAttachment(FileName, '.xlsx', InStr);
            SentmailBool := true;

            //**** Email Body Creation *****
            Emailmessage.AppendToBody('<p><font face="Georgia">Dear <B>Sir,</B></font></p>');
            Char := 13;
            Emailmessage.AppendToBody(FORMAT(Char));
            Emailmessage.AppendToBody('<p><font face="Georgia"> <B>!!!Greetings!!!</B></font></p>');
            Emailmessage.AppendToBody(FORMAT(Char));
            Emailmessage.AppendToBody(FORMAT(Char));
            Emailmessage.AppendToBody('<p><font face="Georgia"><BR>Please find enclosed Sony Stock datas.</BR></font></p>');
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
