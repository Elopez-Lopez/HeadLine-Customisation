pageextension 80112 "Whse. Worker WMS Role Center" extends "Whse. Worker WMS Role Center"
{
    layout
    {
        modify(Control7)
        {
            Visible = false;
        }
        addfirst(rolecenter)
        {
            part(CustomHeadline; "Headline RC Custom")
            {
                ApplicationArea = All;
            }
        }
    }
}