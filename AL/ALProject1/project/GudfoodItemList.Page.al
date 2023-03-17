page 50003 "Gudfood Item List"
{
    Caption = 'Gudfood Item List';
    CardPageID = "Gudfood Item Card";
    Editable = false;
    PageType = List;
    SourceTable = "Gudfood Item";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; "No.")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field(ItemType; ItemType)
                {
                }
                field("Qty. Ordered"; "Qty. Ordered")
                {
                }
                field("Qty. in Order"; "Qty. in Order")
                {
                }
                field("Shelf Life"; "Shelf Life")
                {
                }
            }
        }
        area(factboxes)
        {
            part(GudfoodItemPicture; "Gudfood Item Picture")
            {
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group()
            {
                group(Dimensions)
                {
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        Image = Dimensions;
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(50016), "No." = FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-Multiple")
                    {
                        Image = DimensionSets;

                        trigger OnAction()
                        var
                            GudfoodItem: Record "Gudfood Item";
                            DefaultDimensionsMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SETSELECTIONFILTER(GudfoodItem);
                            DefaultDimensionsMultiple.SetMultiGudfoodItem(GudfoodItem);
                            DefaultDimensionsMultiple.RUNMODAL;
                        end;
                    }
                }
            }
        }
    }
}

