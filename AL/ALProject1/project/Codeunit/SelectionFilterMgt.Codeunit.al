codeunit 50003 SelectionFilterMgt
{
    procedure GetSelectionGudfoodOrder(GudfoodOrderHeader: Record "Gudfood Order Header"): Text
    var
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
    begin
        RecRef.GetTable(GudfoodOrderHeader);
        exit(SelectionFilterManagement.GetSelectionFilter(RecRef, GudfoodOrderHeader.FIELDNO("No.")));
    end;
}
