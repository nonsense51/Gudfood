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
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the order number';
                }
                field("Sell- to Customer No."; Rec."Sell- to Customer No.")
                {
                    Caption = 'Customer Number';
                    ToolTip = 'To specify customer number';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies customer name';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ToolTip = 'To specify the order date';
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
        area(processing)
        {
            action(Post)
            {
                ToolTip = 'To post order to the Posted Documents';
                Image = PostedOrder;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    GudfoodPost.Run(Rec);
                end;
            }
            action("Post and Print")
            {
                ToolTip = 'To post order to the Posted Documents and print report';
                Image = PrintReport;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    OrderFilters: Text[250];
                begin
                    OrderFilters += GetSelectionFilters();
                    GudfoodPostPrint.SetOderFilters(OrderFilters);
                    GudfoodPostPrint.Run(Rec);
                end;
            }
        }
        area(Reporting)
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

                    GudfoodOrderPrint: Report "Gudfood Order";
                    OrderFilters: Text;
                begin
                    CurrPage.SetSelectionFilter(Rec);

                    OrderFilters += GetSelectionFilters();
                    GudfoodOrderPrint.SetGlobalVarForPrintAction(Rec, OrderFilters);
                    GudfoodOrderPrint.Run();
                end;
            }
            action("Export Order")
            {
                ToolTip = 'To export order to Xml file';
                Image = Export;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    XMLPORT.Run(50000, false, false, Rec);
                end;
            }
        }
        area(navigation)
        {
            action(Dimensions)
            {
                ToolTip = 'To see the dimensions';
                Image = Dimensions;
                ApplicationArea = All;
                ShortCutKey = 'Shift+Ctrl+D';

                trigger OnAction()
                begin
                    Rec.ShowDocDim();
                    CurrPage.SaveRecord();
                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateColor();
    end;

    var
        GudfoodPost: Codeunit "Gudfood Post";
        GudfoodPostPrint: Codeunit "Gudfood Post + Print";
        GudfoodOrderHeaderRecordRef: RecordRef;
        [InDataSet]
        ChangeClr: Boolean;

    procedure GetSelectionFilters(): Text
    var
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(Rec);
        GudfoodOrderHeaderRecordRef.GetTable(Rec);
        exit(SelectionFilterManagement.GetSelectionFilter(GudfoodOrderHeaderRecordRef, Rec.FIELDNO("No.")));
    end;

    local procedure UpdateColor()
    begin
        if Rec."Order Date" < Today then
            ChangeClr := true
        else
            ChangeClr := false;
    end;
}

