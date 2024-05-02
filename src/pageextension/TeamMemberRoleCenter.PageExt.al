pageextension 80109 "Team Member Role Center" extends "Team Member Role Center"
{
    layout
    {
        modify(Control11)
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