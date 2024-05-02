page 80102 "Headline Variables"
{
    Caption = 'Headline Variables', Comment = 'ESP="Variables de Cabecera"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "HeadLine Variable";

    layout
    {
        area(Content)
        {
            repeater(VariableList)
            {
                field(ProfileID; Rec.ProfileID)
                {
                    ToolTip = 'Specifies the value of the Profile ID field.', Comment = 'ESP="ID Perfil"';
                }
                field(HeadlinePosition; Rec.HeadlinePosition)
                {
                    ToolTip = 'Specifies the value of the Headline Position field.', Comment = 'ESP="Posicion Cabecera"';
                }
                field(VariableID; Rec.VariablePosition)
                {
                    ToolTip = 'Specifies the value of the Variable ID field.', Comment = 'ESP="ID Variable"';
                }
                field(VariableType; Rec.VariableType)
                {
                    ToolTip = 'Specifies the value of the VariableType field.', Comment = 'ESP="Tipo Variable"';
                }
                field(StaticValue; Rec.StaticValue)
                {
                    ToolTip = 'Specifies the value of the Static Value field.', Comment = 'ESP="Valor Estatico"';
                }
                field(VariableFormula; Rec."Calc. Operation")
                {
                    ToolTip = 'Specifies the value of the Operation field.', Comment = 'ESP="Operacion"';
                }
                field(TableNo; Rec.TableNo)
                {
                    ToolTip = 'Specifies the value of the Table No. field.', Comment = 'ESP="No. Tabla"';
                }
                field(FieldNo; Rec.FieldNo)
                {
                    ToolTip = 'Specifies the value of the Field No. field.', Comment = 'ESP="No. Campo"';

                    trigger OnAssistEdit()
                    var
                        SelectedFieldNo: Integer;
                    begin
                        if SelectField(Rec.TableNo, SelectedFieldNo) then
                            Rec.FieldNo := SelectedFieldNo;
                    end;
                }
                field(TableView; Rec.GetVariableRecordTableView())
                {
                    ToolTip = 'Specifies the value of the Table View field.', Comment = 'ESP="Filtro Tabla"';

                    trigger OnAssistEdit()
                    var
                        recHeadlineSettings: Record "Headline Settings";
                        OutStr: OutStream;
                        NewTablefilter, CurrentView : Text;
                    begin
                        CurrentView := Rec.GetVariableRecordTableView();

                        NewTablefilter := recHeadlineSettings.GetTableFilter(Rec.TableNo, CurrentView);

                        if NewTablefilter <> '' then
                            Clear(Rec.TableView);

                        Rec.TableView.CreateOutStream(OutStr);
                        OutStr.WriteText(NewTablefilter);

                        CurrPage.Update();
                    end;
                }
                field(CachedValue; Rec.CachedValue)
                {
                    ToolTip = 'Specifies the value of the Cached Value field.', Comment = 'ESP="Valor Almacenado"';
                }
                field(CachingDate; Rec.CachingDate)
                {
                    ToolTip = 'Specifies the value of the Caching Date field.', Comment = 'ESP="Fecha Almacenamiento"';
                }

                field(CachingTime; Rec.CachingTime)
                {
                    ToolTip = 'Specifies the value of the Caching Time field.', Comment = 'ESP="Hora Almacenamiento"';
                }

                field(ElapsedTime; Rec.GetElapsedTime())
                {
                    ToolTip = 'Specifies the value of the Elapsed Time field.', Comment = 'ESP="Tiempo Transcurrido"';
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(NavigateRef; Calculate) { }
        }

        area(Processing)
        {
            action(Calculate)
            {
                ApplicationArea = All;
                Image = CalculateRegenerativePlan;
                Caption = 'Calculate Variable', Comment = 'ESP="Calcular Variable"';

                trigger OnAction()
                begin
                    Rec.CalculateValue();
                end;
            }
        }
    }

    var
        ErrFieldTypeNotAllowed_Lbl: Label 'Field type %1 is not allowed.', comment = 'ESP="El tipo de campo %1 no es válido."';

    local procedure SelectField(TableNo: Integer; var SelectedFieldNo: Integer): Boolean
    var
        recField: Record Field;
        pagFieldList: Page "Field List";
    begin
        recField.SetRange(TableNo, TableNo);
        recField.SetFilter(Class, '%1|%2', recField.Class::Normal, recField.Class::FlowField);
        pagFieldList.SetTableView(recField);
        pagFieldList.LookupMode := true;
        if pagFieldList.RunModal() = Action::LookupOK then begin
            pagFieldList.GetRecord(recField);

            if not IsFieldTypeAllowed(recField) then
                Error(ErrFieldTypeNotAllowed_Lbl, recField."Type");

            SelectedFieldNo := recField."No.";
            exit(true);
        end;
        exit(false);
    end;

    local procedure IsFieldTypeAllowed(recField: Record Field): Boolean
    begin
        exit(

        recField.Type
            in
        [recField.Type::Boolean,
        recField.Type::Date,
        recField.Type::Code,
        recField.Type::DateTime,
        recField.Type::Decimal,
        recField.Type::GUID,
        recField.Type::Integer,
        recField.Type::Text,
        recField.Type::Time]

        );
    end;
}