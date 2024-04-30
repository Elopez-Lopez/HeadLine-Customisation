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
        field(5; StaticValue; Text[250])
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

            trigger OnValidate()
            var
                myInt: Integer;
            begin

            end;
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

    internal procedure GetTableFilter(TableNo: Integer): Text
    var
        AllObjWithCaption: Record AllObjWithCaption;
        FilterPage: FilterPageBuilder;
        CurrentView: Text;
    begin
        CurrentView := GetVariableRecordTableView();

        AllObjWithCaption.Get(ObjectType::Table, TableNo);

        FilterPage.AddTable(AllObjWithCaption."Object Name", TableNo);

        if CurrentView <> '' then
            FilterPage.SetView(AllObjWithCaption."Object Name", CurrentView);

        FilterPage.RunModal();

        exit(FilterPage.GetView(AllObjWithCaption."Object Name"));
    end;

    procedure GetValue(): Text
    begin
        if Rec.CachingDate < CalcDate('-1D', Today) then
            CalculateValue();

        exit(Rec.CachedValue);
    end;

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
    end;

    procedure GetVariableRecordTableView() BlobTextContent: Text
    var
        InStr: InStream;
    begin
        Rec.CalcFields(TableView);
        Rec.TableView.CreateInStream(InStr);
        InStr.ReadText(BlobTextContent);
    end;
}