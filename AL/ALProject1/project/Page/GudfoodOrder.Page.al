page 50008 "Gudfood Order"
{
    Caption = 'Gudfood Order';
    PageType = Document;
    SourceTable = "Gudfood Order Header";

    layout
    {
        area(content)
        {
            // test
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    TableRelation = "Gudfood Order Header"."No.";
                }
                field("Sell- to Customer No."; "Sell- to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field("Order Date"; "Order Date")
                {
                    Style = Attention;
                    StyleExpr = ChangeClr;
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
            part(GudfoodOrderSubpage; "Gudfood Order Subpage")
            {
                SubPageLink = "Order No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                Image = PostedOrder;
                Promoted = true;

                trigger OnAction()
                begin
                    GudfoodPost.RUN(Rec);
                end;
            }
            action("Post and Print")
            {
                Image = PrintReport;
                Promoted = true;

                trigger OnAction()
                begin
                    "GudfoodPost+Print".RUN(Rec);
                end;
            }
            group(PrintAndExportDocument)
            {
                action("Print Document")
                {
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        GudfoodOrderPrint: Report "Gudfood Order";
                    begin
                        CurrPage.SetSelectionFilter(Rec);
                        GudfoodOrderPrint.SetGlobalVar(Rec);
                        GudfoodOrderPrint.Run();
                    end;
                }
                action("Export Order")
                {
                    Image = Export;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        MyPort: XMLport "Export Gudfood Order";
                        FileManagement: Codeunit "File Management";
                        Instream: InStream;
                        FileName: Text[250];
                    begin
                        CurrPage.SETSELECTIONFILTER(Rec);
                        XMLPORT.RUN(50000, FALSE, FALSE, Rec);
                    end;
                }
            }
        }
        area(navigation)
        {
            group(Navigation)
            {
                action(Dimensions)
                {
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                        CurrPage.SAVERECORD;
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
        [InDataSet]
        ChangeClr: Boolean;
        GudfoodPost: Codeunit "Gudfood Post";
        "GudfoodPost+Print": Codeunit "Gudfood Post + Print";
        GudfoodLine: Record "Gudfood Order Line";
        MyReport: Report "Gudfood Order";
        MyRecRef: RecordRef;

    local procedure UpdateColor()
    begin
        IF "Order Date" < TODAY THEN
            ChangeClr := TRUE
        ELSE
            ChangeClr := FALSE;
    end;
}

