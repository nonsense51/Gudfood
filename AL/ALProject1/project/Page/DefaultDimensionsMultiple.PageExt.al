pageextension 50100 DefaultDimensionsMultipleExt extends "Default Dimensions-Multiple"
{
    procedure SetMultiGudfoodItem(var GudfoodItem: Record "Gudfood Item")
    begin
        ClearTempDefaultDim();
        with GudfoodItem do
            if Find('-') then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::"Gudfood Item", "No.");
                until Next() = 0;
    end;

}
