page 80100 "Headline RC Custom"
{
    Caption = 'Headline', comment = 'ESP="Saludo"';
    PageType = HeadlinePart;
    ApplicationArea = All;
    UsageCategory = None;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(HeadLine1; HeadLineArray[1])
                {
                    Visible = ShowHeadLine1;
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        NavigateToDataReference(1);
                    end;
                }
                field(HeadLine2; HeadLineArray[2])
                {
                    Visible = ShowHeadLine2;
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        NavigateToDataReference(2);
                    end;
                }
                field(HeadLine3; HeadLineArray[3])
                {
                    Visible = ShowHeadLine3;
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        NavigateToDataReference(3);
                    end;
                }
                field(HeadLine4; HeadLineArray[4])
                {
                    Visible = ShowHeadLine4;
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        NavigateToDataReference(4);
                    end;
                }
                field(HeadLine5; HeadLineArray[5])
                {
                    Visible = ShowHeadLine5;
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        NavigateToDataReference(5);
                    end;
                }
                field(HeadLine6; HeadLineArray[6])
                {
                    Visible = ShowHeadLine6;
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        NavigateToDataReference(6);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        SessionSettings: SessionSettings;
        ThisRoleID: Text;
        PopulatedHeadlines: Integer;
    begin
        SessionSettings.Init();
        ThisRoleID := SessionSettings.ProfileId;

        PopulatedHeadlines := PopulateHeadlines(ThisRoleID);
        if PopulatedHeadlines = 0 then
            LoadGreetings(ThisRoleID);

        SetupHeadlineVisibility();
    end;

    /// <summary>
    /// Populates the HeadlineArray with the Headline Texts for the specified Role.
    /// </summary>
    procedure PopulateHeadlines(RoleID: Text) PopulatedHeadlines: Integer
    var
        recCustomHeadline: Record "Custom Headline";
        ArrayIndex: Integer;
    begin
        for ArrayIndex := 1 to 6 do begin
            HeadLineArray[ArrayIndex] := recCustomHeadline.GetFilledHeadline(RoleID, ArrayIndex);
            if HeadLineArray[ArrayIndex] <> '' then
                PopulatedHeadlines += 1;
        end;
    end;

    /// <summary>
    /// Loads the Greeting Text for the specified Role in the first Headline field.
    /// </summary>
    /// <param name="RoleID">The name of the current role</param>
    procedure LoadGreetings(RoleID: Text)
    var
        AllProfile: Record "All Profile";
    begin
        AllProfile.SetRange("Profile ID", RoleID);
        if AllProfile.FindFirst() then begin
            RCHeadlinesPageCommon.HeadlineOnOpenPage(AllProfile."Role Center ID");
            HeadLineArray[1] := RCHeadlinesPageCommon.GetGreetingText();
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

    local procedure NavigateToDataReference(HeadlinePosition: Integer)
    var
        recCustomHeadline: Record "Custom Headline";
        SessionSettings: SessionSettings;
        ThisRoleID: Text;
    begin
        SessionSettings.Init();
        ThisRoleID := SessionSettings.ProfileId;
        if recCustomHeadline.Get(ThisRoleID, HeadlinePosition) then
            recCustomHeadline.NavigateToDataReference();
    end;

    var
        RCHeadlinesPageCommon: Codeunit "RC Headlines Page Common";
        HeadLineArray: array[6] of Text;
        ShowHeadLine1, ShowHeadLine2, ShowHeadLine3, ShowHeadLine4, ShowHeadLine5, ShowHeadLine6 : Boolean;
}