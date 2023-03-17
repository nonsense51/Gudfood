table 50016 "Gudfood Item"
{
    Caption = 'Gudfood Item';
    DrillDownPageID = 50003;
    LookupPageID = 50003;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Number';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    SalesSetup.GET;
                    NoMgt.TestManual(SalesSetup."Gudfood Item Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(3; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
        }
        field(4; ItemType; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            NotBlank = true;
            OptionCaption = ' ,Salat,Burger,Capcake,Drink';
            OptionMembers = " ",Salat,Burger,Capcake,Drink;
        }
        field(5; "Qty. Ordered"; Decimal)
        {

            CalcFormula = Sum("Posted Gudfood Order Line".Quantity WHERE("Item No." = FIELD("No.")));
            Caption = 'Qty. Ordered';
            FieldClass = FlowField;

        }
        field(6; "Qty. in Order"; Decimal)
        {
            CalcFormula = Sum("Gudfood Order Line".Quantity WHERE("Item No." = FIELD("No.")));
            Caption = 'Qty. in Order';
            FieldClass = FlowField;
        }
        field(7; "Shelf Life"; Date)
        {
            Caption = 'Shelf Life';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(8; Picture; MediaSet)
        {
            Caption = 'Picture';
            DataClassification = ToBeClassified;
        }
        field(9; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(10; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(11; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DimMgt.DeleteDefaultDim(DATABASE::"Gudfood Item", "No.");
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN
            IF DocumentNoVisability.ItemNoSeriesIsDefault THEN BEGIN
                SalesSetup.GET;
                NoMgt.InitSeries(SalesSetup."Gudfood Item Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            END;

        DimMgt.UpdateDefaultDim(DATABASE::"Gudfood Item", "No.", "Global Dimension 1 Code", "Global Dimension 2 Code");
    end;

    trigger OnModify()
    begin
        IF Description = '' THEN
            ERROR(text001);
        IF "Unit Price" = 0 THEN
            ERROR(text002);
        IF ItemType = ItemType::" " THEN
            ERROR(text003);
        IF "Shelf Life" = 0D THEN
            ERROR(text004);
    end;

    var
        DocumentNoVisability: Codeunit DocumentNoVisibility;
        SalesSetup: Record "Sales & Receivables Setup";
        NoMgt: Codeunit NoSeriesManagement;
        text001: Label 'Description can''t be empty!';
        text002: Label 'Unit Price can''t be 0!';
        text003: Label 'You need to choose Type!';
        text004: Label 'Shelf Life can''t be empty!';
        DimMgt: Codeunit DimensionManagement;

    procedure AssistEdit(OldGudfoodItem: Record "Gudfood Item"): Boolean
    var
        NewGudfoodItem: Record "Gudfood Item";
    begin
        with NewGudfoodItem do begin
            NewGudfoodItem := Rec;
            SalesSetup.Get();
            SalesSetup.TestField("Gudfood Item Nos.");
            if NoMgt.SelectSeries(SalesSetup."Gudfood Item Nos.", OldGudfoodItem."No. Series", "No. Series") then begin
                NoMgt.SetSeries("No.");
                Rec := NewGudfoodItem;
                Exit(TRUE);
            end;
        end;

    end;
}

