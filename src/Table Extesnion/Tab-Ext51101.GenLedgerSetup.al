tableextension 51101 "Gen Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(51101; "Sony Sales Email To"; Text[50])
        {
            Caption = 'Sony Sales Email To';
            DataClassification = ToBeClassified;
        }
        field(51102; "Sony Sales Email CC"; Text[50])
        {
            Caption = 'Sony Sales Email CC';
            DataClassification = ToBeClassified;
        }
    }
}
