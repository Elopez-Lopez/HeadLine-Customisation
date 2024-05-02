table 80102 "Headline Settings"
{
    Caption = 'Headline Settings', comment = 'ESP="Configuración de Headlines"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; PK; Code[10])
        {
            Caption = 'PK', comment = 'ESP="PK"';
        }

        field(2; RefreshHourInterval; Integer)
        {
            Caption = 'Refresh Hour Interval', comment = 'ESP="Intervalo de Refresco en Horas"';
            InitValue = 24;
        }

        field(3; RefreshMinuteInterval; Integer)
        {
            Caption = 'Refresh Minute Interval', comment = 'ESP="Intervalo de Refresco en Minutos"';
            InitValue = 0;
        }

    }

    keys
    {
        key(Key1; PK)
        {
            Clustered = true;
        }
    }

    procedure GetRefreshInterval(): Duration
    var
        HoursInMiliSeconds: Integer;
        MinutesInMiliSeconds: Integer;
    begin
        HoursInMiliSeconds := Rec.RefreshHourInterval * 3600000;
        MinutesInMiliSeconds := Rec.RefreshMinuteInterval * 60000;

        exit(HoursInMiliSeconds + MinutesInMiliSeconds);
    end;

    internal procedure GetTableFilter(TableNo: Integer; CurrentView: Text): Text
    var
        AllObjWithCaption: Record AllObjWithCaption;
        FilterPage: FilterPageBuilder;
    begin
        AllObjWithCaption.Get(ObjectType::Table, TableNo);

        FilterPage.AddTable(AllObjWithCaption."Object Name", TableNo);

        if CurrentView <> '' then
            FilterPage.SetView(AllObjWithCaption."Object Name", CurrentView);

        FilterPage.RunModal();

        exit(FilterPage.GetView(AllObjWithCaption."Object Name"));
    end;
}