pageextension 80110 "Whse. Basic Role Center" extends "Whse. Basic Role Center"
{
    layout
    {
        modify(Control51)
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