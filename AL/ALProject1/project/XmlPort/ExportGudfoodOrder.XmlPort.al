xmlport 50000 "Export Gudfood Order"
{
    Caption = 'Export Gudfood Order';
    Direction = Export;
    FormatEvaluate = Xml;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("Gudfood Order Header"; "Gudfood Order Header")
            {
                RequestFilterFields = "No.";
                XmlName = 'GudfoodOrderHeader';
                fieldelement("No."; "Gudfood Order Header"."No.")
                {
                }
                fieldelement("Sell-toCustomerNo."; "Gudfood Order Header"."Sell- to Customer No.")
                {
                }
                fieldelement("Sell-toCustomerName"; "Gudfood Order Header"."Sell-to Customer Name")
                {
                }
                fieldelement(OrderDate; "Gudfood Order Header"."Order Date")
                {
                }
                fieldelement("PostingNo."; "Gudfood Order Header"."Posting No.")
                {
                }
                fieldelement(DateCreated; "Gudfood Order Header"."Date Created")
                {
                }
                fieldelement(TotalQty; "Gudfood Order Header"."Total Qty")
                {
                }
                fieldelement(TotalAmount; "Gudfood Order Header"."Total Amount")
                {
                }
                tableelement("Gudfood Order Line"; "Gudfood Order Line")
                {
                    LinkFields = "Order No." = FIELD("No.");
                    LinkTable = "Gudfood Order Header";
                    XmlName = 'GudfoodOrderLine';
                    fieldelement("OrderNo."; "Gudfood Order Line"."Order No.")
                    {
                    }
                    fieldelement("LineNo."; "Gudfood Order Line"."Line No.")
                    {
                    }
                    fieldelement("Sell-toCustomerNo."; "Gudfood Order Line"."Sell- to Customer No.")
                    {
                    }
                    fieldelement(DateCreated; "Gudfood Order Line"."Date Created")
                    {
                    }
                    fieldelement("ItemNo."; "Gudfood Order Line"."Item No.")
                    {
                    }
                    fieldelement(ItemType; "Gudfood Order Line"."Item Type")
                    {
                    }
                    fieldelement(Description; "Gudfood Order Line".Description)
                    {
                    }
                    fieldelement(Quantity; "Gudfood Order Line".Quantity)
                    {
                    }
                    fieldelement(UnitPrice; "Gudfood Order Line"."Unit Price")
                    {
                    }
                    fieldelement(Amount; "Gudfood Order Line".Amount)
                    {
                    }
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        if "Gudfood Order Line"."Order No." <> "Gudfood Order Header"."No." then
            currXMLport.Skip();
    end;
}

