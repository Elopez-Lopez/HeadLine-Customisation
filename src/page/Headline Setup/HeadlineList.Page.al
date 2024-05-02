page 80101 "Headline List"
{
    Caption = 'Headline List', Comment = 'ESP="Lista de Headlines"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Custom Headline";

    layout
    {
        area(Content)
        {
            repeater(HeadlineList)
            {
                field(ProfileID; Rec.ProfileID)
                {
                    ToolTip = 'Specifies the value of the Profile ID field.', Comment = 'ESP="ID Perfil"';
                    StyleExpr = RecStyleExpression;
                }
                field(HeadlinePosition; Rec.HeadlinePosition)
                {
                    ToolTip = 'Specifies the value of the Headline Position field.', Comment = 'ESP="Posicion Cabecera"';
                    StyleExpr = RecStyleExpression;
                }
                field(HeadlineText; Rec.HeadlineText)
                {
                    ToolTip = 'Specifies the value of the Headline Text field.', Comment = 'ESP="Texto Cabecera"';
                    StyleExpr = RecStyleExpression;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(HeadlineVariables; Rec.HeadlineVariables)
                {
                    ToolTip = 'Specifies the value of the Headline Variables field.', Comment = 'ESP="Variables Cabecera"';
                    StyleExpr = RecStyleExpression;
                }
                field(NavigateRecord; Rec.NavigateRecord)
                {
                    ToolTip = 'Specifies the value of the Navigate Record field.', Comment = 'ESP="Registro Navegación"';
                    StyleExpr = RecStyleExpression;
                }
                field(NavigateView; Rec.GetVariableRecordTableView())
                {
                    ToolTip = 'Specifies the value of the Navigate View field.', Comment = 'ESP="Vista Navegación"';
                    StyleExpr = RecStyleExpression;

                    trigger OnAssistEdit()
                    var
                        recHeadlineSettings: Record "Headline Settings";
                        OutStr: OutStream;
                        NewTablefilter, CurrentView : Text;
                    begin
                        CurrentView := Rec.GetVariableRecordTableView();

                        NewTablefilter := recHeadlineSettings.GetTableFilter(Rec.NavigateRecord, CurrentView);

                        if NewTablefilter <> '' then
                            Clear(Rec.NavigateView);

                        Rec.NavigateView.CreateOutStream(OutStr);
                        OutStr.WriteText(NewTablefilter);

                        CurrPage.Update();
                    end;
                }
                field(WarningNote; WarningNote)
                {
                    ToolTip = 'Specifies the value of the Warning Note field.', Comment = 'ESP="Nota Advertencia"';
                    StyleExpr = RecStyleExpression;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(Navigateref; Navigate) { }
        }

        area(Processing)
        {
            action(Navigate)
            {
                ApplicationArea = All;
                Image = Navigate;
                RunObject = page "Headline Variables";
                RunPageLink = ProfileID = field(ProfileID), HeadlinePosition = field(HeadlinePosition);
            }
        }
    }

    protected var
        RecStyleExpression, WarningNote : Text;
        PlaceHolderWarning_Lbl: Label 'The number of placeholders in the text should match the number of variables.', comment = 'ESP="El numero de placeholders del texto debe coincidir con el numero de variables."';

    trigger OnAfterGetRecord()
    begin
        if not Rec.CheckHeadlineVariables() then begin
            RecStyleExpression := 'Ambiguous';
            WarningNote := PlaceHolderWarning_Lbl;
        end else begin
            RecStyleExpression := 'None';
            WarningNote := '';
        end;
    end;
}