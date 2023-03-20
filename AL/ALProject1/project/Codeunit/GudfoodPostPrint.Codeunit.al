codeunit 50002 "Gudfood Post + Print"
{
    TableNo = 50017;

    trigger OnRun()
    begin
        GudfoodPost.Run(Rec);
        Commit();
        PostedGudfoodOrder.PostedGudfoodOrderPrint(Rec);
        PostedGudfoodOrder.Run();
    end;

    var

        PostedGudfoodOrder: Report "Posted Gudfood Order";
        GudfoodPost: Codeunit "Gudfood Post";

}

