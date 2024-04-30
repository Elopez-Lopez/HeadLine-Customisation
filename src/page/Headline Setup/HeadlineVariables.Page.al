page 80102 "Headline Variables"
{
    Caption = 'Headline Variables', Comment = 'ESP="Variables de Cabecera"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
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
                }
                field(TableView; Rec.GetVariableRecordTableView())
                {
                    ToolTip = 'Specifies the value of the Table View field.', Comment = 'ESP="Filtro Tabla"';

                    trigger OnAssistEdit()
                    var
                        OutStr: OutStream;
                        NewTablefilter: Text;
                    begin
                        NewTablefilter := Rec.GetTableFilter(Rec.TableNo);

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
}