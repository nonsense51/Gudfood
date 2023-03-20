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
                    ToolTip = 'To specify number of item';

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.Update();
                    end;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'To specify product price';
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field(ItemType; Rec.ItemType)
                {
                    ToolTip = 'Choose the type of item';
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'To specify description';
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field("Shelf Life"; Rec."Shelf Life")
                {
                    ToolTip = 'Choose date of item shelf life';
                    NotBlank = true;
                    ShowMandatory = true;
                }
            }
            group("Order Information")
            {
                field("Qty. Ordered"; Rec."Qty. Ordered")
                {
                    ToolTip = 'Total quantity of items which already ordered';
                }
                field("Qty. in Order"; Rec."Qty. in Order")
                {
                    ToolTip = 'Total quantity of items which in order now';
                }
                field(Picture; Rec.Picture)
                {
                    ToolTip = 'Picture of item';
                    Visible = false;
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
                ToolTip = 'Tap to see the dimensuions';
                Image = Dimensions;
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = CONST(50016), "No." = FIELD("No.");
                ShortCutKey = 'Shift+Ctrl+D';
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not IsPageEmpty(Rec) then begin
            Rec.TestField(Description);
            Rec.TestField("Unit Price");
            Rec.TestField(ItemType);
            Rec.TestField("Shelf Life");
        end;
    end;

    procedure IsPageEmpty(GudfoodItem: Record "Gudfood Item"): Boolean
    begin
        if Rec."No." <> '' then
            exit(false)
        else
            exit(true)
    end;
}


