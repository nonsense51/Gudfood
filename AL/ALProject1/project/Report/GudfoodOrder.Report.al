report 50002 "Gudfood Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/GudfoodOrder.rdlc';
    Caption = 'Gudfood Order';
    dataset
    {
        dataitem("Gudfood Order Header"; "Gudfood Order Header")
        {
            RequestFilterFields = "Sell- to Customer No.";
            column(No_GudfoodOrderHeader; "Gudfood Order Header"."No.")
            {
            }
            column(SelltoCustomerNo_GudfoodOrderHeader; "Gudfood Order Header"."Sell- to Customer No.")
            {
            }
            column(SelltoCustomerName_GudfoodOrderHeader; "Gudfood Order Header"."Sell-to Customer Name")
            {
            }
            column(DateCreated_GudfoodOrderHeader; "Gudfood Order Header"."Date Created")
            {
            }
            column(TotalQty_GudfoodOrderHeaders; "Gudfood Order Header"."Total Qty")
            {
            }
            column(TotalAmount_GudfoodOrderHeader; "Gudfood Order Header"."Total Amount")
            {
            }
            column(UsersID; UsersID)
            {
            }
            column(DocumentDate; DocumentDate)
            {
            }
            column(StartDate; "Start Date")
            {
            }
            column(EndDate; "End Date")
            {
            }
            column(OrderNoFilter; OrderNoFilter)
            {
            }
            column(HideTotals; HideTotals)
            {
            }
            dataitem("Gudfood Order Line"; "Gudfood Order Line")
            {
                DataItemLink = "Order No." = FIELD("No.");
                DataItemLinkReference = "Gudfood Order Header";
                column(OrderNo_GudfoodOrderLine; "Gudfood Order Line"."Order No.")
                {
                }
                column(LineNo_GudfoodOrderLine; "Gudfood Order Line"."Line No.")
                {
                }
                column(ItemNo_GudfoodOrderLine; "Gudfood Order Line"."Item No.")
                {
                }
                column(ItemType_GudfoodOrderLine; "Gudfood Order Line"."Item Type")
                {
                    IncludeCaption = true;
                }
                column(Description_GudfoodOrderLine; "Gudfood Order Line".Description)
                {
                }
                column(Quantity_GudfoodOrderLine; "Gudfood Order Line".Quantity)
                {
                }
                column(UnitPrice_GudfoodOrderLine; "Gudfood Order Line"."Unit Price")
                {
                }
                column(Amount_GudfoodOrderLine; "Gudfood Order Line".Amount)
                {
                }
            }

            trigger OnPreDataItem()
            begin
                if ("Start Date" <> 0D) and ("End Date" <> 0D) then
                    "Gudfood Order Header".SetFilter("Date Created", '%1..%2', "Start Date", "End Date")
                else
                    if ("Start Date" = 0D) and ("End Date" <> 0D) then
                        "Gudfood Order Header".SetFilter("Date Created", '..%1', "End Date")
                    else
                        if ("Start Date" <> 0D) and ("End Date" = 0D) then
                            "Gudfood Order Header".SetFilter("Date Created", '%1..', "Start Date");

                if OrderNoFilter <> '' then
                    "Gudfood Order Header".SetFilter("No.", OrderNoFilter);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Date Filter")
                {
                    field("Start Date"; "Start Date")
                    {
                        Caption = 'Start Date';
                        ToolTip = 'To specify start date filter';
                    }
                    field("End Date"; "End Date")
                    {
                        Caption = 'End Date';
                        ToolTip = 'To specify end date filter';
                    }
                }
                group("Order No. Filter")
                {
                    field("Order Number"; OrderNoFilter)
                    {
                        Caption = 'Order Number';
                        ToolTip = 'To specify order number filter';
                        Lookup = true;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            Clear(OrderNoFilter);
                            OrderPage.LookupMode(true);
                            if OrderPage.RunModal() = ACTION::LookupOK then begin
                                Text := OrderNoFilter + OrderPage.GetSelectionFilters();
                                exit(true);
                            end else
                                exit(false);
                        end;
                    }
                }
                group("Hide Totals")
                {
                    field(HideTotals; HideTotals)
                    {
                        Caption = 'Hide Totals';
                        ToolTip = 'To hide totals';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            if not GudfoodOrderHdrGlb.IsEmpty then begin
                GudfoodOrderHdrGlb.SetCurrentKey("Date Created");
                GudfoodOrderHdrGlb.FindFirst();
                "Start Date" := GudfoodOrderHdrGlb."Date Created";
                GudfoodOrderHdrGlb.FindLast();
                "End Date" := GudfoodOrderHdrGlb."Date Created";
            end;
        end;
    }
    trigger OnPreReport()
    begin
        UsersID := UserId;
        DocumentDate := Today;
    end;

    var
        GudfoodOrderHdrGlb: Record "Gudfood Order Header";
        OrderPage: Page "Gudfood Order List";
        UsersID: Code[30];
        DocumentDate: Date;
        "Start Date": Date;
        "End Date": Date;
        OrderNoFilter: Text[250];
        HideTotals: Boolean;


    procedure SetGlobalVar(NewGudfoodOrderHeader: Record "Gudfood Order Header")
    begin
        GudfoodOrderHdrGlb := NewGudfoodOrderHeader;
    end;

    procedure SetGlobalVarForPrintAction(NewGudfoodOrderHeader: Record "Gudfood Order Header"; OrderFilters: Text[250])
    begin
        GudfoodOrderHdrGlb := NewGudfoodOrderHeader;
        OrderNoFilter := OrderFilters;
    end;
}

