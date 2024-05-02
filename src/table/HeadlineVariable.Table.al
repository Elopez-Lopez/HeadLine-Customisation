table 80101 "HeadLine Variable"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Headline Variables";

    fields
    {
        field(1; ProfileID; Code[30])
        {
            Caption = 'Profile ID', comment = 'ESP="ID Perfil"';
            TableRelation = "All Profile"."Profile ID";
        }
        field(2; HeadlinePosition; Enum "Headline Position")
        {
            Caption = 'Headline Position', comment = 'ESP="Posicion Cabecera"';
        }
        field(3; VariablePosition; Enum "Variable Position")
        {
            Caption = 'Variable ID', comment = 'ESP="ID Variable"';
        }
        field(4; VariableType; Option)
        {
            Caption = 'Variable Type', comment = 'ESP="Tipo Variable"';
            OptionMembers = Static,Dynamic;
        }
        field(5; StaticValue; Enum "Static Values")
        {
            Caption = 'Static Value', comment = 'ESP="Valor Estatico"';
        }
        field(6; "Calc. Operation"; Enum "Calc. Operation")
        {
            Caption = 'Operation', comment = 'ESP="Operacion"';
        }
        field(7; TableNo; Integer)
        {
            Caption = 'Table No.', comment = 'ESP="No. Tabla"';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = filter(Table));
        }
        field(8; FieldNo; Integer)
        {
            Caption = 'Field No.', comment = 'ESP="No. Campo"';
            TableRelation = Field."No." where(TableNo = field(TableNo));
        }
        field(9; TableView; Blob)
        {
            Caption = 'Table View', comment = 'ESP="Vista Tabla"';
        }
        field(10; CachedValue; Text[250])
        {
            Caption = 'Cached Value', comment = 'ESP="Valor Almacenado"';
        }
        field(11; CachingDate; Date)
        {
            Caption = 'Caching Date', comment = 'ESP="Fecha Almacenamiento"';
        }
        field(12; CachingTime; Time)
        {
            Caption = 'Caching Time', comment = 'ESP="Hora Almacenamiento"';
        }
        field(13; CalculationWarning; Text[250])
        {
            Caption = 'Calculation Warning', comment = 'ESP="Advertencia Calculo"';
        }
    }

    keys
    {
        key(Key1; ProfileID, HeadlinePosition, VariablePosition)
        {
            Clustered = true;
        }
    }


    /// <summary>
    /// Gets the value of the variable, if enough time has elapsed since last calculation, it recalculates the value
    /// </summary>
    /// <returns>The variable value as text</returns>
    procedure GetValue(): Text
    var
        recHeadlineSettings: Record "Headline Settings";
        ElapsedTime: Duration;
    begin

        if Rec.VariableType = VariableType::Static then
            exit(GetStaticValue());

        recHeadlineSettings.Get();

        if GetElapsedTime() > recHeadlineSettings.GetRefreshInterval() then
            CalculateValue();

        exit(Rec.CachedValue);
    end;

    /// <summary>
    /// Calculates the value of the Variable based on the specified record, operation and specified filters
    /// </summary>
    procedure CalculateValue()
    var
        Operations: Codeunit Operations;
    begin
        if Operations.Run(Rec) then
            Rec.CachedValue := Operations.GetValue()
        else
            Rec.CalculationWarning := GetLastErrorText();

        Rec.CachingDate := Today;
        Rec.CachingTime := Time;
        Rec.Modify();

        Commit(); // Commits the calculation so further Codeunit executions don't cause a transaction error
    end;

    /// <summary>
    /// Gets the saved TableView from the Blob field and returns it as Text
    /// </summary>
    procedure GetVariableRecordTableView() BlobTextContent: Text
    var
        InStr: InStream;
    begin
        Rec.CalcFields(TableView);
        Rec.TableView.CreateInStream(InStr);
        InStr.ReadText(BlobTextContent);
    end;

    local procedure GetStaticValue(): Text
    begin
        case StaticValue of
            "Static Values"::UserName:
                exit(UserId);
            "Static Values"::CompanyName:
                exit(CompanyName);
        end;
    end;

    procedure GetElapsedTime() ElapsedTime: Duration
    var
        LastCachedDateTime: DateTime;
    begin
        LastCachedDateTime := CreateDateTime(Rec.CachingDate, Rec.CachingTime);
        if (Rec.CachingDate = 0D) and (Rec.CachingTime = 0T) then
            exit(0);
        ElapsedTime := CurrentDateTime - LastCachedDateTime;
    end;
}