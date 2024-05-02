page 80104 "Headline Setup"
{
    Caption = 'Headling Settings', Comment = 'ESP="Configuración Headline"';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Headline Settings";

    layout
    {
        area(Content)
        {
            group(Refresh)
            {
                Caption = 'Refresh rate', Comment = 'ESP="Tasa de refresco"';

                field(RefreshHourInterval; Rec.RefreshHourInterval)
                {
                    ToolTip = 'Specifies the value of the Refresh Hour Interval field.', Comment = 'ESP="Intervalo de Refresco en Horas"';
                }
                field(RefreshMinuteInterval; Rec.RefreshMinuteInterval)
                {
                    ToolTip = 'Specifies the value of the Refresh Minute Interval field.', Comment = 'ESP="Intervalo de Refresco en Minutos"';
                }
                field(RefreshInterval; Rec.GetRefreshInterval())
                {
                    Caption = 'Refresh Interval', Comment = 'ESP="Intervalo de Refresco"';
                    ToolTip = 'Specifies the value of the Refresh Interval field.', Comment = 'ESP="Intervalo de Refresco"';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(Headlines_Ref; Headlines) { }
        }

        area(Processing)
        {
            action(Headlines)
            {
                Caption = 'Headlines', Comment = 'ESP="Headlines"';
                ApplicationArea = All;
                Image = ShowList;
                RunObject = page "Headline List";
            }
        }
    }
}