report 50002 "Gudfood Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './GudfoodOrder.rdlc';
    Caption = 'Gudfood Order';

    dataset
    {
        dataitem("Gudfood Order Header"; Table50017)
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
            dataitem("Gudfood Order Line"; Table50018)
            {
                DataItemLink = Order No.=FIELD(No.);
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
                IF ("Start Date" <> 0D) AND ("End Date" <> 0D) THEN
                    "Gudfood Order Header".SETFILTER("Date Created", '%1..%2', "Start Date", "End Date")
                ELSE
                    IF ("Start Date" = 0D) AND ("End Date" <> 0D) THEN
                        "Gudfood Order Header".SETFILTER("Date Created", '..%1', "End Date")
                    ELSE
                        IF ("Start Date" <> 0D) AND ("End Date" = 0D) THEN
                            "Gudfood Order Header".SETFILTER("Date Created", '%1..', "Start Date");

                IF OrderNoFilter <> '' THEN
                    "Gudfood Order Header".SETFILTER("No.", OrderNoFilter);
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
            IF NOT GudfoodOrderHdrGlb.ISEMPTY THEN BEGIN
                "Start Date" := GudfoodOrderHdrGlb."Date Created";
                "End Date" := GudfoodOrderHdrGlb."Date Created";
                OrderNoFilter := GudfoodOrderHdrGlb."No.";
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
        OrderPage: Page "50012";
        HideTotals: Boolean;
        GudfoodOrderHdrGlb: Record "50017";

    [Scope('Internal')]
    procedure SetGlobalVar(NewGudfoodOrderHdr: Record "50017")
    begin
        GudfoodOrderHdrGlb := NewGudfoodOrderHdr;
    end;
}

