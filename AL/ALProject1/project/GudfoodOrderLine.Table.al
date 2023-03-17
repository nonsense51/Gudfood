table 50018 "Gudfood Order Line"
{
    Caption = 'Gudfood Order Line';
    DrillDownPageID = 50007;
    LookupPageID = 50007;

    fields
    {
        field(1; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            TableRelation = "Gudfood Order Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Sell- to Customer No."; Code[20])
        {
            Caption = 'Sell- to Customer No.';
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                CreateDim(DATABASE::Customer, "Sell- to Customer No.");
            end;
        }
        field(4; "Date Created"; Date)
        {
            Caption = 'Date Created';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = "Gudfood Item";

            trigger OnValidate()
            begin
                GudfdItem.GET("Item No.");
                Description := GudfdItem.Description;
                "Unit Price" := GudfdItem."Unit Price";
                "Item Type" := GudfdItem.ItemType;

                IF GudfdItem."Shelf Life" <= "Date Created" THEN BEGIN
                    ProductExpireNotification.MESSAGE := text001;
                    ProductExpireNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
                    ProductExpireNotification.SEND;
                END
                ELSE
                    IF GudfdItem."Shelf Life" - 1 <= "Date Created" THEN BEGIN
                        ProductExpireNotification.MESSAGE := text002;
                        ProductExpireNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
                        ProductExpireNotification.SEND;
                    END;
            end;
        }
        field(6; "Item Type"; Option)
        {
            CalcFormula = Lookup("Gudfood Item".ItemType WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Type';
            FieldClass = FlowField;
            OptionMembers = " ",Salat,Burger,Capcake,Drink;
            TableRelation = "Gudfood Item".ItemType;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            MinValue = 0;

            trigger OnValidate()
            begin

                Amount := Quantity * "Unit Price";
            end;
        }
        field(9; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Amount := Quantity * "Unit Price";
            end;
        }
        field(10; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
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
                ShowDimensions;
            end;
        }
    }

    keys
    {
        key(Key1; "Order No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        GudfdHeader.GET("Order No.");
        "Sell- to Customer No." := GudfdHeader."Sell- to Customer No.";
        "Date Created" := GudfdHeader."Date Created";
    end;

    var
        GudfdItem: Record "Gudfood Item";
        Keyvar: Integer;
        GudfdHeader: Record "Gudfood Order Header";
        ProductExpireNotification: Notification;
        text001: Label 'This product has expired!';
        text002: Label 'This product has almost expired.';
        DimMgt: Codeunit DimensionManagement;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" := DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', "Order No.", "Line No."));

        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    local procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.GET;

        TableID[1] := Type1;
        No[1] := No1;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';

        GudfdHeader.GET;
        "Dimension Set ID" := DimMgt.GetDefaultDimID(TableID, No, SourceCodeSetup.GudfoodOrder, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", GudfdHeader."Dimension Set ID", DATABASE::"Gudfood Item");
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    local procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}

