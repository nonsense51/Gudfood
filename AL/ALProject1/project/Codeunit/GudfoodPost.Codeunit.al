codeunit 50001 "Gudfood Post"
{
    TableNo = 50017;

    trigger OnRun()
    begin
        GudfoodLine.SETRANGE("Order No.", Rec."No.");
        GudfoodLine.FINDSET();
        PostedGdfdHeader.Init();
        GudfoodLine.CALCSUMS(Amount, Quantity);
        PostedGdfdHeader.TRANSFERFIELDS(Rec);
        PostedGdfdHeader."Total Amount" := GudfoodLine.Amount;
        PostedGdfdHeader."Total Qty" := GudfoodLine.Quantity;
        CLEAR(GudfoodLine);
        xRec.FindLast();
        IF "Posting No." = '' THEN
            IF DocumentNoVisability.ItemNoSeriesIsDefault THEN BEGIN
                SalesSetup.GET;
                NoMgt.InitSeries(SalesSetup."Posted Gudfood Order Nos.", xRec."No. Series", 0D, "Posting No.", "No. Series");
            END;
        PostedGdfdHeader.INSERT(TRUE);
        GudfoodLine.SETRANGE("Order No.", Rec."No.");
        GudfoodLine.FINDSET;
        REPEAT
            PostedGdfdLine.INIT;
            PostedGdfdLine.TRANSFERFIELDS(GudfoodLine);
            PostedGdfdLine.INSERT;
        UNTIL GudfoodLine.NEXT = 0;
        Rec.DELETE(TRUE);
    end;

    var
        PostedGdfdHeader: Record "Posted Gudfood Order Header";
        DocumentNoVisability: Codeunit DocumentNoVisibility;
        SalesSetup: Record "Sales & Receivables Setup";
        NoMgt: Codeunit NoSeriesManagement;
        GudfoodLine: Record "Gudfood Order Line";
        PostedGdfdLine: Record "Posted Gudfood Order Line";
        xRec: Record "Gudfood Order Header";
}

