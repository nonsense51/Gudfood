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
                if "No." <> xRec."No." then begin
                    SalesSetup.Get();
                    NoMgt.TestManual(SalesSetup."Gudfood Item Nos.");
                    "No. Series" := '';
                end;
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

            CalcFormula = sum("Posted Gudfood Order Line".Quantity where("Item No." = field("No.")));
            Caption = 'Qty. Ordered';
            FieldClass = FlowField;

        }
        field(6; "Qty. in Order"; Decimal)
        {
            CalcFormula = sum("Gudfood Order Line".Quantity where("Item No." = field("No.")));
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
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        DimMgt.DeleteDefaultDim(DATABASE::"Gudfood Item", "No.");
    end;

    trigger OnInsert()
    begin
        if "No." = '' then
            if DocumentNoVisability.ItemNoSeriesIsDefault() then begin
                SalesSetup.Get();
                NoMgt.InitSeries(SalesSetup."Gudfood Item Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            end;

        DimMgt.UpdateDefaultDim(DATABASE::"Gudfood Item", "No.", "Global Dimension 1 Code", "Global Dimension 2 Code");
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        DocumentNoVisability: Codeunit DocumentNoVisibility;
        NoMgt: Codeunit NoSeriesManagement;
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
                exit(true);
            end;
        end;

    end;
}

