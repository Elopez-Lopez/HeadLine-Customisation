table 80100 "Custom Headline"
{
    Caption = 'Custom Headlines', Comment = 'ESP="Cabeceras Personalizadas"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; ProfileID; Code[30])
        {
            Caption = 'Profile ID', Comment = 'ESP="ID Perfil"';
            TableRelation = "All Profile"."Profile ID";
        }
        field(2; HeadlinePosition; Enum "Headline Position")
        {
            Caption = 'Headline Position', Comment = 'ESP="Posicion Cabecera"';
        }
        field(3; HeadlineText; Text[500])
        {
            Caption = 'Headline Text', Comment = 'ESP="Texto Cabecera"';
        }
        field(4; HeadlineVariables; Integer)
        {
            Caption = 'Headline Variables', Comment = 'ESP="Variables Cabecera"';
            FieldClass = FlowField;
            CalcFormula = count("HeadLine Variable" where(ProfileID = field(ProfileID), HeadlinePosition = field(HeadlinePosition)));
        }

    }

    keys
    {
        key(Key1; ProfileID, HeadlinePosition)
        {
            Clustered = true;
        }
    }

    var
        placeholderConstructor_LblTok: Label '%';


    /// <summary>
    /// Compares the number of Headline Variables with the number of placeholders in the Headline Text.
    /// </summary>
    procedure CheckHeadlineVariables(): Boolean
    var
        placeholderText: Text;
        i: Integer;
    begin
        Rec.Calcfields(HeadlineVariables);
        for i := 1 to Rec.HeadlineVariables do begin
            placeholderText := placeholderConstructor_LblTok + Format(i); // %1, %2, %3, %4, %5, %6
            if not Rec.HeadlineText.Contains(placeholderText) then
                exit(false);
        end;
        exit(true);
    end;

    /// <summary>
    /// Returns the filled Headline Text for the specified Role and Headline Position.
    /// </summary>
    procedure GetFilledHeadline(RoleID: Code[30]; HeadlinePosition: Integer): Text
    var
        recCustomHeadline: Record "Custom Headline";
    begin
        if recCustomHeadline.Get(RoleID, HeadlinePosition) then
            exit(FillHeadline(recCustomHeadline))
        else
            exit('');
    end;

    local procedure FillHeadline(recCustomHeadline: Record "Custom Headline") FilledHeadLine: Text
    var
        placeholderText: Text;
        i: Integer;
    begin
        FilledHeadLine := recCustomHeadline.HeadlineText;

        Rec.Calcfields(HeadlineVariables);
        for i := 1 to Rec.HeadlineVariables do begin
            placeholderText := placeholderConstructor_LblTok + Format(i); // %1, %2, %3, %4, %5, %6
            if Rec.HeadlineText.Contains(placeholderText) then begin
                FilledHeadLine := FilledHeadLine.Replace(placeholderText, GetVariableValue(i));
            end;
        end;
    end;

    local procedure GetVariableValue(VariablePosition: Integer): Text
    var
        recHeadlineVariable: Record "Headline Variable";
    begin
        recHeadlineVariable.Get(Rec.ProfileID, Rec.HeadlinePosition, VariablePosition);
        exit(recHeadlineVariable.GetValue());
    end;

}