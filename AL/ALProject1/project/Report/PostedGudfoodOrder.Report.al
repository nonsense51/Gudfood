report 50003 "Posted Gudfood Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/PostedGudfoodReport.rdlc';
    Caption = 'Gudfood Order';

    dataset
    {
        dataitem("Posted Gudfood Order Header"; "Posted Gudfood Order Header")
        {
            RequestFilterFields = "Sell- to Customer No.";
            column(No_GudfoodOrderHeader; "Posted Gudfood Order Header"."No.")
            {
            }
            column(SelltoCustomerNo_GudfoodOrderHeader; "Posted Gudfood Order Header"."Sell- to Customer No.")
            {
            }
            column(SelltoCustomerName_GudfoodOrderHeader; "Posted Gudfood Order Header"."Sell-to Customer Name")
            {
            }
            column(DateCreated_GudfoodOrderHeader; "Posted Gudfood Order Header"."Date Created")
            {
            }
            column(TotalQty_GudfoodOrderHeader; "Posted Gudfood Order Header"."Total Qty")
            {
            }
            column(TotalAmount_GudfoodOrderHeader; "Posted Gudfood Order Header"."Total Amount")
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
            dataitem("Posted Gudfood Order Line"; "Posted Gudfood Order Line")
            {
                DataItemLink = "Order No." = field("No.");
                DataItemLinkReference = "Posted Gudfood Order Header";
                column(OrderNo_GudfoodOrderLine; "Posted Gudfood Order Line"."Order No.")
                {
                }
                column(LineNo_GudfoodOrderLine; "Posted Gudfood Order Line"."Line No.")
                {
                }
                column(ItemNo_GudfoodOrderLine; "Posted Gudfood Order Line"."Item No.")
                {
                }
                column(ItemType_GudfoodOrderLine; "Posted Gudfood Order Line"."Item Type")
                {
                    IncludeCaption = true;
                }
                column(Description_GudfoodOrderLine; "Posted Gudfood Order Line".Description)
                {
                }
                column(Quantity_GudfoodOrderLine; "Posted Gudfood Order Line".Quantity)
                {
                }
                column(UnitPrice_GudfoodOrderLine; "Posted Gudfood Order Line".UntiPrice)
                {
                }
                column(Amount_GudfoodOrderLine; "Posted Gudfood Order Line".Amount)
                {
                }
            }

            trigger OnPreDataItem()
            begin
                if ("Start Date" <> 0D) and ("End Date" <> 0D) then
                    "Posted Gudfood Order Header".SetFilter("Date Created", '%1..%2', "Start Date", "End Date")
                else
                    if ("Start Date" = 0D) and ("End Date" <> 0D) then
                        "Posted Gudfood Order Header".SetFilter("Date Created", '..%1', "End Date")
                    else
                        if ("Start Date" <> 0D) and ("End Date" = 0D) then
                            "Posted Gudfood Order Header".SetFilter("Date Created", '%1..', "Start Date");

                if OrderNoFilter <> '' then
                    "Posted Gudfood Order Header".SetFilter("No.", OrderNoFilter);
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

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if not PostedGudFoodOrderHdr.IsEmpty then begin
                PostedGudFoodOrderHdr.SetCurrentKey("Date Created");
                PostedGudFoodOrderHdr.FindFirst();
                "Start Date" := PostedGudFoodOrderHdr."Date Created";
                PostedGudFoodOrderHdr.FindLast();
                "End Date" := PostedGudFoodOrderHdr."Date Created";
            end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        UsersID := UserId;
        DocumentDate := TODAY;
    end;

    var
        PostedGudFoodOrderHdr: Record "Posted Gudfood Order Header";
        GudFoodOrderHdr: Record "Gudfood Order Header";
        OrderPage: Page "Posted Gudfood Order List";
        UsersID: Code[30];
        HideTotals: Boolean;
        DocumentDate: Date;
        "Start Date": Date;
        "End Date": Date;

        OrderNoFilter: Text[250];


    procedure PostedGudfoodOrderPrint(NewGudfoodOrderHeader: Record "Gudfood Order Header"; OrderFilters: Text[250])
    begin
        GudFoodOrderHdr := NewGudfoodOrderHeader;
        OrderNoFilter := OrderFilters;
    end;

    procedure SetGlobalVar(NewPostedGudfoodOrderHeader: Record "Posted Gudfood Order Header")
    begin
        "Posted Gudfood Order Header" := NewPostedGudfoodOrderHeader;
    end;

    procedure SetGlobalVarForPrintAction(NewGudfoodOrderHeader: Record "Posted Gudfood Order Header"; OrderFilters: Text[250])
    begin
        PostedGudFoodOrderHdr := NewGudfoodOrderHeader;
        OrderNoFilter := OrderFilters;
    end;
}

