page 50003 "Gudfood Item List"
{
    Caption = 'Gudfood Item List';
    CardPageID = "Gudfood Item Card";
    Editable = false;
    PageType = List;
    SourceTable = "Gudfood Item";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'To specify number of item';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'To specify product price';
                }
                field(ItemType; Rec.ItemType)
                {
                    ToolTip = 'Choose the type of item';
                }
                field("Shelf Life"; Rec."Shelf Life")
                {
                    ToolTip = 'Choose date of item shelf life';
                }
                field("Qty. Ordered"; Rec."Qty. Ordered")
                {
                    ToolTip = 'Total quantity of items which already ordered';
                }
                field("Qty. in Order"; Rec."Qty. in Order")
                {
                    ToolTip = 'Total quantity of items which in order now';
                }

            }
        }
        area(factboxes)
        {
            part(GudfoodItemPicture; "Gudfood Item Picture")
            {
                SubPageLink = "No." = field("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Dimensions)
            {
                Image = Dimensions;
                action("Dimensions-Single")
                {
                    ToolTip = 'To see single dimansion';
                    Image = Dimensions;
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = const(50016), "No." = field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("Dimensions-Multiple")
                {
                    ToolTip = 'To see multiply dimansion';
                    Image = DimensionSets;

                    trigger OnAction()
                    var
                        GudfoodItem: Record "Gudfood Item";
                        DefaultDimensionsMultiple: Page "Default Dimensions-Multiple";
                    begin
                        CurrPage.SetSelectionFilter(GudfoodItem);
                        DefaultDimensionsMultiple.SetMultiGudfoodItem(GudfoodItem);
                        DefaultDimensionsMultiple.RunModal();
                    end;
                }
            }

        }
    }
}

