codeunit 50002 "Gudfood Post + Print"
{
    TableNo = 50017;

    trigger OnRun()
    begin
        GudfoodPost.Run(Rec);
        Commit();
        PostedGudfoodOrder.PostedGudfoodOrderPrint(Rec, OrderFilters);
        PostedGudfoodOrder.Run();
    end;

    procedure SetOderFilters(OrderFilter: Text[250])
    begin
        OrderFilters += OrderFilter;
    end;

    var

        PostedGudfoodOrder: Report "Posted Gudfood Order";
        GudfoodPost: Codeunit "Gudfood Post";
        OrderFilters: Text[250];

}

