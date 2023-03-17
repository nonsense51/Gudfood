report 50003 "Posted Gudfood Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PostedGudfoodOrder.rdlc';
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
                DataItemLink = "Order No." = FIELD("No.");
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
                IF ("Start Date" <> 0D) AND ("End Date" <> 0D) THEN
                    "Posted Gudfood Order Header".SETFILTER("Date Created", '%1..%2', "Start Date", "End Date")
                ELSE
                    IF ("Start Date" = 0D) AND ("End Date" <> 0D) THEN
                        "Posted Gudfood Order Header".SETFILTER("Date Created", '..%1', "End Date")
                    ELSE
                        IF ("Start Date" <> 0D) AND ("End Date" = 0D) THEN
                            "Posted Gudfood Order Header".SETFILTER("Date Created", '%1..', "Start Date");

                IF OrderNoFilter <> '' THEN
                    "Posted Gudfood Order Header".SETFILTER("No.", OrderNoFilter);
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
                    }
                    field("End Date"; "End Date")
                    {
                    }
                }
                group("Order No. Filter")
                {
                    field("Order Number"; OrderNoFilter)
                    {
                        Lookup = true;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            CLEAR(OrderNoFilter);
                            OrderPage.LOOKUPMODE(TRUE);
                            IF OrderPage.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                                Text := OrderNoFilter + OrderPage.GetSelectionFilters();
                                EXIT(TRUE);
                            END ELSE
                                EXIT(FALSE);
                        end;
                    }
                }
                group("Hide Totals")
                {
                    field(HideTotals; HideTotals)
                    {
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF NOT PostedGudFoodOrderHdr.ISEMPTY THEN BEGIN
                "Start Date" := PostedGudFoodOrderHdr."Date Created";
                "End Date" := PostedGudFoodOrderHdr."Date Created";
                OrderNoFilter := PostedGudFoodOrderHdr."No.";
            END;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        UsersID := USERID;
        DocumentDate := TODAY;
    end;

    var
        UsersID: Code[30];
        DocumentDate: Date;
        "Start Date": Date;
        "End Date": Date;
        OrderNoFilter: Text[250];
        OrderPage: Page "Posted Gudfood Order List";
        HideTotals: Boolean;
        PostedGudFoodOrderHdr: Record "Gudfood Order Header";

    procedure PostedGudfoodOrderPrint(NewPostedGudfoodOrderHdr: Record "Gudfood Order Header")
    begin
        PostedGudFoodOrderHdr := NewPostedGudfoodOrderHdr;
    end;
}

