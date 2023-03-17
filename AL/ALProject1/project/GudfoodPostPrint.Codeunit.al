codeunit 50002 "Gudfood Post + Print"
{
    TableNo = 50017;

    trigger OnRun()
    begin
        PostGudfoodOrderHdr.RUN(Rec);
        Commit();
        PostedGudfoodOrderReport.PostedGudfoodOrderPrint(Rec);
        PostedGudfoodOrderReport.RUN;
    end;

    var
        PostGudfoodOrderHdr: Codeunit "Gudfood Post";
        PostedGudfoodOrderReport: Report "Posted Gudfood Order";
}

