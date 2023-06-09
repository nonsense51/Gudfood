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
                GudfoodItem.Get("Item No.");
                Rec."Item Type" := GudfoodItem.ItemType;
                Rec.Description := GudfoodItem.Description;
                Rec."Unit Price" := GudfoodItem."Unit Price";

                if GudfoodItem."Shelf Life" <= "Date Created" then begin
                    ProductExpireNotification.Message := text001Msg;
                    ProductExpireNotification.Scope := NOTIFICATIONSCOPE::LocalScope;
                    ProductExpireNotification.Send();
                end
                else
                    if GudfoodItem."Shelf Life" - 1 <= "Date Created" then begin
                        ProductExpireNotification.Message := text002Msg;
                        ProductExpireNotification.Scope := NOTIFICATIONSCOPE::LocalScope;
                        ProductExpireNotification.Send();
                    end;
            end;
        }
        field(6; "Item Type"; Option)
        {
            Caption = 'Item Type';
            CalcFormula = lookup("Gudfood Item".ItemType where("No." = field("Item No.")));
            FieldClass = FlowField;
            OptionMembers = " ",Salat,Burger,Cupcake,Drink;
            OptionCaption = ' ,Salat,Burger,Cupcake,Drink';
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
                ShowDimensions();
            end;
        }
    }

    keys
    {
        key(PK; "Order No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        GudfoodOrderHeader.Get("Order No.");
        "Sell- to Customer No." := GudfoodOrderHeader."Sell- to Customer No.";
        "Date Created" := GudfoodOrderHeader."Date Created";
    end;

    var
        GudfoodItem: Record "Gudfood Item";
        GudfoodOrderHeader: Record "Gudfood Order Header";
        DimensionManagement: Codeunit DimensionManagement;
        ProductExpireNotification: Notification;
        text001Msg: Label 'This product has expired!';
        text002Msg: Label 'This product has almost expired.';

    procedure ShowDimensions()
    begin
        "Dimension Set ID" := DimensionManagement.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', "Order No.", "Line No."));

        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    local procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.Get();

        TableID[1] := Type1;
        No[1] := No1;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';

        GudfoodOrderHeader.Get();
        "Dimension Set ID" := DimensionManagement.GetDefaultDimID(TableID, No, SourceCodeSetup.GudfoodOrder, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", GudfoodOrderHeader."Dimension Set ID", DATABASE::"Gudfood Item");
        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    // local procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    // begin
    //     DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
    //     ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    // end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimensionManagement.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}

