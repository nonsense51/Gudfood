page 50004 "Gudfood Item Card"
{
    Caption = 'Gudfood Item Card';
    PageType = Card;
    SourceTable = "Gudfood Item";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'To specidy number of item';

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE();
                    end;
                }
                field("Unit Price"; "Unit Price")
                {
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field(ItemType; ItemType)
                {
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field(Description; Description)
                {
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field("Shelf Life"; "Shelf Life")
                {
                    NotBlank = true;
                    ShowMandatory = true;
                }
            }
            group("Order Information")
            {
                field("Qty. Ordered"; "Qty. Ordered")
                {

                }
                field("Qty. in Order"; "Qty. in Order")
                {

                }
            }
            group(Images)
            {
                field(Picture; Picture)
                {
                }
            }
        }
        area(FactBoxes)
        {
            part(Image; "Gudfood Item Picture")
            {
                SubPageLink = "No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Dimensions)
            {
                Image = Dimensions;
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = CONST(50016), "No." = FIELD("No.");
                ShortCutKey = 'Shift+Ctrl+D';
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Rec.TestField(Description);
        Rec.TestField("Unit Price");
        Rec.TestField(ItemType);
        Rec.TestField("Shelf Life");
    end;
}

