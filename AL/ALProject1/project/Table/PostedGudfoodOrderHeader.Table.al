table 50019 "Posted Gudfood Order Header"
{
    Caption = 'Posted Gudfood Order Header';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Sell- to Customer No."; Code[20])
        {
            Caption = 'Sell- to Customer No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            DataClassification = ToBeClassified;
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
        }
        field(6; "Date Created"; Date)
        {
            Caption = 'Date Created';
            DataClassification = ToBeClassified;
        }
        field(7; "Total Qty"; Decimal)
        {
            Caption = 'Total Qty';
        }
        field(8; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
        }
        field(9; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(10; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(50; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(51; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(480; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions();
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

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Posting Date" := Today;
    end;

    var
        GudfoodOrderLine: Record "Gudfood Order Line";
        DimensionManagement: Codeunit DimensionManagement;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" := DimensionManagement.EditDimensionSet("Dimension Set ID", StrSubstNo('%1', "No."));

        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure GudfoodRegLinesExist(): Boolean
    begin
        GudfoodOrderLine.Reset();
        GudfoodOrderLine.SetRange("Order No.", "No.");
        exit(GudfoodOrderLine.FindFirst());
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" := DimensionManagement.EditDimensionSet("Dimension Set ID", "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
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
        if not CONFIRM(Text001Msg) then
            exit;
        GudfoodOrderLine.Reset();
        GudfoodOrderLine.SetRange("Order No.", "No.");
        GudfoodOrderLine.LockTable();
        if GudfoodOrderLine.Find('-') then
            repeat
                NewDimSetID := DimensionManagement.GetDeltaDimSetID(GudfoodOrderLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if GudfoodOrderLine."Dimension Set ID" <> NewDimSetID
                then begin
                    GudfoodOrderLine."Dimension Set ID" := NewDimSetID;
                    DimensionManagement.UpdateGlobalDimFromDimSetID(
                    GudfoodOrderLine."Dimension Set ID",
                    GudfoodOrderLine."Shortcut Dimension 1 Code",
                    GudfoodOrderLine."Shortcut Dimension 2 Code");
                    GudfoodOrderLine.Modify();
                end;
            until GudfoodOrderLine.Next() = 0;
    end;
}

