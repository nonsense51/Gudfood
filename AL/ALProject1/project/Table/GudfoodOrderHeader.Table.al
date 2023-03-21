table 50017 "Gudfood Order Header"
{
    Caption = 'Gudfood Order Header';
    DrillDownPageID = 50012;
    LookupPageID = 50012;
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SalesSetup.Get();
                    NoMgt.TestManual(SalesSetup."Gudfood Order Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Sell- to Customer No."; Code[20])
        {
            Caption = 'Sell- to Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                Customers.Get("Sell- to Customer No.");
                "Sell-to Customer Name" := Customers.Name;
                CreateDim(DATABASE::Customer, "Sell- to Customer No.");
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
            CalcFormula = sum("Gudfood Order Line".Quantity where("Order No." = field("No.")));
            Caption = 'Total Qty';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Total Amount"; Decimal)
        {
            CalcFormula = sum("Gudfood Order Line".Amount where("Order No." = field("No.")));
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
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(51; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

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
                ShowDocDim();
            end;
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
        GudfoodLine.SetRange("Order No.", Rec."No.");
        GudfoodLine.FindSet();
        repeat
            GudfoodLine.Delete();
        until GudfoodLine.Next() = 0;
    end;

    trigger OnInsert()
    begin
        "Date Created" := TODAY;

        if "No." = '' then
            if DocumentNoVisability.ItemNoSeriesIsDefault() then begin
                SalesSetup.Get();
                NoMgt.InitSeries(SalesSetup."Gudfood Order Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            end;

        if "Posting No." = '' then
            if DocumentNoVisability.ItemNoSeriesIsDefault() then begin
                SalesSetup.Get();
                NoMgt.InitSeries(SalesSetup."Posted Gudfood Order Nos.", xRec."No. Series", 0D, "Posting No.", "No. Series");
            end;
    end;

    var
        GudfoodLine: Record "Gudfood Order Line";
        SalesSetup: Record "Sales & Receivables Setup";
        Customers: Record Customer;
        DimMgt: Codeunit DimensionManagement;
        DocumentNoVisability: Codeunit DocumentNoVisibility;
        NoMgt: Codeunit NoSeriesManagement;

    procedure AssistEdit(OldGudfoodOrderHeader: Record "Gudfood Order Header"): Boolean
    var
        NewGudfoodOrderHeader: Record "Gudfood Order Header";
    begin
        with NewGudfoodOrderHeader do begin
            ;
            NewGudfoodOrderHeader := Rec;
            SalesSetup.Get();
            SalesSetup.TestField("Gudfood Order Nos.");
            if NoMgt.SelectSeries(SalesSetup."Gudfood Order Nos.", OldGudfoodOrderHeader."No. Series", "No. Series") then begin
                NoMgt.SetSeries("No.");
                Rec := NewGudfoodOrderHeader;
                exit(true);
            end;
        end;
    end;

    procedure GudfoodRegLinesExist(): Boolean
    begin
        GudfoodLine.Reset();
        GudfoodLine.SetRange("Order No.", "No.");
        exit(GudfoodLine.FindFirst());
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.Get();
        TableID[1] := Type1;
        No[1] := No1;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';

        OldDimSetID := "Dimension Set ID";

        "Dimension Set ID" := DimMgt.GetDefaultDimId(TableID, No, SourceCodeSetup.GudfoodOrder, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
        if (OldDimSetID <> "Dimension Set ID") and GudfoodRegLinesExist() then begin
            Modify();
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify();
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if GudfoodRegLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" := DimMgt.EditDimensionSet("Dimension Set ID", "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if GudfoodRegLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        Text001Msg: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        NewDimSetID: Integer;
    begin
        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not Confirm(Text001Msg) then
            exit;
        GudfoodLine.Reset();
        GudfoodLine.SetRange("Order No.", "No.");
        GudfoodLine.LockTable();
        if GudfoodLine.FIND('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(GudfoodLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if GudfoodLine."Dimension Set ID" <> NewDimSetID then begin
                    GudfoodLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                    GudfoodLine."Dimension Set ID",
                    GudfoodLine."Shortcut Dimension 1 Code",
                    GudfoodLine."Shortcut Dimension 2 Code");
                    GudfoodLine.Modify();
                end;
            until GudfoodLine.Next() = 0;
    end;
}

