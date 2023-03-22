page 50013 "Posted Gudfood Order List"
{
    Caption = 'Posted Gudfood Order List';
    CardPageID = "Posted Gudfood Order";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Gudfood Order Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the order number';
                }
                field("Sell- to Customer No."; Rec."Sell- to Customer No.")
                {
                    Caption = 'Customer Number';
                    ToolTip = 'Specifies customer number';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies customer name';
                    Editable = false;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ToolTip = 'Specifies the order date';
                    Style = Attention;
                    StyleExpr = ChangeClr;
                }
                field("Posting No."; Rec."Posting No.")
                {
                    ToolTip = 'Specifies the posting number';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Date of created document';
                }
                field("Total Qty"; Rec."Total Qty")
                {
                    ToolTip = 'Total quantity of ordered products';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Total price of ordered products';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Print Document")
            {
                ToolTip = 'To print report';
                Image = PrintDocument;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Report;

                trigger OnAction()
                var

                    GudfoodOrderPrint: Report "Posted Gudfood Order";
                    OrderFilters: Text[250];
                begin
                    CurrPage.SetSelectionFilter(Rec);

                    OrderFilters += GetSelectionFilters();
                    GudfoodOrderPrint.SetGlobalVarForPrintAction(Rec, OrderFilters);
                    GudfoodOrderPrint.Run();
                end;
            }
        }
        area(navigation)
        {
            action(Dimensions)
            {
                ToolTip = 'To see the dimensions';
                Image = Dimensions;
                ShortCutKey = 'Shift+Ctrl+D';

                trigger OnAction()
                begin
                    Rec.ShowDocDim();
                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateColor();
    end;

    var
        PostedGudfoodOrderHeaderRecordRef: RecordRef;
        [InDataSet]
        ChangeClr: Boolean;

    procedure GetSelectionFilters(): Text
    var
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(Rec);
        PostedGudfoodOrderHeaderRecordRef.GetTable(Rec);
        exit(SelectionFilterManagement.GetSelectionFilter(PostedGudfoodOrderHeaderRecordRef, Rec.FIELDNO("No.")));
    end;

    local procedure UpdateColor()
    begin
        if Rec."Order Date" < TODAY then
            ChangeClr := true
        else
            ChangeClr := false;
    end;
}

