pageextension 80111 "Whse. WMS Role Center" extends "Whse. WMS Role Center"
{
    layout
    {
        modify(Control38)
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