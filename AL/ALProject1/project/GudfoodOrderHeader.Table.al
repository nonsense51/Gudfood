table 50017 "Gudfood Order Header"
{
    Caption = 'Gudfood Order Header';
    DrillDownPageID = 50012;
    LookupPageID = 50012;
    //asdasdadsasd
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin


                IF "No." <> xRec."No." THEN BEGIN
                    SalesSetup.GET;
                    NoMgt.TestManual(SalesSetup."Gudfood Order Nos.");
                    "No. Series" := '';
                END;

                CreateDim(DATABASE::Customer, "Sell- to Customer No.");
            end;
        }
        field(2; "Sell- to Customer No."; Code[20])
        {
            Caption = 'Sell- to Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnLookup()
            begin
                CreateDim(DATABASE::Customer, "Sell- to Customer No.");
            end;

            trigger OnValidate()
            begin
                Customers.GET("Sell- to Customer No.");
                "Sell-to Customer Name" := Customers.Name;
            end;
        }
        field(3; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Date Created"; Date)
        {
            Caption = 'Date Created';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Total Qty"; Decimal)
        {
            CalcFormula = Sum("Gudfood Order Line".Quantity WHERE("Order No." = FIELD("No.")));
            Caption = 'Total Qty';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Gudfood Order Line".Amount WHERE("Order No." = FIELD("No.")));
            Caption = 'Total Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = "No. Series";
        }
        field(50; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(51; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
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
        GudfoodLine.SetRange("Order No.", Rec."No.");
        GudfoodLine.FindSet;
        REPEAT
            GudfoodLine.Delete;
        UNTIL GudfoodLine.Next = 0;
    end;

    trigger OnInsert()
    begin
        "Date Created" := TODAY;

        IF "No." = '' THEN
            IF DocumentNoVisability.ItemNoSeriesIsDefault THEN BEGIN
                SalesSetup.GET;
                NoMgt.InitSeries(SalesSetup."Gudfood Order Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            END;

        IF "Posting No." = '' THEN
            IF DocumentNoVisability.ItemNoSeriesIsDefault THEN BEGIN
                SalesSetup.GET;
                NoMgt.InitSeries(SalesSetup."Posted Gudfood Order Nos.", xRec."No. Series", 0D, "Posting No.", "No. Series");
            END;
    end;

    var
        Customers: Record Customer;
        DocumentNoVisability: Codeunit DocumentNoVisibility;
        SalesSetup: Record "Sales & Receivables Setup";
        NoMgt: Codeunit NoSeriesManagement;
        ChangeClr: Boolean;
        GudfoodLine: Record "Gudfood Order Line";
        DimMgt: Codeunit DimensionManagement;

    local procedure UpdateStyle()
    begin
        IF "Order Date" < TODAY THEN
            ChangeClr := TRUE
        ELSE
            ChangeClr := FALSE;
    end;

    [Scope('Internal')]
    procedure AssistEdit(OldGudfoodOrder: Record "Gudfood Order Header"): Boolean
    var
        NewGudfoodOrder: Record "Gudfood Order Header";
    begin
        WITH NewGudfoodOrder DO BEGIN
            NewGudfoodOrder := Rec;
            SalesSetup.Get;
            SalesSetup.TestField("Gudfood Order Nos.");
            IF NoMgt.SelectSeries(SalesSetup."Gudfood Order Nos.", OldGudfoodOrder."No. Series", "No. Series") THEN BEGIN
                NoMgt.SetSeries("No.");
                Rec := NewGudfoodOrder;
                EXIT(TRUE);
            END;
        END;

    end;

    procedure GudfoodRegLinesExist(): Boolean
    begin
        GudfoodLine.Reset();
        GudfoodLine.SetRange("Order No.", "No.");
        EXIT(GudfoodLine.FindFirst());
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';

        OldDimSetID := "Dimension Set ID";

        "Dimension Set ID" := DimMgt.GetDefaultDimID(TableID, No, SourceCodeSetup.GudfoodOrder, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
        IF (OldDimSetID <> "Dimension Set ID") AND
        GudfoodRegLinesExist
        THEN BEGIN
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        IF "No." <> '' THEN
            MODIFY;
        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF GudfoodRegLinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" := DimMgt.EditDimensionSet("Dimension Set ID", "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF GudfoodRegLinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        Text001: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        NewDimSetID: Integer;
    begin
        IF NewParentDimSetID = OldParentDimSetID THEN
            EXIT;
        IF NOT CONFIRM(Text001) THEN
            EXIT;
        GudfoodLine.RESET;
        GudfoodLine.SETRANGE("Order No.", "No.");
        GudfoodLine.LOCKTABLE;
        IF GudfoodLine.FIND('-') THEN
            REPEAT
                NewDimSetID := DimMgt.GetDeltaDimSetID(GudfoodLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                IF GudfoodLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
                    GudfoodLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                    GudfoodLine."Dimension Set ID",
                    GudfoodLine."Shortcut Dimension 1 Code",
                    GudfoodLine."Shortcut Dimension 2 Code");
                    GudfoodLine.MODIFY;
                END;
            UNTIL GudfoodLine.NEXT = 0;
    end;
}

