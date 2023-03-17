page 50008 "Gudfood Order"
{
    Caption = 'Gudfood Order';
    PageType = Document;
    SourceTable = "Gudfood Order Header";

    layout
    {
        area(content)
        {
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
            group()
            {
                action("Print Document")
                {
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        GudfoodOrderPrint: Report "50002";
                    begin
                        CurrPage.SETSELECTIONFILTER(Rec);
                        GudfoodOrderPrint.SetGlobalVar(Rec);
                        GudfoodOrderPrint.RUN();
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
                        MyPort: XMLport "50000";
                        FileManagement: Codeunit "419";
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
        GudfoodPost: Codeunit "50001";
        "GudfoodPost+Print": Codeunit "50002";
        GudfoodLine: Record "50018";
        MyReport: Report "50002";
        MyRecRef: RecordRef;

    local procedure UpdateColor()
    begin
        IF "Order Date" < TODAY THEN
            ChangeClr := TRUE
        ELSE
            ChangeClr := FALSE;
    end;
}

