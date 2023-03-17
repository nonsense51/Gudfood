page 50012 "Gudfood Order List"
{
    Caption = 'Gudfood Order List';
    CardPageID = "Gudfood Order";
    Editable = false;
    PageType = List;
    SourceTable = "Gudfood Order Header";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; "No.")
                {
                }
                field("Sell- to Customer No."; "Sell- to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field("Order Date"; "Order Date")
                {
                }
                field("Posting No."; "Posting No.")
                {
                }
                field("Date Created"; "Date Created")
                {
                }
                field("Total Qty"; "Total Qty")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Action100000011)
            {
                action(Dimensions)
                {
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateColor;
    end;

    var
        MyRecRef: RecordRef;
        [InDataSet]
        ChangeClr: Boolean;

    procedure GetSelectionFilters(): Text
    var
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SETSELECTIONFILTER(Rec);
        MyRecRef.GETTABLE(Rec);
        EXIT(SelectionFilterManagement.GetSelectionFilter(MyRecRef, Rec.FIELDNO("No.")));
    end;

    local procedure UpdateColor()
    begin
        IF "Order Date" < TODAY THEN
            ChangeClr := TRUE
        ELSE
            ChangeClr := FALSE;
    end;
}

