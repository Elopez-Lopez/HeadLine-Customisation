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
            Caption = 'Headline Position', Comment = 'ESP="Posición Cabecera"';
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
        field(5; NavigateRecord; Integer)
        {
            Caption = 'Navigate Record', Comment = 'ESP="Registro Navegación"';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = filter(Table));
        }
        field(6; NavigateView; Blob)
        {
            Caption = 'Navigate View', Comment = 'ESP="Vista Navegación"';
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

    /// <summary>
    /// Gets the saved TableView from the Blob field and returns it as Text
    /// </summary>
    procedure GetVariableRecordTableView() BlobTextContent: Text
    var
        InStr: InStream;
    begin
        Rec.CalcFields(NavigateView);
        Rec.NavigateView.CreateInStream(InStr);
        InStr.ReadText(BlobTextContent);
    end;

    /// <summary>
    /// Navigates to the specified Data Reference
    /// </summary>
    procedure NavigateToDataReference()
    var
        PageManagement: Codeunit "Page Management";
        recRef: RecordRef;
        recordView: Text;
    begin
        recRef.Open(Rec.NavigateRecord);
        recordView := GetVariableRecordTableView();
        if recordView <> '' then
            recRef.SetView(recordView);

        PageManagement.PageRun(recRef);
    end;

    local procedure FillHeadline(recCustomHeadline: Record "Custom Headline") FilledHeadLine: Text
    var
        placeholderText: Text;
        i: Integer;
    begin
        FilledHeadLine := recCustomHeadline.HeadlineText;

        recCustomHeadline.Calcfields(HeadlineVariables);
        for i := 1 to recCustomHeadline.HeadlineVariables do begin
            placeholderText := placeholderConstructor_LblTok + Format(i); // %1, %2, %3, %4, %5, %6
            if recCustomHeadline.HeadlineText.Contains(placeholderText) then begin
                FilledHeadLine := FilledHeadLine.Replace(placeholderText, GetVariableValue(recCustomHeadline, i));
            end;
        end;
    end;

    local procedure GetVariableValue(recCustomHeadline: Record "Custom Headline"; VariablePosition: Integer): Text
    var
        recHeadlineVariable: Record "Headline Variable";
    begin
        recHeadlineVariable.Get(recCustomHeadline.ProfileID, recCustomHeadline.HeadlinePosition, VariablePosition);
        exit(recHeadlineVariable.GetValue());
    end;

}