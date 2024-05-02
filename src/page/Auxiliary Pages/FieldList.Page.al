page 80103 "Field List"
{
    Caption = 'Field List', comment = 'ESP="Lista de Campos"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Field;

    layout
    {
        area(Content)
        {
            repeater(ListField)
            {

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the ID number of the field in the table.';
                }
                field(FieldName; Rec.FieldName)
                {
                    ToolTip = 'Specifies the name of the field in the table.';
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ToolTip = 'Specifies the caption of the field, that is, the name that will be shown in the user interface.';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the type of the field in the table, which indicates the type of data it contains.';
                }
                field(Class; Rec.Class)
                {
                    ToolTip = 'Specifies the type of class. Normal is data entry, FlowFields calculate and display results immediately, and FlowFilters display results based on user-defined filter values that affect the calculation of a FlowField.';
                }
            }
        }
    }
}