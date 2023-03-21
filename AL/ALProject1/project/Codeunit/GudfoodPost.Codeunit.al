codeunit 50001 "Gudfood Post"
{
    TableNo = 50017;

    trigger OnRun()
    begin
        GudfoodLine.SetRange("Order No.", Rec."No.");
        GudfoodLine.Findset();
        PostedGdfdHeader.Init();
        GudfoodLine.CalcSums(Amount, Quantity);
        PostedGdfdHeader.TransferFields(Rec);
        PostedGdfdHeader."Total Amount" := GudfoodLine.Amount;
        PostedGdfdHeader."Total Qty" := GudfoodLine.Quantity;
        CLEAR(GudfoodLine);
        xRec.FindLast();
        if Rec."Posting No." = '' THEN
            IF DocumentNoVisability.ItemNoSeriesIsDefault() THEN BEGIN
                "Sales&ReceivablesSetup".Get();
                NoMgt.InitSeries("Sales&ReceivablesSetup"."Posted Gudfood Order Nos.", xRec."No. Series", 0D, Rec."Posting No.", Rec."No. Series");
            END;
        PostedGdfdHeader.Insert(TRUE);
        GudfoodLine.SETRANGE("Order No.", Rec."No.");
        GudfoodLine.FindSet();
        REPEAT
            PostedGudfoodOrderLine.Init();
            PostedGudfoodOrderLine.TransferFields(GudfoodLine);
            PostedGudfoodOrderLine.Insert();
        UNTIL GudfoodLine.Next() = 0;
        Rec.DELETE(TRUE);
    end;

    var
        PostedGdfdHeader: Record "Posted Gudfood Order Header";
        "Sales&ReceivablesSetup": Record "Sales & Receivables Setup";
        GudfoodLine: Record "Gudfood Order Line";
        PostedGudfoodOrderLine: Record "Posted Gudfood Order Line";
        xRec: Record "Gudfood Order Header";
        DocumentNoVisability: Codeunit DocumentNoVisibility;
        NoMgt: Codeunit NoSeriesManagement;

}

