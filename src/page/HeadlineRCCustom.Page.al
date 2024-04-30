page 80100 "Headline RC Custom"
{
    Caption = 'Headline', comment = 'ESP="Saludo"';
    PageType = HeadlinePart;
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(HeadLine1; HeadLineArray[1])
                {
                    Visible = ShowHeadLine1;
                }
                field(HeadLine2; HeadLineArray[2])
                {
                    Visible = ShowHeadLine2;
                }
                field(HeadLine3; HeadLineArray[3])
                {
                    Visible = ShowHeadLine3;
                }
                field(HeadLine4; HeadLineArray[4])
                {
                    Visible = ShowHeadLine4;
                }
                field(HeadLine5; HeadLineArray[5])
                {
                    Visible = ShowHeadLine5;
                }
                field(HeadLine6; HeadLineArray[6])
                {
                    Visible = ShowHeadLine6;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        SessionSettings: SessionSettings;
        ThisRoleID: Text;
    begin
        SessionSettings.Init();
        ThisRoleID := SessionSettings.ProfileId;

        PopulateHeadlines(ThisRoleID);
        SetupHeadlineVisibility();
    end;

    /// <summary>
    /// Populates the HeadlineArray with the Headline Texts for the specified Role.
    /// </summary>
    procedure PopulateHeadlines(RoleID: Text)
    var
        recCustomHeadline: Record "Custom Headline";
        ArrayIndex: Integer;
    begin
        for ArrayIndex := 1 to 6 do begin
            HeadLineArray[ArrayIndex] := recCustomHeadline.GetFilledHeadline(RoleID, ArrayIndex);
        end;

    end;

    /// <summary>
    /// Sets the visibility of the Headline fields based on the content of the HeadlineArray.
    /// </summary>
    local procedure SetupHeadlineVisibility()
    begin
        ShowHeadLine1 := HeadLineArray[1] <> '';
        ShowHeadLine2 := HeadLineArray[2] <> '';
        ShowHeadLine3 := HeadLineArray[3] <> '';
        ShowHeadLine4 := HeadLineArray[4] <> '';
        ShowHeadLine5 := HeadLineArray[5] <> '';
        ShowHeadLine6 := HeadLineArray[6] <> '';
    end;

    var
        HeadLineArray: array[6] of Text;
        ShowHeadLine1, ShowHeadLine2, ShowHeadLine3, ShowHeadLine4, ShowHeadLine5, ShowHeadLine6 : Boolean;
}